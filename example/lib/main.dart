// Flutter Packages
import 'package:flutter/material.dart';

// This Package
import 'package:cached_video_player_plus/cached_video_player_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Video Player Plus Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
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
  late CachedVideoPlayerPlusController controller;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerPlusController.network(
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    )..initialize().then((value) {
        controller.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CachedVideoPlayerPlus(controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
