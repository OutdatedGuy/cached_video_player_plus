/// The [video_player] plugin with the SUPER-POWER of caching using
/// [flutter_cache_manager].
///
/// ## Basic Usage
///
/// ```dart
/// final player = CachedVideoPlayerPlus.networkUrl(
///   Uri.parse('https://example.com/video.mp4'),
///   invalidateCacheIfOlderThan: const Duration(days: 420),
/// );
///
/// await player.initialize();
/// // Use player.controller for video operations
/// ```
///
/// [video_player]: https://pub.dev/packages/video_player
/// [cached_video_player_plus]: https://pub.dev/packages/cached_video_player_plus
library;

export 'src/cached_video_player_plus.dart';
