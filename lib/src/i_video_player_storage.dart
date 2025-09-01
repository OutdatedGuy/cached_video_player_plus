/// Storage abstraction for cached video metadata.
abstract interface class IVideoPlayerStorage {
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
