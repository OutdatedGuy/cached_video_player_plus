import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class _VideoInfo {
  const _VideoInfo({
    required this.title,
    required this.url,
    required this.size,
  });

  final String title;
  final Uri url;
  final String size;
}

class PreCachingPage extends StatefulWidget {
  const PreCachingPage({super.key});

  @override
  State<PreCachingPage> createState() => _PreCachingPageState();
}

class _PreCachingPageState extends State<PreCachingPage> {
  final List<_VideoInfo> _videos = [
    _VideoInfo(
      title: 'Big Buck Bunny',
      url: Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      size: '158 MB',
    ),
    _VideoInfo(
      title: 'Elephant Dream',
      url: Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      ),
      size: '169 MB',
    ),
    _VideoInfo(
      title: 'For Bigger Blazes',
      url: Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      ),
      size: '2.5 MB',
    ),
  ];

  _VideoInfo? _selectedVideo;
  CachedVideoPlayerPlus? _player;
  DataSourceType? _dataSourceType;

  Future<void> _playVideo(_VideoInfo videoInfo) async {
    await _player?.dispose();

    setState(() {
      _player = CachedVideoPlayerPlus.networkUrl(videoInfo.url);
      _selectedVideo = videoInfo;
    });

    await _player!.initialize();
    _dataSourceType = _player!.controller.dataSourceType;
    if (mounted) setState(() {});
    _player!.controller.play();
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Me If You Can! (Pre-caching Demo)'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _selectedVideo == null
                    ? 'No video playing. (The suspense is killing me!)'
                    : 'Now playing: ${_selectedVideo!.title} '
                        'from "${_dataSourceType?.name}"',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: AspectRatio(
                aspectRatio: _player?.isInitialized == true
                    ? _player!.controller.value.aspectRatio
                    : 16 / 9,
                child: _player?.isInitialized == true
                    ? VideoPlayer(_player!.controller)
                    : Container(
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: Text(
                          '🦄 Waiting for action...\n'
                          '(press play, don\'t be shy!)',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
            if (_player?.isInitialized == true) ...[
              const SizedBox(height: 8),
              VideoProgressIndicator(_player!.controller, allowScrubbing: true),
            ],
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _videos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final videoInfo = _videos[index];
                  return _VideoOptionTile(
                    videoInfo: videoInfo,
                    onPlay: () => _playVideo(videoInfo),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tip: Pre-caching means less buffering, more bunny hopping!\n'
              '(And if you clear the cache, the bunny gets a fresh start 🐰)',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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

class _VideoOptionTile extends StatefulWidget {
  const _VideoOptionTile({required this.videoInfo, required this.onPlay});

  final _VideoInfo videoInfo;
  final VoidCallback onPlay;

  @override
  State<_VideoOptionTile> createState() => _VideoOptionTileState();
}

class _VideoOptionTileState extends State<_VideoOptionTile> {
  bool _isPreCaching = false;
  bool _isPreCached = false;
  bool _isClearingCache = false;

  _VideoInfo get _videoInfo => widget.videoInfo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 555;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment:
                  isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _videoInfo.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Size: ${_videoInfo.size}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox.square(dimension: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      icon: _isPreCaching
                          ? _SmallLoader()
                          : _isPreCached
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.download),
                      label: _isPreCaching
                          ? const Text('Caching...')
                          : _isPreCached
                              ? const Text('Cached')
                              : const Text('Cache'),
                      onPressed:
                          _isPreCaching || _isPreCached ? null : _cacheVideo,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                      onPressed: widget.onPlay,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      icon: _isClearingCache
                          ? _SmallLoader()
                          : const Icon(Icons.delete),
                      label: _isClearingCache
                          ? const Text('Clearing...')
                          : const Text('Clear Cache'),
                      onPressed: _isClearingCache ? null : _clearCache,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cacheVideo() async {
    setState(() => _isPreCaching = true);

    try {
      await CachedVideoPlayerPlus.preCacheVideo(_videoInfo.url);
      if (mounted) setState(() => _isPreCached = true);
    } finally {
      if (mounted) setState(() => _isPreCaching = false);
    }
  }

  Future<void> _clearCache() async {
    setState(() => _isClearingCache = true);

    try {
      await CachedVideoPlayerPlus.removeFileFromCache(_videoInfo.url);
      if (mounted) setState(() => _isPreCached = false);
    } finally {
      if (mounted) setState(() => _isClearingCache = false);
    }
  }
}
