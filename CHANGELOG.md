## 3.0.0

**BREAKING CHANGES**

- Using plugin specific cache manager from `flutter_cache_manager`
- Using plugin specific `get_storage` container for storing cache information

**Features**

- feat: added cache removal support using static method or instance method. Thanks [@chorauoc](https://github.com/chorauoc)
- feat: option to `skipCache` when initializing the player. Thanks [@chorauoc](https://github.com/chorauoc)
- perf: using isolates for all file operations for better performance

**Chores**

- chore: updated all dependencies to latest versions
- chore: updated shared code from `video_player` plugin

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
