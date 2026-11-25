# Migration Guide: v4 to v5

Version 5 removes the v3-to-v4 metadata migration utility, drops
[`get_storage`][get_storage], and raises the minimum
[`flutter_cache_manager`][flutter_cache_manager] version to `3.5.0`.

> [!IMPORTANT]
>
> **Migrating from v3?** Migrate to v4 first using the
> [v3-to-v4 migration guide][migration_v3_to_v4], then upgrade to v5. The
> `migrateCachedVideoDataToSharedPreferences()` utility has been removed in v5.

## Breaking changes

### Removed migration utility

`migrateCachedVideoDataToSharedPreferences()` and the
`package:cached_video_player_plus/util/migration_utils.dart` import have been
removed.

### `get_storage` removed

`get_storage` is no longer a dependency of `cached_video_player_plus`.

## Step-by-step migration

### 1. Update `pubspec.yaml`

Bump `cached_video_player_plus` to `^5.0.0`:

```yaml
dependencies:
  cached_video_player_plus: ^5.0.0
  video_player: ^2.10.1
```

If you previously added `dependency_overrides` for `get_storage` or
`flutter_cache_manager`, remove them:

```yaml
# Remove these overrides from pubspec.yaml if present
dependency_overrides:
  get_storage:
    git:
      url: https://github.com/OutdatedGuy/get_storage.git
      ref: rewrite
  # Remove whichever flutter_cache_manager override you used:
  flutter_cache_manager:
    git:
      url: https://github.com/Baseflow/flutter_cache_manager.git
      path: flutter_cache_manager
      ref: 54904e499a06d0364a2b3f4ca9789e5f829f1879
  # or:
  # flutter_cache_manager:
  #   git:
  #     url: https://github.com/Oliver-WJ/flutter_cache_manager.git
  #     path: flutter_cache_manager
```

These overrides are no longer needed:

- **`get_storage`**: No longer a dependency of `cached_video_player_plus`.
- **`flutter_cache_manager`**: v5 requires `>=3.5.0`, which fixes:
  - Cached videos being saved with a `.bin` extension.
  - Cache files failing to delete properly or triggering duplicate downloads of
    the same video.

### 2. Remove the v3 migration call

Remove the `migration_utils.dart` import and the
`migrateCachedVideoDataToSharedPreferences()` call from your startup code:

**Before (v4):**

```dart
import 'package:cached_video_player_plus/util/migration_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await migrateCachedVideoDataToSharedPreferences();
  runApp(const MyApp());
}
```

**After (v5):**

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
```

If you run into migration issues not covered here, check or open an issue on
[GitHub][issues].

<!-- Links -->

[migration_v3_to_v4]: MIGRATION-v3-to-v4.md
[issues]: https://github.com/OutdatedGuy/cached_video_player_plus/issues
[flutter_cache_manager]: https://pub.dev/packages/flutter_cache_manager
[get_storage]: https://pub.dev/packages/get_storage
