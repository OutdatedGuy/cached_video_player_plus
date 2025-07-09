# Migration Guide: v3.x.x → v4.0.0 🎬

This guide will help you migrate from `cached_video_player_plus` v3.x.x to v4.0.0.

## Overview

Version 4.0.0 introduces a major API restructure that simplifies usage while maintaining all existing functionality. The package now uses a class-based approach instead of the previous controller-widget pattern.

_Translation: We Marie Kondo'd the API - everything that doesn't spark joy got yeeted into the digital void!_ ✨🗑️

## 💿 Storage Migration: get_storage → shared_preferences

Version 4.0.0 migrates from `get_storage` to `shared_preferences` for storing cached video metadata. This change improves compatibility and reduces dependencies.

### 🔄 Automatic Migration

The package includes an automatic migration utility that preserves your existing cached video data:

```dart
import 'package:cached_video_player_plus/util/migration_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Migrate cached video data from get_storage to shared_preferences
  // This must be called before runApp() to ensure data is available
  await migrateCachedVideoDataToSharedPreferences();

  runApp(MyApp());
}
```

### ⚠️ Important Migration Notes

1. **Call migration before runApp()**: The migration function must be called and awaited before `runApp()` to ensure cached data is available.

2. **One-time migration**: The migration automatically tracks completion and won't run multiple times.

3. **Debug output**: In debug mode, you'll see console output indicating how many cache entries were migrated.

4. **Automatic cleanup**: After successful migration, the old get_storage data is automatically cleared.

_Don't worry, we'll clean up after ourselves - unlike that one roommate who never does the dishes._ 🧽✨

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

_RIP to these classes. They lived, they served, they got replaced by something better. Circle of code life! 🦁👑_

### 3. Constructor Changes

All constructor patterns have changed from the controller-based approach to the class-based approach:

```dart
// Before (v3.x.x)
// Network videos
final controller = CachedVideoPlayerPlusController.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {'Authorization': 'Bearer token'},
);

// Asset videos
final controller = CachedVideoPlayerPlusController.asset(
  'assets/videos/sample.mp4',
  package: 'my_package',
);

// File videos
final controller = CachedVideoPlayerPlusController.file(
  File('/path/to/video.mp4'),
);

// Content URI videos (Android)
final controller = CachedVideoPlayerPlusController.contentUri(
  Uri.parse('content://media/external/video/media/1'),
);
```

```dart
// After (v4.0.0)
// Network videos
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {'Authorization': 'Bearer token'},
);

// Asset videos
final player = CachedVideoPlayerPlus.asset(
  'assets/videos/sample.mp4',
  package: 'my_package',
);

// File videos
final player = CachedVideoPlayerPlus.file(
  File('/path/to/video.mp4'),
);

// Content URI videos (Android)
final player = CachedVideoPlayerPlus.contentUri(
  Uri.parse('content://media/external/video/media/1'),
);
```

### 4. Deprecated Constructor Removal

The deprecated `CachedVideoPlayerPlusController.network()` constructor has been completely removed in v4.0.0:

```dart
// Before (v3.x.x) - This was already deprecated
CachedVideoPlayerPlusController.network('https://example.com/video.mp4')

// Use this instead (available in both v3.x.x and v4.0.0)
CachedVideoPlayerPlus.networkUrl(Uri.parse('https://example.com/video.mp4'))
```

_We finally put the deprecated constructor out of its misery. It had a good run, but even old dogs need to learn new tricks... or get replaced entirely! 🐕➡️🤖_

### 5. Default Cache Duration Change

**⚠️ IMPORTANT:** The default cache expiration duration has changed:

```dart
// Before (v3.x.x)
invalidateCacheIfOlderThan: const Duration(days: 30)  // Default was 30 days

// After (v4.0.0)
invalidateCacheIfOlderThan: const Duration(days: 69)  // Default is now 69 days
```

This means cached videos will be kept longer by default. If you want to maintain the old behavior, explicitly set `invalidateCacheIfOlderThan: const Duration(days: 30)`.

_Yes, we changed the default to 69 days. No, it's not a typo. Yes, we're adults who find this number funny. Nice! 😎_

### 6. Method Name Changes

- ❌ `removeCurrentFileFromCache()` → ✅ `removeFromCache()`

### 7. Parameter Type Changes

- ❌ `removeFileFromCache(String url)` → ✅ `removeFileFromCache(Uri url)`

### 8. New Methods Added

v4.0.0 introduces several new methods not available in v3.x.x:

- ✅ `removeFileFromCacheByKey(String cacheKey)` - Remove cached files by custom cache key
- ✅ `preCacheVideo(Uri url)` - Pre-cache videos without creating a player instance

### 9. Constructor Parameter Changes

**New Parameters in v4.0.0:**

- ✅ `downloadHeaders` - Separate headers for downloading vs streaming
- ✅ `cacheKey` - Custom cache key instead of URL-based key
- ✅ `cacheManager` - Custom cache manager instance

_More parameters = more power = more responsibility. With great caching comes great configurability! 🕷️💪_

### 10. Controller Access Changes - Using .controller Property

The biggest change in v4.0.0 is that most video operations now require accessing the `.controller` property. Here's what you need to know:

**Video Control Methods:**

```dart
// Before (v3.x.x) - Direct access to controller methods
controller.play();
controller.pause();
controller.setVolume(0.69);
controller.seekTo(Duration(seconds: 30));
controller.setLooping(true);
```

```dart
// After (v4.0.0) - Access through .controller property
player.controller.play();
player.controller.pause();
player.controller.setVolume(0.69);
player.controller.seekTo(Duration(seconds: 30));
player.controller.setLooping(true);
```

**State and Value Access:**

```dart
// Before (v3.x.x)
controller.value.isInitialized;
controller.value.isPlaying;
controller.value.position;
controller.value.duration;
controller.value.aspectRatio;
controller.value.hasError;
controller.value.errorDescription;
```

```dart
// After (v4.0.0)
player.isInitialized;                    // Convenience property (new!)
player.controller.value.isPlaying;       // Through controller
player.controller.value.position;        // Through controller
player.controller.value.duration;        // Through controller
player.controller.value.aspectRatio;     // Through controller
player.controller.value.hasError;        // Through controller
player.controller.value.errorDescription; // Through controller
```

**Event Listeners:**

```dart
// Before (v3.x.x)
controller.addListener(() {
  // Handle state changes
  if (controller.value.hasError) {
    print('Error: ${controller.value.errorDescription}');
  }
});
controller.removeListener(listener);
```

```dart
// After (v4.0.0)
player.controller.addListener(() {
  // Handle state changes
  if (player.controller.value.hasError) {
    print('Error: ${player.controller.value.errorDescription}');
  }
});
player.controller.removeListener(listener);
```

**Widget Usage:**

```dart
// Before (v3.x.x)
Widget build(BuildContext context) {
  return controller.value.isInitialized
      ? AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CachedVideoPlayerPlus(controller),
        )
      : CircularProgressIndicator();
}
```

```dart
// After (v4.0.0)
Widget build(BuildContext context) {
  return player.isInitialized
      ? AspectRatio(
          aspectRatio: player.controller.value.aspectRatio,
          child: VideoPlayer(player.controller),
        )
      : CircularProgressIndicator();
}
```

### 11. Import Changes

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
      // Note: Default is now 69 days, explicitly set to 30 if you want old behavior
      invalidateCacheIfOlderThan: const Duration(days: 30),
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
player.isInitialized                    // Convenience property
player.controller.value.isPlaying
```

**Listeners:**

```dart
// Before
controller.addListener(myListener);
controller.removeListener(myListener);

// After
player.controller.addListener(myListener);
player.controller.removeListener(myListener);
```

**Error Handling:**

```dart
// Before
if (controller.value.hasError) {
  print(controller.value.errorDescription);
}

// After
if (player.controller.value.hasError) {
  print(player.controller.value.errorDescription);
}
```

## 🌐 Web Platform Notes

Web platform behavior remains the same:

- Caching is not supported on web
- Use `Cache-Control` headers for browser-level caching
- All other functionality works normally

_Web be like: "Caching? Never heard of her!" But hey, at least the rest works! 🌐🤷‍♀️_

```dart
// Web caching workaround (unchanged)
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {
    'Cache-Control': 'max-age=80085', // Time-tested caching duration
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

_The controller is shy now. You need to ask nicely through the `.controller` property! 🙈_

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

### Issue 5: Default Cache Duration Behavior

**Error:** Videos being cached longer than expected

**Explanation:** The default cache duration changed from 30 days to 69 days.

**Solution:** Explicitly set the duration if you want the old behavior:

```dart
// To maintain v3.x.x behavior
CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  invalidateCacheIfOlderThan: const Duration(days: 30),
)
```

_Your videos are now living longer in cache. It's like digital immortality, but for cat videos! 🐱👻_

### Issue 6: Old Cache Not Recognized

**Error:** Previously cached videos not being used

**Explanation:** The cache key format changed between versions.

**Solution:** Use the migration utility:

```dart
import 'package:cached_video_player_plus/util/migration_utils.dart';

await migrateCachedVideoDataToSharedPreferences();
```

### Issue 7: Listener Not Working

**Error:** Video state changes not being detected

**Solution:** Add listeners to the controller, not the player:

```dart
// Before
player.addListener(myListener);

// After
player.controller.addListener(myListener);
```

### Issue 8: Missing Controller Access

**Error:** `StateError: CachedVideoPlayerPlus is not initialized`

**Solution:** Always call `initialize()` before accessing the controller:

```dart
await player.initialize();
// Now you can access player.controller
```

### Issue 9: Deprecated Constructor Usage

**Error:** `CachedVideoPlayerPlusController.network` not found

**Explanation:** The deprecated `.network()` constructor was removed.

**Solution:** Use `.networkUrl()` instead:

```dart
// Before (this was deprecated in v3.x.x and removed in v4.0.0)
CachedVideoPlayerPlusController.network('https://example.com/video.mp4')

// After
CachedVideoPlayerPlus.networkUrl(Uri.parse('https://example.com/video.mp4'))
```

## 📚 Complete Example

Here's a complete working example for v4.0.0 that demonstrates the new features:

_This example contains more features than a Swiss Army knife and is 42% more awesome than the previous version!_ 🔪✨

```dart
import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:cached_video_player_plus/util/migration_utils.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Migrate cached data from v3.x.x if needed
  await migrateCachedVideoDataToSharedPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Video Player Plus v4.0.0 Demo',
      home: VideoPlayerExample(),
    );
  }
}

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

    // Example with new v4.0.0 features
    player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      // Default is now 69 days, set to 30 if you want old v3.x.x behavior
      invalidateCacheIfOlderThan: const Duration(days: 420),
      // New v4.0.0 feature: custom cache key
      cacheKey: 'big_buck_bunny_demo',
      // New v4.0.0 feature: separate download headers
      httpHeaders: {
        'User-Agent': 'MyApp/1.0',
        'Range': 'bytes=0-1024',
      },
      downloadHeaders: {
        'User-Agent': 'MyApp/1.0',
      },
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

  // Example of using new v4.0.0 features
  Future<void> _preCacheAnotherVideo() async {
    await CachedVideoPlayerPlus.preCacheVideo(
      Uri.parse('https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4'),
      cacheKey: 'sample_video',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video pre-cached successfully!')),
      );
    }
  }

  Future<void> _clearAllCache() async {
    await CachedVideoPlayerPlus.clearAllCache();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All cache cleared!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cached Video Player Plus v4.0.0')),
      body: Center(
        child: player.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: player.controller.value.aspectRatio,
                    child: VideoPlayer(player.controller),
                  ),
                  const SizedBox(height: 42), // The answer to life, universe, and spacing
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
                        tooltip: 'Clear This Video Cache',
                      ),
                      IconButton(
                        onPressed: _preCacheAnotherVideo,
                        icon: const Icon(Icons.download),
                        tooltip: 'Pre-cache Another Video',
                      ),
                      IconButton(
                        onPressed: _clearAllCache,
                        icon: const Icon(Icons.clear_all),
                        tooltip: 'Clear All Cache',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Video Status: ${player.controller.value.isPlaying ? "Playing" : "Paused"}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Position: ${player.controller.value.position}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
```

## ✨ New Features in v4.0.0

v4.0.0 introduces several new features that weren't available in v3.x.x:

_New features! Like getting surprise extra fries at the bottom of the bag, but for code! 🍟💻_

### 1. Pre-caching Videos

Cache videos before playing them:

```dart
// Pre-cache a video without creating a player instance
await CachedVideoPlayerPlus.preCacheVideo(
  Uri.parse('https://example.com/video.mp4'),
  invalidateCacheIfOlderThan: const Duration(days: 420),
);
```

### 2. Custom Cache Keys

Use custom cache keys instead of URL-based keys:

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  cacheKey: 'my_custom_video_key',
);

// Remove by custom key
await CachedVideoPlayerPlus.removeFileFromCacheByKey('my_custom_video_key');
```

### 3. Separate Download Headers

Use different headers for downloading vs streaming:

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {
    'Range': 'bytes=0-1024',  // For streaming
  },
  downloadHeaders: {
    'Authorization': 'Bearer token',  // For downloading full file
  },
);
```

### 4. Custom Cache Manager

Provide your own cache manager instance:

```dart
final customCacheManager = CacheManager(
  Config(
    'my_custom_cache',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 80085, // For optimal... viewing experience
  ),
);

final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  cacheManager: customCacheManager,
);
```

## 🚀 Benefits of Migration

After migrating to v4.0.0, you'll benefit from:

1. **Simpler API**: Less boilerplate code and more intuitive usage
2. **Better Performance**: Optimized caching logic and debug mode checks
3. **Improved Documentation**: Comprehensive docs for all APIs
4. **Future-Proof**: Built on modern Flutter patterns and best practices
5. **Better Maintainability**: Cleaner codebase with separation of concerns

_Basically, your code will be so clean, Marie Kondo would be proud! Plus, your future self will thank you (and maybe buy you coffee)._ ☕✨

## 🆘 Need Help?

If you encounter issues during migration:

1. Check this migration guide thoroughly
2. Review the [example app](example/) for working code
3. Check [existing issues](https://github.com/OutdatedGuy/cached_video_player_plus/issues)
4. Create a new issue with:
   - Your current v3.x.x code
   - What you tried for v4.0.0
   - The specific error messages

_Remember: There are no stupid questions, only poorly documented APIs. We're here to help! 🤝💙_

---

_This migration guide covers all major changes. For detailed API documentation, see the package documentation._

_P.S. Thanks for migrating! You're awesome! 🌟_ ✨
