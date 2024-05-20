// Third Party Packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// The [VideoCacheManager] is a specialized [CacheManager] for videos cached
/// using the [cached_video_player_plus] package.
///
/// [cached_video_player_plus]: https://pub.dev/packages/cached_video_player_plus
class VideoCacheManager extends CacheManager {
  /// The key used to store the [VideoCacheManager] in the [CacheManager].
  static const key = 'libCachedVideoPlayerPlusData';

  /// The singleton instance of the [VideoCacheManager].
  static final VideoCacheManager _instance = VideoCacheManager._();

  /// Returns the singleton instance of the [VideoCacheManager].
  factory VideoCacheManager() => _instance;

  /// Creates a new instance of the [VideoCacheManager].
  VideoCacheManager._() : super(Config(key));
}
