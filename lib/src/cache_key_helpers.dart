/// The prefix used for all keys in this package.
const packagePrefix = 'cached_video_player_plus_';

/// The prefix used for all cache keys in this package.
const cacheTimePrefix = '${packagePrefix}caching_time_of_';

/// The key used to track migration completion.
const migrationKey = '${packagePrefix}migration_completed_v4';

/// Generates a storage key for the given [dataSource].
String getCacheKey(String dataSource) {
  return '$cacheTimePrefix${Uri.parse(dataSource)}';
}

/// Generates a storage key using the provided custom [cacheKey].
String getCustomCacheKey(String cacheKey) {
  return '$cacheTimePrefix$cacheKey';
}
