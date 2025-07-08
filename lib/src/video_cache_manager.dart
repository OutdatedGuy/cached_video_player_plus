// Third Party Packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'cached_video_player_plus.dart';

/// A specialized cache manager for video files.
///
/// Extends [CacheManager] with singleton pattern to ensure consistent video
/// file caching across the application. This class is primarily used internally
/// by [CachedVideoPlayerPlus] and typically doesn't need direct usage.
class VideoCacheManager extends CacheManager {
  /// The unique identifier used for this cache manager's storage.
  ///
  /// This key ensures that cached video files are stored separately from
  /// other cached content in the application. All video files cached by
  /// [CachedVideoPlayerPlus] will use this storage key.
  static const key = 'libCachedVideoPlayerPlusData';

  /// The singleton instance of [VideoCacheManager].
  ///
  /// This ensures that all video caching operations use the same cache
  /// manager instance, providing consistency and preventing conflicts.
  ///
  /// Access this instance through the factory constructor [VideoCacheManager()].
  static final VideoCacheManager _instance = VideoCacheManager._();

  /// Returns the singleton instance of [VideoCacheManager].
  ///
  /// This factory constructor ensures that only one instance of the cache
  /// manager exists throughout the application lifecycle.
  factory VideoCacheManager() => _instance;

  /// Creates a new [VideoCacheManager] instance.
  ///
  /// This private constructor initializes the cache manager with the
  /// predefined configuration [key]. It's called only once to create the
  /// singleton instance.
  VideoCacheManager._() : super(Config(key));
}
