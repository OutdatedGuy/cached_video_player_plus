import 'package:cached_video_player_plus/cached_video_player_plus.dart'
    show IVideoPlayerMetadataStorage;

/// Stores video metadata in memory.
class MemoryVideoPlayerMetadataStorage implements IVideoPlayerMetadataStorage {
  final _data = <String, int>{};

  @override
  Set<String> get keys => _data.keys.toSet();

  @override
  Future<int?> read(String key) {
    return Future.value(_data[key]);
  }

  @override
  Future<void> write(String key, int value) {
    return Future.sync(() => _data[key] = value);
  }

  @override
  Future<void> remove(String key) {
    return Future.sync(() => _data.remove(key));
  }

  @override
  Future<void> erase() {
    return Future.sync(() => _data.clear());
  }
}
