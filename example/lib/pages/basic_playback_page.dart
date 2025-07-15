import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicPlaybackPage extends StatefulWidget {
  const BasicPlaybackPage({super.key});

  @override
  State<BasicPlaybackPage> createState() => _BasicPlaybackPageState();
}

class _BasicPlaybackPageState extends State<BasicPlaybackPage> {
  late final CachedVideoPlayerPlus _player;

  DataSourceType? _dataSourceType;

  double _volume = 1;

  @override
  void initState() {
    super.initState();

    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      invalidateCacheIfOlderThan: const Duration(days: 42),
    );
    _player.initialize().then((_) {
      if (!mounted) return;

      _dataSourceType = _controller.dataSourceType;

      _controller.addListener(() {
        if (mounted) setState(() {});
      });
      _controller.play();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  VideoPlayerController get _controller => _player.controller;

  void _seekBy(Duration offset) {
    _controller.seekTo(_controller.value.position + offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage (for advanced people too)'),
      ),
      body: _player.isInitialized
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Video Source: ${_dataSourceType!.name}\n'
                      '(because even bunnies need to know where their movies come from!)',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  const SizedBox(height: 16),
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.first_page),
                        onPressed: () {
                          _controller.seekTo(Duration.zero);
                        },
                        tooltip: 'Back to the beginning (no DeLorean needed)',
                      ),
                      IconButton(
                        icon: const Icon(Icons.replay_10),
                        onPressed: () {
                          _seekBy(const Duration(seconds: -10));
                        },
                        tooltip: 'Rewind 10 seconds (for when you blinked)',
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        },
                        tooltip: _controller.value.isPlaying
                            ? 'Pause (give the bunny a break)'
                            : 'Play (let the bunny run!)',
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10),
                        onPressed: () {
                          _seekBy(const Duration(seconds: 10));
                        },
                        tooltip:
                            'Forward 10 seconds (time travel, but only forward)',
                      ),
                      IconButton(
                        icon: const Icon(Icons.last_page),
                        onPressed: () {
                          _controller.seekTo(_controller.value.duration);
                        },
                        tooltip: 'To the end (spoiler alert!)',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isLooping
                              ? Icons.repeat_one
                              : Icons.loop,
                        ),
                        onPressed: () {
                          _controller.setLooping(!_controller.value.isLooping);
                        },
                        tooltip: _controller.value.isLooping
                            ? 'Looping: ON (bunny marathon)'
                            : 'Looping: OFF (one hop only)',
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.volume > 0
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                            ),
                            onPressed: () {
                              if (_controller.value.volume > 0) {
                                _controller.setVolume(0);
                              } else {
                                _controller.setVolume(_volume);
                              }
                            },
                            tooltip: _controller.value.volume > 0
                                ? 'Mute (shhh...)'
                                : 'Unmute (let the bunny speak!)',
                          ),
                          Slider(
                            value: _controller.value.volume,
                            onChanged: (value) {
                              _controller.setVolume(value);
                              _volume = value;
                            },
                            divisions: 10,
                            label:
                                'Volume: ${(_controller.value.volume * 100).round()}%',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
