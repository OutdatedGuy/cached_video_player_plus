## 4.0.0

_We Marie Kondo'd the entire API! Everything that didn't spark joy got yeeted into the digital void! ✨🗑️_

**BREAKING CHANGES**

- Complete API restructure: `CachedVideoPlayerPlusController` replaced with class-based `CachedVideoPlayerPlus` approach
- Widget usage changed: Use `VideoPlayer(player.controller)` instead of `CachedVideoPlayerPlus(controller)`
- Controller access: Video control methods now accessed through `.controller` property (e.g., `player.controller.play()`)
- Storage migration: Switched from `get_storage` to `shared_preferences` for cache metadata storage
- Method renames: `removeCurrentFileFromCache()` → `removeFromCache()`
- Parameter type changes: `removeFileFromCache()` now takes `Uri` instead of `String`
- Cache key prefix changed internally (handled automatically by migration utility)
- Default cache duration increased from 30 days to 69 days _(Nice! 😎)_
- Removed deprecated `CachedVideoPlayerPlusController.network()` constructor
- Removed classes: `CachedVideoPlayerPlusValue`, `CachedVideoPlayerPlus` widget, `ClosedCaptionFile` implementations

**Features**

- feat: Pre-cache videos without creating player instances using `CachedVideoPlayerPlus.preCacheVideo()`
- feat: Custom cache key support via `cacheKey` parameter for cleaner cache management _(because sometimes URLs are longer than a CVS receipt)_
- feat: Custom cache manager support via `cacheManager` parameter
- feat: Separate download headers via `downloadHeaders` parameter for authentication purposes
- feat: Cache removal by custom cache key using `removeFileFromCacheByKey()`
- feat: Automatic migration utility to preserve existing cached video data from v3.x.x
- feat: Convenience property `player.isInitialized` for easier state checking

**Fixes**

- fix: Web platform cannot play cached videos - improved web compatibility
- fix: Race condition in cache file removal by making it awaitable _(no more cache file musical chairs!)_
- fix: StateError exception handling for uninitialized controller access

**Chores**

- chore: Updated dependencies to latest versions with Flutter 3.32 support
- chore: Restructured from plugin to package architecture
- chore: Enhanced documentation with migration guide and comprehensive examples _(now with 42% more humor!)_
- chore: Updated example app to showcase full v4.0.0 feature set

## 3.0.3

- refactor: lowered sdk constraints to support dart 3.0.0 and above

## 3.0.2

- chore: updated dependency constraints to support lower bounds

## 3.0.1

**BREAKING CHANGES**

- Using plugin specific cache manager from `flutter_cache_manager`
- Using plugin specific `get_storage` container for storing cache information

**Features**

- feat: added cache removal support using static method or instance method. Thanks [@chorauoc](https://github.com/chorauoc)
- feat: option to `skipCache` when initializing the player. Thanks [@chorauoc](https://github.com/chorauoc)

**Chores**

- chore: updated all dependencies to latest versions
- chore: updated shared code from `video_player` plugin

## 3.0.0

**NOTE: This release was retracted due to [#26](https://github.com/OutdatedGuy/cached_video_player_plus/issues/26)**

## 2.0.0

**BREAKING CHANGES**

- Using `flutter_cache_manager` for caching and removed all caching related
  code from this package
- Using platform specific `video_player` plugin as `default_package` and
  removed all video related code from this package

**Features**

- feat: added support to invalidate cache if older than a specified duration
- feat: added support for `macOS` platform

## 1.0.1

- fix: compiler linking issues while running on simulator
- docs: added instructions for web platform

## 1.0.0

- Initial Stable release
