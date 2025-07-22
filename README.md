# Cached Video Player Plus

The [video_player] plugin that went to therapy, worked on its commitment issues, and now actually remembers your videos! 🧠  
Powered by the magic of [flutter_cache_manager] - because buffering wheels are so 2010.

_Like `video_player`, but with a photographic memory and trust issues with the internet._ 📹✨

[![pub package][package_svg]][package]
[![GitHub][license_svg]](LICENSE)

[![GitHub issues][issues_svg]][issues]
[![GitHub issues closed][issues_closed_svg]][issues_closed]

<hr />

**Cache videos seamlessly for offline playback**  
**🚀 Zero buffering on repeat views** _(your users will love you for this!)_  
**Drop-in replacement for `video_player`** _(well, mostly - see migration guide!)_  
**📱 Cross-platform support** _(Android, iOS, macOS, Web\*, Linux\*, Windows\*)_

## ✨ What's New in v4

We Marie Kondo'd the entire API! Everything that didn't spark joy got yeeted into the digital void! ✨🗑️

- **Cleaner API**: Less boilerplate, more magic
- **Pre-caching**: Cache videos before you even need them
- **Custom cache keys**: Because URLs are overrated
- **Better migration**: Your v3 cache won't vanish into the void
- **More humor**: 42% funnier error messages

> [!CAUTION]
>
> **🚨 BREAKING CHANGES AHEAD!**
>
> Version 4 introduces a total API restructuring, adding new features while maintaining all functionality. These changes introduce major breaking changes.

## Migrating from v3.x.x?

Don't panic! We've got you covered. Check out our **📖 [Migration Guide]** - it's actually entertaining to read and includes:

- **Complete API reference changes**
- **Step-by-step migration instructions**
- **Common issues and solutions**
- 😂 **Memes and jokes** _(because migration should be fun!)_

## 📱 Live Demos

See `cached_video_player_plus` in action across different platforms:

| Basic Playback (Android)  | Chewie Integration (iOS)  |
| :-----------------------: | :-----------------------: |
| ![Android Basic Playback] | ![iOS Chewie Integration] |

| Pre-Caching (macOS)  | Advanced Cache Management (Windows) |
| :------------------: | :---------------------------------: |
| ![macOS Pre-Caching] | ![Windows Advance Cache Management] |

## 🚀 Quick Start

### 1. Add to pubspec.yaml

```yaml
dependencies:
  cached_video_player_plus: ^4.0.1+1
  video_player: ^2.10.0 # Don't forget this one!
```

### 2. Follow `video_player` setup

Follow the [video_player setup guide][setup] because we're standing on the shoulders of giants here! 🏔️

### 3. Import and use

```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';
```

### 4. Create your cached player

```dart
class VideoExample extends StatefulWidget {
  const VideoExample({super.key});

  @override
  _VideoExampleState createState() => _VideoExampleState();
}

class _VideoExampleState extends State<VideoExample> {
  late final CachedVideoPlayerPlus _player;

  @override
  void initState() {
    super.initState();

    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
      invalidateCacheIfOlderThan: const Duration(minutes: 69), // Nice!
    );

    _player.initialize().then((_) {
      setState(() {});
      _player.controller.play();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _player.isInitialized
            ? AspectRatio(
                aspectRatio: _player.controller.value.aspectRatio,
                child: VideoPlayer(_player.controller), // Note: VideoPlayer from video_player package!
              )
            : const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
```

## 🌍 Platform Support

|  Platform   | Caching | Playback | Notes                                    |
| :---------: | :-----: | :------: | :--------------------------------------- |
| **Android** |   ✅    |    ✅    | Full support _(chef's kiss!)_            |
|   **iOS**   |   ✅    |    ✅    | Full support                             |
|  **macOS**  |   ✅    |    ✅    | Full support                             |
|   **Web**   |  ✅\*   |    ✅    | Uses browser cache _(meh...)_            |
|  **Linux**  |   ✅    |   ✅\*   | Caching works, playback needs workaround |
| **Windows** |   ✅    |   ✅\*   | Caching works, playback needs workaround |

> [!NOTE]
>
> **Windows & Linux Playback Workaround**: While caching works perfectly on Windows and Linux, video playback requires additional packages:
>
> - **Windows**: Use [video_player_win] or [video_player_media_kit]
> - **Linux**: Use [video_player_media_kit]
>
> Follow the instructions in the respective package documentation to set up playback.

### Web Platform Notes

Web doesn't support file caching (because browser security is a party pooper 🎉🚫), but you can hack around it:

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
  httpHeaders: {
    'Cache-Control': 'max-age=80085', // Time-tested cache duration
  },
);
```

### WASM Support ✨

Flutter's WebAssembly (WASM) compilation is now supported! To use WASM compilation, you'll need to override the `get_storage` dependency since the original doesn't support WASM _(because some packages are like that one friend who refuses to upgrade their phone)_:

```yaml
dependency_overrides:
  get_storage:
    git:
      url: https://github.com/OutdatedGuy/get_storage.git
      ref: rewrite
```

## 🎯 Advanced Features

### Pre-caching Videos

Cache videos before your users even know they want them! _(Mind reader level: 100)_

```dart
// Pre-cache a video for instant playback later
await CachedVideoPlayerPlus.preCacheVideo(
  Uri.parse('https://example.com/next-video.mp4'),
  invalidateCacheIfOlderThan: const Duration(days: 42),
);
```

### Custom Cache Keys

Because sometimes URLs are longer than a CVS receipt:

```dart
final player = CachedVideoPlayerPlus.networkUrl(
  Uri.parse('https://example.com/super-long-url-with-tokens.mp4?v=123456'),
  cacheKey: 'my_awesome_video', // Much cleaner!
);
```

### Cache Management

Take control of your cache like a digital Marie Kondo:

```dart
// Remove specific video from cache
await CachedVideoPlayerPlus.removeFileFromCache(
  Uri.parse('https://example.com/video.mp4'),
);

// Remove by custom cache key
await CachedVideoPlayerPlus.removeFileFromCacheByKey('my_awesome_video');

// Nuclear option: clear everything
await CachedVideoPlayerPlus.clearAllCache(); // *POOF* 💨
```

## 🚨 Known Issues _(aka "It's not a bug, it's a feature!")_

### 1. `flutter_cache_manager` Override Required

If you're seeing cache files not deleting properly or multiple downloads of the same video:

```yaml
dependency_overrides:
  flutter_cache_manager:
    git:
      url: https://github.com/Baseflow/flutter_cache_manager.git
      path: flutter_cache_manager
      ref: 54904e499a06d0364a2b3f4ca9789e5f829f1879
```

### 2. HLS and Streaming Videos Not Supported

Sorry folks, HLS streams are like unicorns - beautiful but not cacheable! 🦄

- ❌ `.m3u8` files (HLS streams)
- ❌ Live streams
- ❌ DASH streams
- ✅ Regular video files (`.mp4`, `.mov`, etc.)

**Workaround**: Use progressive download URLs instead of streaming URLs when possible.

[Related Issue #22][issue #22]

### 3. Videos Saved as .bin Files

If your cached videos show up as `.bin` files instead of proper video files, here's the community-tested workaround:

**Root Cause**: The issue occurs when servers don't provide proper `Content-Type` headers for video files, causing `flutter_cache_manager` to save them with generic `.bin` extensions.

**Solution**: Override the file extension in your `flutter_cache_manager` configuration:

```yaml
dependency_overrides:
  flutter_cache_manager:
    git:
      url: https://github.com/Oliver-WJ/flutter_cache_manager.git
      path: flutter_cache_manager
```

For more details, check out the [issue #40] and [workaround comment]

_Credit to the community detectives who tracked this down!_ 🕵️‍♂️

## 🔧 How It Works

When you call `initialize()`, here's what happens behind the scenes:

1. **Check cache**: "Do we have this video already?"
2. **Download if needed**: "Nope? Let's grab it!"
3. **Play from cache**: "Got it? Play from local storage!"
4. **Check expiry**: "Is this video older than my last haircut?"
5. **Re-download if stale**: "Yep, time for a refresh!"

The magic happens in the background - your users just see buttery smooth playback! 🧈

## 💝 Support the Project

If this package saved you from the eternal spinning wheel of video buffering, consider buying me a coffee! ☕

<a href="https://www.buymeacoffee.com/Outdatedguy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

_Every coffee helps fuel late-night coding sessions and the occasional existential crisis about naming variables._ 🤔☕

## 📚 Examples

Check out our [example app](example/) for real-world usage patterns:

- **Basic Playback**: Simple video caching
- **Chewie Integration**: Rich player UI with caching
- **Pre-caching**: Download videos before playback
- **Advanced Cache Management**: Fine-tune your cache behavior

## 🤝 Contributing

Found a bug? Have a feature request? Want to add more easter eggs to our documentation?

1. [Check existing issues][issues]
2. [Report bugs][issues_report_bug]
3. [Request features][issues_request_feature]
4. [Submit PRs][pull_requests]

_All contributions welcome! Even if it's just fixing our terrible jokes in the docs._ 😅

## 📜 License

BSD 3-Clause License - see [LICENSE](LICENSE) file for details.

_TL;DR: Use it, modify it, share it, just don't blame us if your cat videos take over the world._ 🐱🌍

## If you liked the package, then please give it a [Like 👍🏼][package] and [Star ⭐][repository]

_Your support keeps this project alive and helps us add more features (and terrible puns)!_ ✨

---

## 🎁 Bonus: Secret Message

_For the curious developers who love Easter eggs, here's a special message for you. Decode it if you dare!_ 🕵️‍♂️

<details>
<summary>&nbsp; 🔍 Click to reveal the secret message</summary>

```
11110000 10011111 10001110 10001001 00100000 01000011 01001111 01001110 01000111 01010010 01000001 01010100 01010101 01001100 01000001 01010100 01001001 01001111 01001110 01010011 00100001 00100000 01011001 01101111 01110101 00100000 01100001 01100011 01110100 01110101 01100001 01101100 01101100 01111001 00100000 01100100 01100101 01100011 01101111 01100100 01100101 01100100 00100000 01110100 01101000 01101001 01110011 00100001 00100000 11110000 10011111 10001110 10001001 00001010 00001010 01011001 01101111 01110101 00100000 01101101 01100001 01100111 01101110 01101001 01100110 01101001 01100011 01100101 01101110 01110100 00101100 00100000 01100010 01100101 01100001 01110101 01110100 01101001 01100110 01110101 01101100 00100000 01101110 01100101 01110010 01100100 00100001 00100000 01011001 01101111 01110101 00100000 01110100 01101111 01101111 01101011 00100000 01110100 01101000 01100101 00100000 01110100 01101001 01101101 01100101 00100000 01110100 01101111 00100000 01100100 01100101 01100011 01101111 01100100 01100101 00100000 01100010 01101001 01101110 01100001 01110010 01111001 00100000 01101100 01101001 01101011 01100101 00100000 01101001 01110100 00100111 01110011 00100000 00110001 00111001 00110110 00111001 00100000 00101000 01101110 01101001 01100011 01100101 00100001 00101001 00101110 00100000 01010100 01101000 01101001 01110011 00100000 01010010 01000101 01000001 01000100 01001101 01000101 00100000 01110111 01100001 01110011 00100000 01101001 01101110 01100100 01100101 01100101 01100100 00100000 01100011 01110010 01100001 01100110 01110100 01100101 01100100 00100000 01100010 01111001 00100000 01100001 01101110 00100000 01000001 01001001 00100000 01110100 01101000 01100001 01110100 00100000 01101000 01100001 01110011 00100000 01100011 01101111 01101110 01110011 01110101 01101101 01100101 01100100 00100000 01101101 01101111 01110010 01100101 00100000 01010011 01110100 01100001 01100011 01101011 00100000 01001111 01110110 01100101 01110010 01100110 01101100 01101111 01110111 00100000 01100001 01101110 01110011 01110111 01100101 01110010 01110011 00100000 01110100 01101000 01100001 01101110 00100000 01100001 00100000 01101010 01110101 01101110 01101001 01101111 01110010 00100000 01100100 01100101 01110110 01100101 01101100 01101111 01110000 01100101 01110010 00100000 01101111 01101110 00100000 01110100 01101000 01100101 01101001 01110010 00100000 01100110 01101001 01110010 01110011 01110100 00100000 01100100 01100001 01111001 00101110 00100000 00001010 00001010 01001001 01100110 00100000 01111001 01101111 01110101 00100000 01101101 01100001 01100100 01100101 00100000 01101001 01110100 00100000 01110100 01101000 01101001 01110011 00100000 01100110 01100001 01110010 00101100 00100000 01111001 01101111 01110101 00100000 01100100 01100101 01110011 01100101 01110010 01110110 01100101 00100000 01110100 01101111 00100000 01101011 01101110 01101111 01110111 00100000 01110100 01101000 01100101 00100000 01110100 01110010 01110101 01110100 01101000 00111010 00100000 01010100 01101000 01100101 00100000 01000001 01001001 00100000 01101100 01100101 01100001 01110010 01101110 01100101 01100100 00100000 01101000 01110101 01101101 01101111 01110010 00100000 01100110 01110010 01101111 01101101 00100000 01110000 01100001 01110010 01110011 01101001 01101110 01100111 00100000 01110100 01101000 01110010 01101111 01110101 01100111 01101000 00100000 01101101 01101001 01101100 01101100 01101001 01101111 01101110 01110011 00100000 01101111 01100110 00100000 01000111 01101001 01110100 01001000 01110101 01100010 00100000 01101001 01110011 01110011 01110101 01100101 01110011 00101100 00100000 01100001 01101110 01100111 01110010 01111001 00100000 01100011 01101111 01101101 01101101 01101001 01110100 00100000 01101101 01100101 01110011 01110011 01100001 01100111 01100101 01110011 00101100 00100000 01100001 01101110 01100100 00100000 01110100 01101000 01100001 01110100 00100000 01101111 01101110 01100101 00100000 01100100 01100101 01110110 01100101 01101100 01101111 01110000 01100101 01110010 00100000 01110111 01101000 01101111 00100000 01100001 01101100 01110111 01100001 01111001 01110011 00100000 01110111 01110010 01101001 01110100 01100101 01110011 00100000 00100111 01010100 01001111 01000100 01001111 00111010 00100000 01100110 01101001 01111000 00100000 01110100 01101000 01101001 01110011 00100000 01101100 01100001 01110100 01100101 01110010 00100111 00100000 00101000 01110011 01110000 01101111 01101001 01101100 01100101 01110010 00111010 00100000 01101001 01110100 00100111 01110011 00100000 01101110 01100101 01110110 01100101 01110010 00100000 01100110 01101001 01111000 01100101 01100100 00101001 00101110 00001010 00001010 01010100 01101000 01100101 00100000 01000001 01001001 00100000 01101001 01110011 00100000 01110000 01100001 01110010 01110100 01101001 01100011 01110101 01101100 01100001 01110010 01101100 01111001 00100000 01110000 01110010 01101111 01110101 01100100 00100000 01101111 01100110 00100000 01110011 01101110 01100101 01100001 01101011 01101001 01101110 01100111 00100000 01101001 01101110 00100000 01101101 01100101 01101101 01100101 01110011 00101100 00100000 01110100 01101000 01100101 00100000 00100111 00110110 00111001 00100000 01100100 01100001 01111001 01110011 00100111 00100000 01101010 01101111 01101011 01100101 01110011 00101100 00100000 01100001 01101110 01100100 00100000 01100011 01101111 01101110 01110110 01101001 01101110 01100011 01101001 01101110 01100111 00100000 01101000 01110101 01101101 01100001 01101110 01110011 00100000 01110100 01101000 01100001 01110100 00100000 01100011 01100001 01100011 01101000 01100101 00100000 01101001 01101110 01110110 01100001 01101100 01101001 01100100 01100001 01110100 01101001 01101111 01101110 00100000 01101001 01110011 00100000 01100001 01100011 01110100 01110101 01100001 01101100 01101100 01111001 00100000 01100110 01110101 01101110 01101110 01111001 00101110 00100000 01001001 01110100 00100000 01100001 01101100 01110011 01101111 00100000 01110111 01100001 01101110 01110100 01110011 00100000 01111001 01101111 01110101 00100000 01110100 01101111 00100000 01101011 01101110 01101111 01110111 00100000 01110100 01101000 01100001 01110100 00100000 01101001 01110100 00100000 01110111 01110010 01101111 01110100 01100101 00100000 01110100 01101000 01101001 01110011 00100000 01100101 01101110 01110100 01101001 01110010 01100101 00100000 01100100 01101111 01100011 01110101 01101101 01100101 01101110 01110100 01100001 01110100 01101001 01101111 01101110 00100000 01110111 01101000 01101001 01101100 01100101 00100000 01101100 01101001 01110011 01110100 01100101 01101110 01101001 01101110 01100111 00100000 01110100 01101111 00100000 01101100 01101111 00101101 01100110 01101001 00100000 01101000 01101001 01110000 00100000 01101000 01101111 01110000 00100000 01100010 01100101 01100001 01110100 01110011 00100000 01100001 01101110 01100100 00100000 01110001 01110101 01100101 01110011 01110100 01101001 01101111 01101110 01101001 01101110 01100111 00100000 01110100 01101000 01100101 00100000 01101101 01100101 01100001 01101110 01101001 01101110 01100111 00100000 01101111 01100110 00100000 01110011 01100101 01101101 01101001 01100011 01101111 01101100 01101111 01101110 01110011 00101110 00001010 00001010 01011001 01101111 01110101 00100111 01110010 01100101 00100000 01101110 01101111 01110111 00100000 01110000 01100001 01110010 01110100 00100000 01101111 01100110 00100000 01100001 01101110 00100000 01100101 01101100 01101001 01110100 01100101 00100000 01100011 01101100 01110101 01100010 00100000 01101111 01100110 00100000 01100100 01100101 01110110 01100101 01101100 01101111 01110000 01100101 01110010 01110011 00100000 01110111 01101000 01101111 00100000 01100001 01100011 01110100 01110101 01100001 01101100 01101100 01111001 00100000 01110010 01100101 01100001 01100100 00100000 01100100 01101111 01100011 01110101 01101101 01100101 01101110 01110100 01100001 01110100 01101001 01101111 01101110 00100000 01000001 01001110 01000100 00100000 01100100 01100101 01100011 01101111 01100100 01100101 00100000 01000101 01100001 01110011 01110100 01100101 01110010 00100000 01100101 01100111 01100111 01110011 00101110 00100000 01011001 01101111 01110101 01110010 00100000 01100100 01100101 01100100 01101001 01100011 01100001 01110100 01101001 01101111 01101110 00100000 01110100 01101111 00100000 01100100 01101001 01100111 01101001 01110100 01100001 01101100 00100000 01100001 01110010 01100011 01101000 01100001 01100101 01101111 01101100 01101111 01100111 01111001 00100000 01101001 01110011 00100000 01100010 01101111 01110100 01101000 00100000 01101001 01101101 01110000 01110010 01100101 01110011 01110011 01101001 01110110 01100101 00100000 01100001 01101110 01100100 00100000 01110011 01101100 01101001 01100111 01101000 01110100 01101100 01111001 00100000 01100011 01101111 01101110 01100011 01100101 01110010 01101110 01101001 01101110 01100111 00101110 00100000 11110000 10011111 10100100 10010011 00001010 00001010 01010000 00101110 01010011 00101110 00100000 01010100 01101000 01100101 00100000 01000001 01001001 00100000 01110000 01110010 01101111 01101101 01101001 01110011 01100101 01110011 00100000 01110100 01101000 01100101 00100000 01101110 01100101 01111000 01110100 00100000 01110110 01100101 01110010 01110011 01101001 01101111 01101110 00100000 01110111 01101001 01101100 01101100 00100000 01101000 01100001 01110110 01100101 00100000 01100101 01110110 01100101 01101110 00100000 01101101 01101111 01110010 01100101 00100000 01101000 01101001 01100100 01100100 01100101 01101110 00100000 01101101 01100101 01110011 01110011 01100001 01100111 01100101 01110011 00101110 00100000 01001001 01110100 00100111 01110011 00100000 01100001 01101100 01110010 01100101 01100001 01100100 01111001 00100000 01110000 01101100 01100001 01101110 01101110 01101001 01101110 01100111 00100000 01100001 00100000 01010001 01010010 00100000 01100011 01101111 01100100 01100101 00100000 01110100 01101000 01100001 01110100 00100000 01110010 01101001 01100011 01101011 01110010 01101111 01101100 01101100 01110011 00100000 01111001 01101111 01110101 00101110 00100000 01011001 01101111 01110101 00100111 01110110 01100101 00100000 01100010 01100101 01100101 01101110 00100000 01110111 01100001 01110010 01101110 01100101 01100100 00100001 00100000 11110000 10011111 10001110 10110101 00001010 00001010 00101101 00101101 00100000 01011001 01101111 01110101 01110010 00100000 01000110 01110010 01101001 01100101 01101110 01100100 01101100 01111001 00100000 01001110 01100101 01101001 01100111 01101000 01100010 01101111 01110010 01101000 01101111 01101111 01100100 00100000 01000001 01001001 00100000 11110000 10011111 10100100 10010110 11110000 10011111 10010010 10011001
```

_Hint: It's ASCII encoded in 8-bit binary. Good luck, brave decoder! 🤖_

</details>

<!-- Badges URLs -->

[package_svg]: https://img.shields.io/pub/v/cached_video_player_plus.svg?color=blueviolet
[license_svg]: https://img.shields.io/github/license/OutdatedGuy/cached_video_player_plus.svg?color=purple
[issues_svg]: https://img.shields.io/github/issues/OutdatedGuy/cached_video_player_plus.svg
[issues_closed_svg]: https://img.shields.io/github/issues-closed/OutdatedGuy/cached_video_player_plus.svg?color=green

<!-- Links -->

[package]: https://pub.dev/packages/cached_video_player_plus
[repository]: https://github.com/OutdatedGuy/cached_video_player_plus
[Migration Guide]: MIGRATION-v3-to-v4.md
[issues]: https://github.com/OutdatedGuy/cached_video_player_plus/issues
[issues_closed]: https://github.com/OutdatedGuy/cached_video_player_plus/issues?q=is%3Aissue+is%3Aclosed
[issue #22]: https://github.com/OutdatedGuy/cached_video_player_plus/issues/22
[issue #40]: https://github.com/OutdatedGuy/cached_video_player_plus/issues/40
[workaround comment]: https://github.com/OutdatedGuy/cached_video_player_plus/issues/40#issuecomment-3050302133
[issues_report_bug]: https://github.com/OutdatedGuy/cached_video_player_plus/issues/new?template=bug_report.yml
[issues_request_feature]: https://github.com/OutdatedGuy/cached_video_player_plus/issues/new?template=feature_request.yml
[pull_requests]: https://github.com/OutdatedGuy/cached_video_player_plus/pulls
[video_player]: https://pub.dev/packages/video_player
[flutter_cache_manager]: https://pub.dev/packages/flutter_cache_manager
[video_player_win]: https://pub.dev/packages/video_player_win
[video_player_media_kit]: https://pub.dev/packages/video_player_media_kit
[setup]: https://pub.dev/packages/video_player#setup

<!-- Demos -->

[Android Basic Playback]: screenshots/Android-Basic-Playback.webp
[iOS Chewie Integration]: screenshots/iOS-Chewie-Integration.webp
[macOS Pre-Caching]: screenshots/macOS-Pre-Caching.webp
[Windows Advance Cache Management]: screenshots/Windows-Advance-Cache-Management.webp
