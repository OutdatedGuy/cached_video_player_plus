# Migration Guide: v3 to v4

Version 4 replaces the v3 controller-and-widget API with a
`CachedVideoPlayerPlus` wrapper around [`video_player`][video_player], and
switches cache metadata storage from [`get_storage`][get_storage] to
[`shared_preferences`][shared_preferences].

## Metadata storage migration

Call and await `migrateCachedVideoDataToSharedPreferences()` before `runApp()`
to preserve cached video metadata from v3:

```dart
import 'package:cached_video_player_plus/util/migration_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await migrateCachedVideoDataToSharedPreferences();
  runApp(const MyApp());
}
```

- **Runs once**: Completion is tracked automatically so subsequent app launches
  skip the migration.
- **Automatic cleanup**: Existing `get_storage` entries are removed after a
  successful migration.
- **Debug logging**: In debug mode, the utility logs the number of migrated
  cache entries.
- **Cache key prefix**: The internal metadata key prefix changed from
  `cached_video_player_plus_video_expiration_of_` to
  `cached_video_player_plus_caching_time_of_`. This is handled automatically and
  requires no code changes.

## Breaking changes

### Removed classes and replacements

| Removed in v4                     | Replacement in v4                       |
| :-------------------------------- | :-------------------------------------- |
| `CachedVideoPlayerPlusController` | `CachedVideoPlayerPlus`                 |
| `CachedVideoPlayerPlus` (widget)  | `VideoPlayer` from `video_player`       |
| `CachedVideoPlayerPlusValue`      | `VideoPlayerValue` from `video_player`  |
| `ClosedCaptionFile`               | `ClosedCaptionFile` from `video_player` |
| `SubRipCaptionFile`               | `SubRipCaptionFile` from `video_player` |
| `WebVTTCaptionFile`               | `WebVTTCaptionFile` from `video_player` |

### Constructors

Replace `CachedVideoPlayerPlusController` constructors with
`CachedVideoPlayerPlus`. The deprecated `.network(String)` constructor has been
removed; use `.networkUrl(Uri)` instead.

```dart
// Before (v3)
CachedVideoPlayerPlusController.network('[https://example.com/video.mp4](https://example.com/video.mp4)'); // removed
CachedVideoPlayerPlusController.networkUrl(
  Uri.parse('[https://example.com/video.mp4](https://example.com/video.mp4)'),
  httpHeaders: {'Authorization': 'Bearer token'},
);
CachedVideoPlayerPlusController.asset(
  'assets/videos/sample.mp4',
  package: 'my_package',
);
CachedVideoPlayerPlusController.file(File('/path/to/video.mp4'));
CachedVideoPlayerPlusController.contentUri(
  Uri.parse('content://media/external/video/media/1'),
);

// After (v4)
CachedVideoPlayerPlus.networkUrl(
  Uri.parse('[https://example.com/video.mp4](https://example.com/video.mp4)'),
  httpHeaders: {'Authorization': 'Bearer token'},
);
CachedVideoPlayerPlus.asset(
  'assets/videos/sample.mp4',
  package: 'my_package',
);
CachedVideoPlayerPlus.file(File('/path/to/video.mp4'));
CachedVideoPlayerPlus.contentUri(
  Uri.parse('content://media/external/video/media/1'),
);
```

### Controller access

Playback controls, state values, and listeners now live on `player.controller`
rather than on the player instance directly. Use `player.isInitialized` to check
initialization state.

> [!NOTE]
>
> Always await `player.initialize()` before accessing `player.controller`.
> Reading `player.controller` before initialization completes throws a
> `StateError`.

### Cache methods

- `controller.removeCurrentFileFromCache()` was renamed to
  `player.removeFromCache()`.
- `CachedVideoPlayerPlus.removeFileFromCache(String url)` now takes a `Uri`
  instead of a `String`.

### Default cache expiration

The default `invalidateCacheIfOlderThan` duration changed from 30 days to 69
days. Pass `invalidateCacheIfOlderThan: const Duration(days: 30)` explicitly to
retain the v3 default.

## Step-by-step migration

### 1. Update dependencies

Add `video_player` alongside `cached_video_player_plus` in `pubspec.yaml`:

```yaml
dependencies:
  cached_video_player_plus: ^4.1.0
  video_player: ^2.10.1
```

### 2. Update imports

Import `video_player` wherever you use `VideoPlayer`, `VideoPlayerValue`, or
caption classes:

```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';
```

### 3. Migrate widget usage

**Before (v3):**

```dart
class _VideoPageState extends State<VideoPage> {
  late final CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse('[https://example.com/video.mp4](https://example.com/video.mp4)'),
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _controller.initialize();
    await _controller.play();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CachedVideoPlayerPlus(_controller),
    );
  }
}
```

**After (v4):**

```dart
class _VideoPageState extends State<VideoPage> {
  late final CachedVideoPlayerPlus _player;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse('[https://example.com/video.mp4](https://example.com/video.mp4)'),
      // Optional: set explicitly to retain the v3 default of 30 days.
      invalidateCacheIfOlderThan: const Duration(days: 30),
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _player.initialize();
    await _player.controller.play();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_player.isInitialized) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return AspectRatio(
      aspectRatio: _player.controller.value.aspectRatio,
      child: VideoPlayer(_player.controller),
    );
  }
}
```

### 4. Update playback, listener, and cache calls

```dart
// Playback controls
// Before: controller.play(); / pause(); / setVolume(0.5); / seekTo(...); / setLooping(true);
player.controller.play();
player.controller.pause();
player.controller.setVolume(0.5);
player.controller.seekTo(const Duration(seconds: 30));
player.controller.setLooping(true);

// State and error checks
// Before: controller.value.isInitialized / controller.value.isPlaying / controller.value.hasError
player.isInitialized;
player.controller.value.isPlaying;
player.controller.value.position;
player.controller.value.duration;
player.controller.value.aspectRatio;
player.controller.value.hasError;
player.controller.value.errorDescription;

// Listeners
// Before: controller.addListener(listener); / controller.removeListener(listener);
player.controller.addListener(listener);
player.controller.removeListener(listener);

// Cache removal
// Before: await controller.removeCurrentFileFromCache();
await player.removeFromCache();

// Before: await CachedVideoPlayerPlus.removeFileFromCache('[https://example.com/video.mp4](https://example.com/video.mp4)');
await CachedVideoPlayerPlus.removeFileFromCache(
  Uri.parse('[https://example.com/video.mp4](https://example.com/video.mp4)'),
);
```

## Common issues

| Issue / Error | Fix |
| :------------ | :-- |
| `CachedVideoPlayerPlus` widget not found | Replace with `VideoPlayer(player.controller)` and import `package:video_player/video_player.dart`. |
| `VideoPlayer` widget not found | Add `import 'package:video_player/video_player.dart';` and declare `video_player` in `pubspec.yaml`. |
| Method like `play()` or `addListener()` not found on `CachedVideoPlayerPlus` | Call playback methods and register listeners on `player.controller`. |
| `StateError: CachedVideoPlayerPlus is not initialized` | Await `player.initialize()` before accessing `player.controller`. |
| `String` cannot be assigned to `Uri` in `removeFileFromCache` | Wrap the URL string with `Uri.parse(...)`. |
| `CachedVideoPlayerPlusController.network` not found | Use `CachedVideoPlayerPlus.networkUrl(Uri.parse(...))`. |
| Previously cached v3 videos are not reused | Call and await `migrateCachedVideoDataToSharedPreferences()` before `runApp()`. |
| Videos stay cached longer than in v3 | Explicitly set `invalidateCacheIfOlderThan: const Duration(days: 30)`. |

For full working examples, see the [example app][example]. If you run into
migration issues not covered here, check or open an issue on [GitHub][issues].

<!-- Links -->

[example]: example/
[issues]: https://github.com/OutdatedGuy/cached_video_player_plus/issues
[video_player]: https://pub.dev/packages/video_player
[get_storage]: https://pub.dev/packages/get_storage
[shared_preferences]: https://pub.dev/packages/shared_preferences
