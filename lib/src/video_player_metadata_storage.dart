import 'package:shared_preferences/shared_preferences.dart';

import 'cache_key_helpers.dart' show cacheKeyPrefix;
import 'i_video_player_metadata_storage.dart';

/// This class handles the storage of cache expiration timestamps and provides
/// migration functionality from get_storage to shared_preferences.
class VideoPlayerMetadataStorage implements IVideoPlayerMetadataStorage {
  /// SharedPreferences instance for storing cache metadata.
  final _asyncPrefs = SharedPreferencesAsync();

  /// Singleton instance of VideoPlayerStorage.
  static final _instance = VideoPlayerMetadataStorage._internal();

  /// Private constructor for singleton pattern implementation.
  VideoPlayerMetadataStorage._internal();

  /// Factory constructor that returns the singleton instance.
  factory VideoPlayerMetadataStorage() => _instance;

  @override
  Future<int?> read(String key) {
    return _asyncPrefs.getInt(key);
  }

  @override
  Future<void> write(String key, int value) async {
    return _asyncPrefs.setInt(key, value);
  }

  @override
  Future<void> remove(String key) async {
    return _asyncPrefs.remove(key);
  }

  @override
  Future<void> erase() async {
    final keys = await _asyncPrefs.getKeys();
    final videoPlayerKeys = keys.where((key) => key.startsWith(cacheKeyPrefix));

    for (final key in videoPlayerKeys) {
      await _asyncPrefs.remove(key);
    }
  }
}
