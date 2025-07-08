import 'package:shared_preferences/shared_preferences.dart';

/// Storage abstraction for cached video metadata.
///
/// This class handles the storage of cache expiration timestamps and provides
/// migration functionality from get_storage to shared_preferences.
class VideoPlayerStorage {
  /// SharedPreferences instance for storing cache metadata.
  final _asyncPrefs = SharedPreferencesAsync();

  /// Key prefix for all video player storage keys.
  static const _keyPrefix = 'cached_video_player_plus_video_expiration_of_';

  /// Singleton instance of VideoPlayerStorage.
  static final _instance = VideoPlayerStorage._internal();

  /// Private constructor for singleton pattern implementation.
  VideoPlayerStorage._internal();

  /// Factory constructor that returns the singleton instance.
  factory VideoPlayerStorage() => _instance;

  /// Reads a value from storage.
  ///
  /// Returns the stored value for the given [key], or null if not found.
  Future<int?> read(String key) {
    return _asyncPrefs.getInt(key);
  }

  /// Writes a value to storage.
  ///
  /// Stores the [value] with the given [key].
  Future<void> write(String key, int value) async {
    return _asyncPrefs.setInt(key, value);
  }

  /// Removes a value from storage.
  ///
  /// Deletes the value associated with the given [key].
  Future<void> remove(String key) async {
    return _asyncPrefs.remove(key);
  }

  /// Clears all cached video player data from storage.
  ///
  /// This removes all keys that start with the video player prefix.
  Future<void> erase() async {
    final keys = await _asyncPrefs.getKeys();
    final videoPlayerKeys = keys.where((key) => key.startsWith(_keyPrefix));

    for (final key in videoPlayerKeys) {
      await _asyncPrefs.remove(key);
    }
  }
}
