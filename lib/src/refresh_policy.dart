import 'package:config_cat/src/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';

abstract class RefreshPolicy {
  final ConfigCache _cache;
  final ConfigFetcher _configFetcher;

  RefreshPolicy(this._cache, this._configFetcher);

  ConfigFetcher get fetcher => _configFetcher;

  ConfigCache get cache => _cache;

  Future<String> getConfigurationJson();

  /// Initiates a force refresh on the cached configuration.
  ///
  /// Returns the future which executes the refresh.
  Future<void> refresh() {
    return fetcher.getConfigurationJsonString().then((response) {
      if (response.isFetched) {
        _cache.set(response.config);
      }
    });
  }

  String getLatestCachedValue() {
    return _cache.inMemoryValue();
  }
}
