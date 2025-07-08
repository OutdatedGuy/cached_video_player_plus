// Flutter Packages
import 'package:flutter/material.dart';

// This Package
import 'package:cached_video_player_plus/cached_video_player_plus.dart';

// Third Party Packages
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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(title: 'Cached Video Player Plus Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CachedVideoPlayerPlus player;

  @override
  void initState() {
    super.initState();
    player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      invalidateCacheIfOlderThan: const Duration(minutes: 10),
    );

    player.initialize().then((_) {
      player.controller.setVolume(0);
      player.controller.setLooping(true);
      player.controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: player.isInitialized
            ? AspectRatio(
                aspectRatio: player.controller.value.aspectRatio,
                child: VideoPlayer(player.controller),
              )
            : const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
