/// An interface class for storing video related data.
///
/// The interface can be implemented to store any type of data.
///
/// See also:
///  * [IVideoPlayerMetadataStorage], which is an interface to stores
///    video metadata with int values.
abstract interface class IVideoPlayerStorage<T extends Object> {
  /// Reads a value from storage.
  ///
  /// Returns the stored value for the given [key], or null if not found.
  Future<T?> read(String key);

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

/// An interface class for storing video metadata items with int values.
abstract interface class IVideoPlayerMetadataStorage
    implements IVideoPlayerStorage<int> {}
