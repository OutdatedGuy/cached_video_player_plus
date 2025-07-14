/// Utilities for migrating cached video data between storage systems.
///
/// This library provides migration functions to help users transition from
/// get_storage to shared_preferences for cached video metadata storage.
///
/// ## Basic Usage
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Migrate cached video data from get_storage to shared_preferences
///   // This should be called and awaited before calling runApp()
///   await migrateCachedVideoDataToSharedPreferences();
///
///   runApp(MyApp());
/// }
/// ```
library;

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../src/cache_key_helpers.dart' show migrationKey;

/// Migrates cached video data from get_storage to shared_preferences.
///
/// This method can be run multiple times without worry of overwriting
/// transferred data.
///
/// This function checks if the migration has already been completed by looking
/// for a specific key in shared_preferences. If the migration has not been
/// completed, it initializes get_storage, retrieves all keys, and migrates
/// each key-value pair to shared_preferences.
///
/// This migration is necessary to ensures that existing cached video data is
/// preserved and accessible through shared_preferences.
Future<void> migrateCachedVideoDataToSharedPreferences() async {
  try {
    // Check if migration has already been completed
    final asyncPrefs = SharedPreferencesAsync();
    if (await asyncPrefs.getBool(migrationKey) == true) {
      return;
    }

    // Initialize get_storage to read existing data
    final getStorage = GetStorage('cached_video_player_plus');
    await getStorage.initStorage;

    // Get all keys from get_storage
    final getStorageKeys = getStorage.getKeys<Iterable<String>>();
    if (getStorageKeys.isEmpty) {
      // No data to migrate, mark as completed
      await asyncPrefs.setBool(migrationKey, true);
      return;
    }

    int migratedCount = 0;

    // Migrate each key-value pair
    for (final key in getStorageKeys) {
      final value = getStorage.read(key);
      if (value is int) {
        await asyncPrefs.setInt(key, value);
        migratedCount++;
      }
    }

    // Mark migration as completed
    await asyncPrefs.setBool(migrationKey, true);

    // Clear get_storage data
    await getStorage.erase();

    if (kDebugMode) {
      print(
        'Cached Video Player Plus: Migrated $migratedCount cache entries from '
        'get_storage to shared_preferences',
      );
    }
  } catch (e) {
    // If migration fails, mark as completed to prevent retry loops
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setBool(migrationKey, false);
    if (kDebugMode) {
      print(
        'Cached Video Player Plus: Migration failed or get_storage not '
        'available: $e',
      );
    }
  }
}
