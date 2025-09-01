import 'package:shared_preferences/shared_preferences.dart';

import 'cache_key_helpers.dart' show cacheKeyPrefix;

/// Storage abstraction for cached video metadata.
abstract interface class IVideoPlayerStorage {
  IVideoPlayerStorage(); // Storage cannot be a constant.

  /// Reads a value from storage.
  ///
  /// Returns the stored value for the given [key], or null if not found.
  Future<int?> read(String key);

  /// Writes a value to storage.
  ///
  /// Stores the [value] with the given [key].
  Future<void> write(String key, int value);

  /// Removes a value from storage.
  ///
  /// Deletes the value associated with the given [key].
  Future<void> remove(String key);

  /// Clears all cached video player data from storage.
  ///
  /// This removes all keys that start with the video player prefix.
  Future<void> erase();
}

/// This class handles the storage of cache expiration timestamps and provides
/// migration functionality from get_storage to shared_preferences.
class VideoPlayerStorage implements IVideoPlayerStorage {
  /// SharedPreferences instance for storing cache metadata.
  final _asyncPrefs = SharedPreferencesAsync();

  /// Singleton instance of VideoPlayerStorage.
  static final _instance = VideoPlayerStorage._internal();

  /// Private constructor for singleton pattern implementation.
  VideoPlayerStorage._internal();

  /// Factory constructor that returns the singleton instance.
  factory VideoPlayerStorage() => _instance;

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
