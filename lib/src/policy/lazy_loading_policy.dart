import 'dart:async';

import 'package:config_cat/src/cache/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';
import 'package:config_cat/src/model/config.dart';
import 'package:config_cat/src/project_config.dart';
import 'package:config_cat/src/policy/refresh_policy.dart';
import 'package:logging/logging.dart';

class LazyLoadingPolicy extends RefreshPolicy {
  final Logger logger = Logger('LazyLoadingPolicy');
  int cacheRefreshIntervalInSeconds;
  Future<String> fetchingFuture;

  LazyLoadingPolicy(ConfigCache cache, ConfigFetcher configFetcher,
      {this.cacheRefreshIntervalInSeconds})
      : super(cache, configFetcher);

  @override
  Future<Configurations> getConfiguration() async {
    var config = cache.get();

    if (DateTime.now().toUtc().isAfter(config.timeStamp
        .add(Duration(seconds: cacheRefreshIntervalInSeconds)))) {
      logger.fine("Cache expired, refreshing");
      return _refreshConfig(config).then((v) => v.configurations);
    }
    return config.configurations;
  }

  Future<ProjectConfig> _refreshConfig(ProjectConfig config) async {
    final response = await fetcher.fetch(config);
    cache.set(response.config);
    return response.config;
  }
}
