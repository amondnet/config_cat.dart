import 'dart:async';

import 'package:config_cat/src/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';
import 'package:config_cat/src/refresh_policy.dart';
import 'package:logging/logging.dart';

class LazyLoadingPolicy extends RefreshPolicy {
  final Logger logger = Logger('LazyLoadingPolicy');
  DateTime lastRefreshedTime = DateTime.utc(1970);
  int cacheRefreshIntervalInSeconds;
  bool asyncRefresh;
  bool isFetching = false;
  bool initialized = false;
  Future<String> fetchingFuture;

  LazyLoadingPolicy(ConfigCache cache, ConfigFetcher configFetcher,
      {this.asyncRefresh,
      this.cacheRefreshIntervalInSeconds,
      this.lastRefreshedTime})
      : super(cache, configFetcher);

  @override
  Future<String> getConfigurationJson() async {
    if (DateTime.now().toUtc().isAfter(lastRefreshedTime
        .add(Duration(seconds: cacheRefreshIntervalInSeconds)))) {
      if (initialized && !isFetching) {
        if (asyncRefresh && initialized) {
          return cache.get();
        }
        isFetching = true;
        return fetchingFuture;
      }
    }
    logger.fine("Cache expired, refreshing");

    if (initialized) {
      fetchingFuture = fetch();
      if (asyncRefresh) {
        return super.cache.get();
      }
      return fetchingFuture;
    } else {
      if (!isFetching) {
        this.fetchingFuture = fetch();
      }
      return fetchingFuture;
    }
  }

  Future<String> fetch() {
    return fetcher.getConfigurationJsonString().then((response) {
      String cached = cache.get();

      if (response.isFetched && response.config != cached) {
        cache.set(response.config);
      }
      if (response.isFailed) {
        lastRefreshedTime = DateTime.now().toUtc();
      }
      initialized = true;
      isFetching = false;

      return response.isFetched ? response.config : cached;
    });
  }
}
