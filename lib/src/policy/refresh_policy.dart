import 'package:config_cat/src/cache/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';
import 'package:config_cat/src/model/config.dart';

abstract class RefreshPolicy {
  final ConfigCache _cache;
  final ConfigFetcher _configFetcher;

  RefreshPolicy(this._cache, this._configFetcher);

  ConfigFetcher get fetcher => _configFetcher;

  ConfigCache get cache => _cache;

  Future<Configurations> getConfiguration();

  /// Initiates a force refresh on the cached configuration.
  ///
  /// Returns the future which executes the refresh.
  Future<void> refresh() {
    return fetcher.fetch().then((response) {
      if (response.isFetched) {
        _cache.set(response.config);
      }
    });
  }

  Configurations getLatestCachedValue() {
    return _cache.inMemoryValue().configurations;
  }
}
