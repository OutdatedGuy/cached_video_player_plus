import 'package:cached_video_player_plus/util/migration_utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

import 'pages/advance_cache_management_page.dart';
import 'pages/basic_playback_page.dart';
import 'pages/chewie_integration_page.dart';
import 'pages/pre_caching_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Migrate cached video data from get_storage to shared_preferences
  // This should be called ONCE before removing get_storage dependency
  await migrateCachedVideoDataToSharedPreferences();

  // Windows and Linux support using `video_player_media_kit` plugin
  VideoPlayerMediaKit.ensureInitialized(windows: true, linux: true);

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Video Player Plus'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Cached Video Player Plus Demo 🎬',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore all the features of this powerful video caching library. '
                        'Each example demonstrates different capabilities and use cases. '
                        'It\'s like a Swiss Army knife, but for videos! We Marie Kondo\'d the API - '
                        'everything that doesn\'t spark joy got yeeted into the digital void! ✨',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;
                    final childAspectRatio = constraints.maxWidth > 1000
                        ? 4.5
                        : 3.14;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _FeatureCard(
                          title: 'Basic Playback',
                          subtitle:
                              'Network video with caching (because we are not in 2010! 📡)',
                          icon: Icons.play_circle,
                          color: Colors.blue,
                          onTap: () =>
                              _navigateTo(context, const BasicPlaybackPage()),
                        ),
                        _FeatureCard(
                          title: 'Chewie Integration',
                          subtitle:
                              'Rich video player UI with caching (beauty meets performance! 🎬)',
                          icon: Icons.video_library,
                          color: Colors.orange,
                          onTap: () => _navigateTo(
                            context,
                            const ChewieIntegrationPage(),
                          ),
                        ),
                        _FeatureCard(
                          title: 'Pre-Cache Videos',
                          subtitle:
                              'Download videos for offline viewing (like hoarding, but useful! 📦)',
                          icon: Icons.download,
                          color: Colors.purple,
                          onTap: () =>
                              _navigateTo(context, const PreCachingPage()),
                        ),
                        _FeatureCard(
                          title: 'Advance Cache Management',
                          subtitle:
                              'Clear cache and manage storage (Marie Kondo for your app! ✨)',
                          icon: Icons.storage,
                          color: Colors.red,
                          onTap: () => _navigateTo(
                            context,
                            const AdvanceCacheManagementPage(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
