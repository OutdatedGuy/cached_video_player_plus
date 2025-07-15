import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieIntegrationPage extends StatefulWidget {
  const ChewieIntegrationPage({super.key});

  @override
  State<ChewieIntegrationPage> createState() => _ChewieIntegrationPageState();
}

class _ChewieIntegrationPageState extends State<ChewieIntegrationPage> {
  late final CachedVideoPlayerPlus _player;

  ChewieController? _chewieController;
  DataSourceType? _dataSourceType;

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

      setState(() {
        _dataSourceType = _controller.dataSourceType;

        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
          // You can add more Chewie options here if you want to get fancy
        );
      });
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _player.dispose();
    super.dispose();
  }

  VideoPlayerController get _controller => _player.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chewie Usage (now with extra cheese!)'),
      ),
      body: _player.isInitialized && _chewieController != null
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Video Source: ${_dataSourceType!.name}\n'
                      '(Chewie brings the popcorn, you bring the code!)',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Powered by cached_video_player_plus + chewie\n'
                    '(Like peanut butter and jelly, but for videos!)',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
