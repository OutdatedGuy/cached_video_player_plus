import 'dart:async' show FutureOr;

/// An interface class for storing video metadata.
abstract interface class IVideoPlayerMetadataStorage {
  /// Obtains stored keys from the storage.
  FutureOr<Set<String>> get keys;

  /// Reads the cached video duration in milliseconds from storage.
  ///
  /// Returns the stored value for the given [key], or null if not found.
  Future<int?> read(String key);

  /// Writes the video duration in milliseconds to storage with the given [key].
  Future<void> write(String key, int value);

  /// Removes a value from storage.
  ///
  /// Deletes the value associated with the given [key].
  Future<void> remove(String key);

  /// Clears all cached video player metadata from storage.
  ///
  /// This removes all keys that start with the video player prefix.
  Future<void> erase();
}
