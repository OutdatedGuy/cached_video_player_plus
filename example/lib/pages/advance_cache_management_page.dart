import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyPrefix = 'cached_video_player_plus_caching_time_of_';

class _VideoInfo {
  _VideoInfo(this.url, this.title);

  final String url;
  final String title;
}

class _CachedFileInfo {
  _CachedFileInfo(this.fileInfo, this.cacheKey, this.cachedAt, this.size);

  final FileInfo fileInfo;
  final String cacheKey;
  final DateTime cachedAt;
  final int size;
}

class AdvanceCacheManagementPage extends StatefulWidget {
  const AdvanceCacheManagementPage({super.key});

  @override
  State<AdvanceCacheManagementPage> createState() =>
      _AdvanceCacheManagementPageState();
}

class _AdvanceCacheManagementPageState
    extends State<AdvanceCacheManagementPage> {
  final _videoUrls = [
    _VideoInfo(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'For Bigger Fun',
    ),
    _VideoInfo(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'Sintel',
    ),
    _VideoInfo(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'Tears of Steel',
    ),
    _VideoInfo(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
      'What Car Can You Get For A Grand',
    ),
  ];
  final _customCacheManager = CacheManager(
    Config(
      'CustomVideoCacheStorage',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 20,
    ),
  );
  final _asyncPrefs = SharedPreferencesAsync();

  int _selectedIndex = 0;
  String _customKey = '';
  bool _forceFetch = false;
  bool _overrideCacheManager = false;
  bool _isLoading = false;
  bool _isCaching = false;
  bool _isClearing = false;
  List<_CachedFileInfo> _cachedFiles = [];
  int _totalCacheSize = 0;

  bool get _isReady => !_isCaching && !_isClearing && !_isLoading;

  @override
  void initState() {
    super.initState();
    _fetchCacheInfo();
  }

  Future<void> _fetchCacheInfo() async {
    setState(() => _isLoading = true);

    try {
      final allKeys = await _asyncPrefs.getKeys();
      final videoKeys = allKeys.where((key) => key.startsWith(_keyPrefix));

      final cachedFiles = await Future.wait(
        videoKeys.map((key) async {
          final cachedFile = await _customCacheManager.getFileFromCache(key);
          if (cachedFile == null) return null;

          return _CachedFileInfo(
            cachedFile,
            key.replaceFirst(_keyPrefix, ''),
            DateTime.fromMillisecondsSinceEpoch(
              (await _asyncPrefs.getInt(key))!,
            ),
            await cachedFile.file.length(),
          );
        }),
      );
      _cachedFiles = cachedFiles.whereType<_CachedFileInfo>().toList();

      _totalCacheSize = _cachedFiles.fold(0, (sum, c) => sum + c.size);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cacheVideo() async {
    if (_isCaching) return;
    setState(() => _isCaching = true);

    try {
      await CachedVideoPlayerPlus.preCacheVideo(
        Uri.parse(_videoUrls[_selectedIndex].url),
        cacheKey: _customKey,
        cacheManager: _customCacheManager,
        invalidateCacheIfOlderThan:
            _forceFetch ? Duration.zero : const Duration(days: 42),
      );
    } finally {
      if (mounted) setState(() => _isCaching = false);
      _fetchCacheInfo();
    }
  }

  Future<void> _clearAllCache() async {
    if (_isClearing) return;
    setState(() => _isClearing = true);

    try {
      await CachedVideoPlayerPlus.clearAllCache(
        cacheManager: _customCacheManager,
      );
    } finally {
      if (mounted) setState(() => _isClearing = false);
      _fetchCacheInfo();
    }
  }

  Future<void> _deleteCacheFile(String cacheKey) async {
    try {
      await CachedVideoPlayerPlus.removeFileFromCacheByKey(
        cacheKey,
        cacheManager: _customCacheManager,
      );
    } finally {
      _fetchCacheInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Cache Management')),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Select Video:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedIndex,
                    isExpanded: true,
                    items: List.generate(
                      _videoUrls.length,
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text(_videoUrls[i].title),
                      ),
                    ),
                    onChanged: (i) {
                      if (i == null) return;
                      setState(() => _selectedIndex = i);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Custom Cache Key:'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter cache key',
                      isDense: true,
                    ),
                    onChanged: (value) {
                      _customKey = value.trim();
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() {});
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Force fetch latest:'),
                    const SizedBox(width: 12),
                    Switch.adaptive(
                      value: _forceFetch,
                      onChanged: (value) => setState(() => _forceFetch = value),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Override default cache manager:'),
                    const SizedBox(width: 12),
                    Switch.adaptive(
                      value: _overrideCacheManager,
                      onChanged: (value) {
                        CachedVideoPlayerPlus.cacheManager = value
                            ? _customCacheManager
                            : CachedVideoPlayerPlus.defaultCacheManager;
                        setState(() => _overrideCacheManager = value);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.blue),
                  icon: _isCaching
                      ? _SmallLoader()
                      : const Icon(Icons.cloud_download),
                  label: const Text('Cache It'),
                  onPressed:
                      _isReady && _customKey.isNotEmpty ? _cacheVideo : null,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                  icon: _isClearing ? _SmallLoader() : const Icon(Icons.delete),
                  label: const Text('Clear All Cache'),
                  onPressed: _isReady ? _clearAllCache : null,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.amber,
                  ),
                  icon: _isLoading ? _SmallLoader() : const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: _isReady ? _fetchCacheInfo : null,
                ),
              ],
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Files: ${_cachedFiles.length}'),
                Text(
                  'Total Size: ${(_totalCacheSize / 1e6).toStringAsFixed(2)} MB',
                ),
              ],
            ),
            const Divider(height: 25),
            if (_cachedFiles.isEmpty)
              Expanded(
                child: const Center(child: Text('No cached files found.')),
              )
            else if (_isLoading)
              Expanded(
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _cachedFiles.length,
                  itemBuilder: (context, i) {
                    final cacheFile = _cachedFiles[i];
                    final file = cacheFile.fileInfo.file;
                    final name = file.basename;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Size: ${(cacheFile.size / 1e6).toStringAsFixed(2)} MB',
                            ),
                            Text('Custom Cache Key: ${cacheFile.cacheKey}'),
                            Text(
                              'Full Cache Key: $_keyPrefix${cacheFile.cacheKey}',
                            ),
                            Text('Cached at: ${cacheFile.cachedAt}'),
                            Text(
                              '\nPath: ${file.path}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteCacheFile(cacheFile.cacheKey);
                          },
                          tooltip: 'Delete cache file',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SmallLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 20,
      child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}
