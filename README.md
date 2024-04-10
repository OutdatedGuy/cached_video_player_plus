# Cached Video Player Plus

The [video_player] plugin with the SUPER-POWER of caching using
[flutter_cache_manager].

[![pub package][package_svg]][package]
[![GitHub][license_svg]](LICENSE)

[![GitHub issues][issues_svg]][issues]
[![GitHub issues closed][issues_closed_svg]][issues_closed]

<hr />

## Getting Started

### 1. Add dependency

Add the `cached_video_player_plus` package to your `pubspec.yaml` file:

```yaml
dependencies:
  cached_video_player_plus: ^2.0.0
```

### 2. Follow the installation instructions

Follow the installation [instructions of video_player][instructions] plugin.

### 3. Import the package

Import the `cached_video_player_plus` package into your Dart file:

```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
```

### 4. Using the package (Android, iOS & macOS)

#### If you are already using the [video_player] plugin

1. Use the `CachedVideoPlayerPlusController` class instead of the
   `VideoPlayerController`.
1. Use the `CachedVideoPlayerPlus` class instead of the `VideoPlayer`.
1. Use the `CachedVideoPlayerPlusValue` class instead of the
   `VideoPlayerValue`.

#### If you are not using the [video_player] plugin

1. Create a `CachedVideoPlayerPlusController` instance and initialize it.

   ```dart
   final controller = CachedVideoPlayerPlusController.networkUrl(
     Uri.parse(
       'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
     ),
     invalidateCacheIfOlderThan: const Duration(days: 69),
   )..initialize().then((value) async {
       controller.play();
       setState(() {});
     });
   ```

2. Pass the controller to the `CachedVideoPlayerPlus` widget.

   ```dart
   CachedVideoPlayerPlus(controller),
   ```

   OR

   ```dart
   return Scaffold(
     body: Center(
       child: controller.value.isInitialized
           ? AspectRatio(
               aspectRatio: controller.value.aspectRatio,
               child: CachedVideoPlayerPlus(controller),
             )
           : const CircularProgressIndicator.adaptive(),
     ),
   );
   ```

3. Caching is only supported if the `CachedVideoPlayerPlusController`
   initialization method is `network()` or `networkUrl()`.

### 5. Using the package (Web)

The web platform does not support caching. So, the plugin will use the
[video_player] plugin for the web platform.

However, to achieve caching on the web platform, you can use the workaround
of defining `Cache-Control` headers in the `httpHeaders` parameter of the
`CachedVideoPlayerPlusController.network()` method.

```dart
final controller = CachedVideoPlayerPlusController.networkUrl(
  Uri.parse(
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  ),
  httpHeaders: {
    'Cache-Control': 'max-age=3600',
  },
)..initialize().then((value) async {
    controller.play();
    setState(() {});
  });
```

## How does it work?

When the `initialize()` method is called, the package checks if the video file
is cached or not. A video file is identified by its **URL**. If the video file
is not cached, then it is downloaded and cached. If the video file is cached,
then it is played from the cache.

If the cached video file is older than the specified
`invalidateCacheIfOlderThan` parameter, then the cached video file is deleted
and a new video file is downloaded and cached.

When cache of a video is not found, the video will be played from the network
and will be cached in the background to be played from the cache the next time.

### If you liked the package, then please give it a [Like 👍🏼][package] and [Star ⭐][repository]

<!-- Badges URLs -->

[package_svg]: https://img.shields.io/pub/v/cached_video_player_plus.svg?color=blueviolet
[license_svg]: https://img.shields.io/github/license/OutdatedGuy/cached_video_player_plus.svg?color=purple
[issues_svg]: https://img.shields.io/github/issues/OutdatedGuy/cached_video_player_plus.svg
[issues_closed_svg]: https://img.shields.io/github/issues-closed/OutdatedGuy/cached_video_player_plus.svg?color=green

<!-- Links -->

[package]: https://pub.dev/packages/cached_video_player_plus
[repository]: https://github.com/OutdatedGuy/cached_video_player_plus
[issues]: https://github.com/OutdatedGuy/cached_video_player_plus/issues
[issues_closed]: https://github.com/OutdatedGuy/cached_video_player_plus/issues?q=is%3Aissue+is%3Aclosed
[video_player]: https://pub.dev/packages/video_player
[flutter_cache_manager]: https://pub.dev/packages/flutter_cache_manager
[instructions]: https://pub.dev/packages/video_player#installation
