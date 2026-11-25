<div align="center">
  <h3>🧠 Created by the developer of Brink: Psychological Warfare</h3>
  <p>
    <em>"Can you find the sweet spot between bold and delusional?"</em><br />
    Support the maintenance of this package by checking out my latest indie
    game!
  </p>

  <p>
    <a
      href="https://play.google.com/store/apps/details?id=rocks.outdatedguy.brink"
      target="_blank"
    >
      <img
        src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg"
        width="200"
        alt="Get it on Google Play"
      />
    </a>
    &nbsp;
    <a href="https://apps.apple.com/app/id6753995293" target="_blank">
      <img
        src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg"
        width="200"
        alt="Download on the App Store"
      />
    </a>
  </p>
</div>

---

# Cached Video Player Plus

[![pub package][package_svg]][package] [![GitHub][license_svg]](LICENSE)

`cached_video_player_plus` wraps [`video_player`][video_player] and caches network
videos with [`flutter_cache_manager`][flutter_cache_manager]. Cached videos can
be played from local storage when available.

## Migration from v3

Version 4 changes the player API and metadata storage. See the
[v3-to-v4 migration guide][migration_guide] for the changes and migration steps.

## Features

- Cache network videos for later playback.
- Pre-cache videos before creating a player.
- Configure cache expiration, custom cache keys, cache managers, and metadata
  storage.
- Remove an individual cached video or clear the whole cache.
- Set separate HTTP headers for playback and downloads.

## 📱 Live Demos

See `cached_video_player_plus` in action across different platforms:

| Basic Playback (Android)  | Chewie Integration (iOS)  |
| :-----------------------: | :-----------------------: |
| ![Android Basic Playback] | ![iOS Chewie Integration] |

| Pre-Caching (macOS)  |
| :------------------: |
| ![macOS Pre-Caching] |

| Advanced Cache Management (Windows) |
| :---------------------------------: |
| ![Windows Advance Cache Management] |

## Installation

Add the package and `video_player` to your `pubspec.yaml`:

```yaml
dependencies:
  cached_video_player_plus: ^4.1.0
  video_player: ^2.10.1
```

Follow the [`video_player` setup guide][setup] for platform-specific setup.

> [!NOTE]
>
> **Windows & Linux Playback**: While caching works perfectly on
> Windows and Linux, video playback requires additional packages:
>
> - **Windows**: Use [video_player_win] or [video_player_media_kit]
> - **Linux**: Use [video_player_media_kit]
>
> Follow the instructions in the respective package documentation to set up
> playback.

## Usage

Create and initialize a player, then pass its controller to `VideoPlayer`:

```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:video_player/video_player.dart';

class VideoExample extends StatefulWidget {
  const VideoExample({super.key});

  @override
  State<VideoExample> createState() => _VideoExampleState();
}

class _VideoExampleState extends State<VideoExample> {
  late final CachedVideoPlayerPlus _player;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _player.initialize();
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

Call playback methods through `_player.controller`, for example
`_player.controller.play()`.

## 💝 Support the Project

If this package saved you from the eternal spinning wheel of video buffering,
consider buying me a coffee! ☕

<a href="https://coff.ee/outdatedguy" target="_blank">
  <img
    src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png"
    alt="Buy Me A Coffee"
    height="102"
    width="363"
  />
</a>

## Advanced Configuration

### Web Platform Notes

Web doesn't support file caching, but you can hack around it:

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {
    'Cache-Control': 'max-age=80085',
  },
);
```

### Cache expiration

Network videos are cached by default and cache entries expire after 69 days.
When no valid cached file is available, the package starts downloading the video
in the background. Set `skipCache` to `true` to bypass caching.

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  invalidateCacheIfOlderThan: const Duration(days: 42),
);
```

### Pre-caching

Pre-cache a video without creating a player:

```dart
await CachedVideoPlayerPlus.preCacheVideo(
  Uri.parse('https://example.com/next-video.mp4'),
  invalidateCacheIfOlderThan: const Duration(days: 42),
  downloadHeaders: {'Authorization': 'Bearer token'},
);
```

### Custom cache keys

Provide a key when creating or pre-caching a player. Use the same key to remove
that cached video:

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  cacheKey: 'video-1',
);

await CachedVideoPlayerPlus.removeFileFromCacheByKey('video-1');
```

### Cache management

```dart
await player.removeFromCache();
await CachedVideoPlayerPlus.removeFileFromCache(
  Uri.parse('https://example.com/video.mp4'),
);
await CachedVideoPlayerPlus.clearAllCache();
```

### Custom cache manager and metadata storage

Pass a `CacheManager` and an implementation of `IVideoPlayerMetadataStorage` to
use custom storage.

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final cacheManager = CacheManager(
  Config(
    'video_cache',
    stalePeriod: const Duration(days: 67),
    maxNrOfCacheObjects: 100,
  ),
);

final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  cacheManager: cacheManager,
  metadataStorage: customMetadataStorage,
);
```

`customMetadataStorage` must implement `IVideoPlayerMetadataStorage`, including
its `keys`, `read`, `write`, `remove`, and `erase` members. The same manager and
storage can be set globally through `CachedVideoPlayerPlus.cacheManager` and
`CachedVideoPlayerPlus.metadataStorage` before creating player instances. These
global fields are not thread-safe; set them during app initialization.

### HTTP headers

`httpHeaders` are used for playback. Use `downloadHeaders` to provide different
headers for the cache download; when omitted, `httpHeaders` are also used for
the download.

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {'Authorization': 'Bearer playback-token'},
  downloadHeaders: {'Authorization': 'Bearer download-token'},
);
```

## Limitations

Caching applies to network videos on non-web platforms.

HLS (`.m3u8`), live, and DASH streams are not supported for caching. Use
progressive video file URLs when caching is required. See [issue #22][issue_22].

## If you liked the package, then please give it a [Like 👍🏼][package] and [Star ⭐][repository]

<!-- Badges URLs -->

[package_svg]: https://img.shields.io/pub/v/cached_video_player_plus.svg?color=blueviolet
[license_svg]: https://img.shields.io/github/license/OutdatedGuy/cached_video_player_plus.svg?color=purple

<!-- Links -->

[package]: https://pub.dev/packages/cached_video_player_plus
[repository]: https://github.com/OutdatedGuy/cached_video_player_plus
[video_player]: https://pub.dev/packages/video_player
[flutter_cache_manager]: https://pub.dev/packages/flutter_cache_manager
[video_player_win]: https://pub.dev/packages/video_player_win
[video_player_media_kit]: https://pub.dev/packages/video_player_media_kit
[setup]: https://pub.dev/packages/video_player#setup
[migration_guide]: MIGRATION-v3-to-v4.md
[issue_22]: https://github.com/OutdatedGuy/cached_video_player_plus/issues/22

<!-- Demos -->

[Android Basic Playback]: screenshots/Android-Basic-Playback.webp
[iOS Chewie Integration]: screenshots/iOS-Chewie-Integration.webp
[macOS Pre-Caching]: screenshots/macOS-Pre-Caching.webp
[Windows Advance Cache Management]: screenshots/Windows-Advance-Cache-Management.webp
