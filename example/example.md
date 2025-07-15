```dart
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Video Player Plus Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CachedVideoPlayerPlus _player;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      invalidateCacheIfOlderThan: const Duration(minutes: 69),
    );
    _player.initialize().then((value) async {
      await _player.controller.setLooping(true);
      _player.controller.play();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cached Video Player Plus Demo')),
      body: Center(
        child: _player.isInitialized
            ? AspectRatio(
                aspectRatio: _player.controller.value.aspectRatio,
                child: VideoPlayer(_player.controller),
              )
            : const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

```
