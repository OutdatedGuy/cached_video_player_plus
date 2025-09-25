/// The [video_player] plugin that went to therapy, worked on its commitment
/// issues, and now actually remembers your videos!
///
/// ## Basic Usage
///
/// ```dart
/// final player = CachedVideoPlayerPlus.networkUrl(
///   Uri.parse('https://example.com/video.mp4'),
///   invalidateCacheIfOlderThan: const Duration(days: 42),
/// );
///
/// await player.initialize();
/// // Use player.controller for video operations
/// ```
///
/// [video_player]: https://pub.dev/packages/video_player
library;

export 'src/cached_video_player_plus.dart';
export 'src/i_video_player_metadata_storage.dart';
export 'src/video_cache_manager.dart';
export 'src/video_player_metadata_storage.dart';
