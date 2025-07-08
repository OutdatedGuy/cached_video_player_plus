# Migration Guide: v3.x.x → v4.0.0

This guide will help you migrate from `cached_video_player_plus` v3.x.x to v4.0.0.

## Overview

Version 4.0.0 introduces a major API restructure that simplifies usage while maintaining all existing functionality. The package now uses a class-based approach instead of the previous controller-widget pattern.

## 🚨 Breaking Changes

### 1. API Architecture Change

**Before (v3.x.x):**

```dart
// Old controller + widget pattern
final controller = CachedVideoPlayerPlusController.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
);
await controller.initialize();

// Widget usage
CachedVideoPlayerPlus(controller)
```

**After (v4.0.0):**

```dart
// New class-based approach
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
);
await player.initialize();

// Widget usage
VideoPlayer(player.controller)
```

### 2. Removed Classes and Files

The following classes and files have been removed:

- ❌ `CachedVideoPlayerPlusController` → Use `CachedVideoPlayerPlus`
- ❌ `CachedVideoPlayerPlusValue` → Use `VideoPlayerValue` from `video_player`
- ❌ `CachedVideoPlayerPlus` widget → Use `VideoPlayer` from `video_player`
- ❌ `ClosedCaptionFile` implementations → Use `video_player` implementations
- ❌ `SubRipCaptionFile` → Use `video_player` equivalent
- ❌ `WebVTTCaptionFile` → Use `video_player` equivalent

### 3. Constructor Changes

**Network Videos:**

```dart
// Before
CachedVideoPlayerPlusController.networkUrl(url, ...)

// After
CachedVideoPlayerPlus.networkUrl(url, ...)
```

**Asset Videos:**

```dart
// Before
CachedVideoPlayerPlusController.asset(path, ...)

// After
CachedVideoPlayerPlus.asset(path, ...)
```

**File Videos:**

```dart
// Before
CachedVideoPlayerPlusController.file(file, ...)

// After
CachedVideoPlayerPlus.file(file, ...)
```

**Content URI Videos:**

```dart
// Before
CachedVideoPlayerPlusController.contentUri(uri, ...)

// After
CachedVideoPlayerPlus.contentUri(uri, ...)
```

### 4. Method Name Changes

- ❌ `removeCurrentFileFromCache()` → ✅ `removeFromCache()`

### 5. Parameter Type Changes

- ❌ `removeFileFromCache(String url)` → ✅ `removeFileFromCache(Uri url)`

### 6. Import Changes

**Before:**

```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// All classes were available directly
```

**After:**

```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart'; // For VideoPlayer widget
```

## 🔄 Step-by-Step Migration

### Step 1: Update Dependencies

Update your `pubspec.yaml`:

```yaml
dependencies:
  cached_video_player_plus: ^4.0.0
  video_player: ^2.10.0 # Add this if not already present
```

### Step 2: Update Imports

```dart
// Add video_player import if using VideoPlayer widget
import 'package:video_player/video_player.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
```

### Step 3: Replace Controller with Class

**Before:**

```dart
class _VideoPageState extends State<VideoPage> {
  late CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse('https://example.com/video.mp4'),
      invalidateCacheIfOlderThan: const Duration(days: 420),
    );
    _controller.initialize().then((_) {
      _controller.play();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CachedVideoPlayerPlus(_controller),
          )
        : const CircularProgressIndicator();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

**After:**

```dart
class _VideoPageState extends State<VideoPage> {
  late CachedVideoPlayerPlus _player;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse('https://example.com/video.mp4'),
      invalidateCacheIfOlderThan: const Duration(days: 420),
    );
    _player.initialize().then((_) {
      _player.controller.play();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _player.isInitialized
        ? AspectRatio(
            aspectRatio: _player.controller.value.aspectRatio,
            child: VideoPlayer(_player.controller),
          )
        : const CircularProgressIndicator();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
```

### Step 4: Update Method Calls

**Cache Management:**

```dart
// Before
await controller.removeCurrentFileFromCache();

// After
await player.removeFromCache();
```

**Static Cache Removal:**

```dart
// Before
await CachedVideoPlayerPlus.removeFileFromCache('https://example.com/video.mp4');

// After
await CachedVideoPlayerPlus.removeFileFromCache(Uri.parse('https://example.com/video.mp4'));
```

**Video Operations:**

```dart
// Before
controller.play();
controller.pause();
controller.setVolume(0.69);

// After
player.controller.play();
player.controller.pause();
player.controller.setVolume(0.69);
```

**State Checking:**

```dart
// Before
controller.value.isInitialized
controller.value.isPlaying

// After
player.isInitialized
player.controller.value.isPlaying
```

## 🌐 Web Platform Notes

Web platform behavior remains the same:

- Caching is not supported on web
- Use `Cache-Control` headers for browser-level caching
- All other functionality works normally

```dart
// Web caching workaround (unchanged)
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {
    'Cache-Control': 'max-age=80085',
  },
);
```

## 🔧 Common Migration Issues

### Issue 1: Widget Not Found

**Error:** `CachedVideoPlayerPlus widget not found`

**Solution:** Replace with `VideoPlayer`:

```dart
// Before
CachedVideoPlayerPlus(controller)

// After
VideoPlayer(player.controller)
```

### Issue 2: Controller Methods Not Available

**Error:** `Method 'play' not found on CachedVideoPlayerPlus`

**Solution:** Access methods through the controller:

```dart
// Before
player.play()

// After
player.controller.play()
```

### Issue 3: Import Errors

**Error:** `VideoPlayer widget not found`

**Solution:** Add video_player import:

```dart
import 'package:video_player/video_player.dart';
```

### Issue 4: Parameter Type Errors

**Error:** `The argument type 'String' can't be assigned to the parameter type 'Uri'`

**Solution:** Wrap string URLs with `Uri.parse()`:

```dart
// Before
await CachedVideoPlayerPlus.removeFileFromCache('https://example.com/video.mp4');

// After
await CachedVideoPlayerPlus.removeFileFromCache(Uri.parse('https://example.com/video.mp4'));
```

## 📚 Complete Example

Here's a complete working example for v4.0.0:

```dart
import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerExample extends StatefulWidget {
  const VideoPlayerExample({super.key});

  @override
  State<VideoPlayerExample> createState() => _VideoPlayerExampleState();
}

class _VideoPlayerExampleState extends State<VideoPlayerExample> {
  late CachedVideoPlayerPlus player;

  @override
  void initState() {
    super.initState();
    player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      invalidateCacheIfOlderThan: const Duration(days: 420),
    );

    player.initialize().then((_) {
      player.controller.setLooping(true);
      player.controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cached Video Player Plus')),
      body: Center(
        child: player.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: player.controller.value.aspectRatio,
                    child: VideoPlayer(player.controller),
                  ),
                  const SizedBox(height: 42),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          player.controller.value.isPlaying
                              ? player.controller.pause()
                              : player.controller.play();
                          setState(() {});
                        },
                        icon: Icon(
                          player.controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      IconButton(
                        onPressed: () => player.removeFromCache(),
                        icon: const Icon(Icons.delete),
                        tooltip: 'Clear Cache',
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

```

## 🚀 Benefits of Migration

After migrating to v4.0.0, you'll benefit from:

1. **Simpler API**: Less boilerplate code and more intuitive usage
2. **Better Performance**: Optimized caching logic and debug mode checks
3. **Improved Documentation**: Comprehensive docs for all APIs
4. **Future-Proof**: Built on modern Flutter patterns and best practices
5. **Better Maintainability**: Cleaner codebase with separation of concerns

## 🆘 Need Help?

If you encounter issues during migration:

1. Check this migration guide thoroughly
2. Review the [example app](example/) for working code
3. Check [existing issues](https://github.com/OutdatedGuy/cached_video_player_plus/issues)
4. Create a new issue with:
   - Your current v3.x.x code
   - What you tried for v4.0.0
   - The specific error messages

---

_This migration guide covers all major changes. For detailed API documentation, see the package documentation._
