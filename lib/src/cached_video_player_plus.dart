import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

import 'video_cache_manager.dart';

/// Global cache manager for video file caching operations.
final _cacheManager = VideoCacheManager();

/// Global storage for cache metadata and expiration timestamps.
final _storage = GetStorage('cached_video_player_plus');

/// Generates a storage key for the given [dataSource].
String _getCacheKey(String dataSource) {
  return 'cached_video_player_plus_video_expiration_of_${Uri.parse(dataSource)}';
}

class CachedVideoPlayerPlus {
  /// Constructs a [CachedVideoPlayerPlus] playing a video from an asset.
  ///
  /// The name of the asset is given by the [dataSource] argument and must not
  /// be null. The [package] argument must be non-null when the asset comes from
  /// a package and null otherwise.
  ///
  /// The [viewType] option allows the caller to request a specific display mode
  /// for the video. Platforms that do not support the request view type will
  /// ignore this parameter.
  ///
  /// Asset videos do not support caching and will bypass cache operations.
  CachedVideoPlayerPlus.asset(
    this.dataSource, {
    this.package,
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.viewType = VideoViewType.textureView,
  }) : dataSourceType = DataSourceType.asset,
       formatHint = null,
       httpHeaders = const <String, String>{},
       invalidateCacheIfOlderThan = Duration.zero,
       skipCache = true;

  /// Constructs a [CachedVideoPlayerPlus] playing a video from a network URL.
  ///
  /// The URI for the video is given by the [url] argument.
  ///
  /// **Android only**: The [formatHint] option allows the caller to override
  /// the video format detection code.
  ///
  /// [httpHeaders] option allows to specify HTTP headers for the request to the
  /// [url].
  ///
  /// The [invalidateCacheIfOlderThan] parameter controls cache expiration.
  /// Videos cached before this duration will be re-downloaded. Defaults to 69
  /// days.
  ///
  /// Set [skipCache] to true to bypass caching and always use the network.
  CachedVideoPlayerPlus.networkUrl(
    Uri url, {
    this.formatHint,
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.httpHeaders = const <String, String>{},
    this.viewType = VideoViewType.textureView,
    this.invalidateCacheIfOlderThan = const Duration(days: 69),
    this.skipCache = false,
  }) : dataSource = url.toString(),
       dataSourceType = DataSourceType.network,
       package = null;

  /// Constructs a [CachedVideoPlayerPlus] playing a video from a file.
  ///
  /// This will load the file from a file:// URI constructed from [file]'s path.
  /// [httpHeaders] option allows to specify HTTP headers, mainly used for hls
  /// files like (m3u8).
  ///
  /// File videos do not support caching and will bypass cache operations.
  CachedVideoPlayerPlus.file(
    File file, {
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.httpHeaders = const <String, String>{},
    this.viewType = VideoViewType.textureView,
  }) : dataSource = Uri.file(file.absolute.path).toString(),
       dataSourceType = DataSourceType.file,
       package = null,
       formatHint = null,
       invalidateCacheIfOlderThan = Duration.zero,
       skipCache = true;

  /// Constructs a [CachedVideoPlayerPlus] playing a video from a contentUri.
  ///
  /// This will load the video from the input content-URI.
  /// This is supported on Android only.
  ///
  /// ContentUri videos do not support caching and will bypass cache operations.
  CachedVideoPlayerPlus.contentUri(
    Uri contentUri, {
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.viewType = VideoViewType.textureView,
  }) : assert(
         defaultTargetPlatform == TargetPlatform.android,
         'CachedVideoPlayerPlus.contentUri is only supported on Android.',
       ),
       dataSource = contentUri.toString(),
       dataSourceType = DataSourceType.contentUri,
       package = null,
       formatHint = null,
       httpHeaders = const <String, String>{},
       invalidateCacheIfOlderThan = Duration.zero,
       skipCache = true;

  /// The URI to the video file. This will be in different formats depending on
  /// the [DataSourceType] of the original video.
  final String dataSource;

  /// HTTP headers used for the request to the [dataSource].
  /// Only for [CachedVideoPlayerPlus.networkUrl].
  /// Always empty for other video types.
  final Map<String, String> httpHeaders;

  /// **Android only**. Will override the platform's generic file format
  /// detection with whatever is set here.
  final VideoFormat? formatHint;

  /// Describes the type of data source this [VideoPlayerController]
  /// is constructed with.
  final DataSourceType dataSourceType;

  /// Provide additional configuration options (optional). Like setting the
  /// audio mode to mix.
  final VideoPlayerOptions? videoPlayerOptions;

  /// Only set for [CachedVideoPlayerPlus.asset] videos. The package that the
  /// asset was loaded from.
  final String? package;

  /// The closed caption file to be used with the video.
  ///
  /// This is only used if the video player supports closed captions.
  final Future<ClosedCaptionFile>? closedCaptionFile;

  /// The requested display mode for the video.
  ///
  /// Platforms that do not support the request view type will ignore this.
  final VideoViewType viewType;

  /// If the requested network video is cached already, checks if the cache is
  /// older than the provided [Duration] and re-fetches data.
  final Duration invalidateCacheIfOlderThan;

  /// If set to true, it will skip the cache and use the video from the network.
  final bool skipCache;

  /// The underlying video player controller that handles actual video playback.
  late VideoPlayerController _videoPlayerController;

  /// The controller for the video player.
  ///
  /// This provides access to the underlying [VideoPlayerController] for video
  /// playback operations like play, pause, seek, and accessing video state.
  ///
  /// Throws an [Exception] if the controller is not initialized. Always call
  /// [initialize] before accessing this property.
  VideoPlayerController get controller {
    if (!_isInitialized) {
      throw Exception(
        'CachedVideoPlayerPlus is not initialized. '
        'Call initialize() before accessing the controller.',
      );
    }
    return _videoPlayerController;
  }

  /// Whether the [CachedVideoPlayerPlus] instance is initialized.
  bool _isInitialized = false;

  /// Returns true if the [CachedVideoPlayerPlus] instance is initialized.
  ///
  /// This getter indicates whether [initialize] has been successfully called
  /// and the video player is ready for use.
  bool get isInitialized => _isInitialized;

  /// Returns true if caching is supported and [skipCache] is false.
  ///
  /// Caching is only supported for network data sources. Asset, file, and
  /// contentUri data sources always return false.
  bool get _shouldUseCache =>
      dataSourceType == DataSourceType.network && !skipCache;

  /// Initializes the video player and sets up caching if applicable.
  ///
  /// This method must be called before accessing the [controller] or playing
  /// the video. It handles cache checking, file downloading, and creates the
  /// appropriate [VideoPlayerController] based on the data source type.
  ///
  /// For network videos, it checks if a cached version exists and whether it
  /// has expired based on [invalidateCacheIfOlderThan]. If no cache exists or
  /// the cache is expired, it downloads the video in the background.
  ///
  /// Returns a [Future] that completes when initialization is finished.
  Future<void> initialize() async {
    if (_isInitialized) {
      if (kDebugMode) {
        debugPrint('CachedVideoPlayerPlus is already initialized.');
      }
      return;
    }

    await _storage.initStorage;

    late String realDataSource;
    bool isCacheAvailable = false;

    if (_shouldUseCache) {
      FileInfo? cachedFile = await _cacheManager.getFileFromCache(dataSource);

      if (kDebugMode) {
        debugPrint(
          'Cached video of [$dataSource] is: ${cachedFile?.file.path}',
        );
      }

      if (cachedFile != null) {
        final cachedElapsedMillis = _storage.read(_getCacheKey(dataSource));

        if (cachedElapsedMillis != null) {
          final now = DateTime.timestamp();
          final cachedDate = DateTime.fromMillisecondsSinceEpoch(
            cachedElapsedMillis,
          );
          final difference = now.difference(cachedDate);

          if (kDebugMode) {
            debugPrint(
              'Cache for [$dataSource] valid till: '
              '${cachedDate.add(invalidateCacheIfOlderThan)}',
            );
          }

          if (difference > invalidateCacheIfOlderThan) {
            if (kDebugMode) {
              debugPrint('Cache of [$dataSource] expired. Removing...');
            }
            _cacheManager.removeFile(dataSource);
            cachedFile = null;
          }
        } else {
          if (kDebugMode) {
            debugPrint('Cache of [$dataSource] expired. Removing...');
          }
          _cacheManager.removeFile(dataSource);
          cachedFile = null;
        }
      }

      if (cachedFile == null) {
        _cacheManager.downloadFile(dataSource, authHeaders: httpHeaders).then((
          _,
        ) {
          _storage.write(
            _getCacheKey(dataSource),
            DateTime.timestamp().millisecondsSinceEpoch,
          );
          if (kDebugMode) {
            debugPrint('Cached video [$dataSource] successfully.');
          }
        });
      } else {
        isCacheAvailable = true;
      }

      realDataSource = isCacheAvailable
          ? cachedFile!.file.absolute.path
          : dataSource;
    } else {
      realDataSource = dataSource;
    }

    _videoPlayerController = switch (dataSourceType) {
      DataSourceType.asset => VideoPlayerController.asset(
        realDataSource,
        package: package,
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        viewType: viewType,
      ),
      DataSourceType.network when !isCacheAvailable =>
        VideoPlayerController.networkUrl(
          Uri.parse(realDataSource),
          formatHint: formatHint,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
          httpHeaders: httpHeaders,
          viewType: viewType,
        ),
      DataSourceType.contentUri => VideoPlayerController.contentUri(
        Uri.parse(realDataSource),
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        viewType: viewType,
      ),
      _ => VideoPlayerController.file(
        File(realDataSource),
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        httpHeaders: httpHeaders,
        viewType: viewType,
      ),
    };

    return _videoPlayerController.initialize().then((_) {
      _isInitialized = true;
    });
  }

  /// Disposes of the video player and releases resources.
  ///
  /// Call this method when the video player is no longer needed to free up
  /// resources and prevent memory leaks.
  void dispose() {
    if (_isInitialized) {
      _videoPlayerController.dispose();
    }
  }

  /// Removes the cached file for this video player's data source.
  ///
  /// This only applies to network videos. Calling this method on asset, file,
  /// or contentUri videos has no effect since they don't use caching.
  ///
  /// The cached video file and its metadata will be permanently deleted.
  Future<void> removeFromCache() async {
    await _storage.initStorage;

    await Future.wait([
      _cacheManager.removeFile(dataSource),
      _storage.remove(_getCacheKey(dataSource)),
    ]);
  }

  /// Removes the cached file for the specified [url] from the cache.
  ///
  /// This is a static method that can be called without creating an instance.
  /// Use this to remove specific cached videos by their URL.
  ///
  /// The [url] parameter should be the original network URL of the video.
  /// This method has no effect if the URL is not found in the cache.
  ///
  /// Both the cached video file and its expiration metadata are deleted.
  static Future<void> removeFileFromCache(String url) async {
    await _storage.initStorage;

    url = Uri.parse(url).toString();

    await Future.wait([
      _cacheManager.removeFile(url),
      _storage.remove('cached_video_player_plus_video_expiration_of_$url'),
    ]);
  }

  /// Clears all cached videos and their metadata.
  ///
  /// This is a static method that removes all cached video files and
  /// associated expiration data from storage. Use this to free up storage
  /// space or reset the cache state.
  ///
  /// This operation cannot be undone. All videos will need to be
  /// re-downloaded from their original sources.
  static Future<void> clearAllCache() async {
    await _storage.initStorage;

    await Future.wait([_cacheManager.emptyCache(), _storage.erase()]);
  }
}
