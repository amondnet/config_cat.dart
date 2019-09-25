import 'package:config_cat/src/cache/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';
import 'package:config_cat/src/configuration_parser.dart';
import 'package:config_cat/src/policy/auto_polling_policy.dart';
import 'package:config_cat/src/policy/refresh_policy.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'package:config_cat/src/model/user.dart';

class ConfigCatClient {
  final Logger logger = Logger('ConfigCatClient');
  static final ConfigurationParser _parser = ConfigurationParser();
  RefreshPolicy refreshPolicy;
  int maxWaitTimeForSyncCallsInSeconds;

  ConfigCatClient(String apiKey,
      {Dio dio,
      ConfigCache cache,
      this.refreshPolicy,
      this.maxWaitTimeForSyncCallsInSeconds = 10}) {
    if (dio == null) {
      dio = Dio();
    }

    ConfigFetcher fetcher = ConfigFetcher(dio, apiKey);
    if (cache == null) {
      cache = InMemoryConfigCache();
    }
    if (this.refreshPolicy == null) {
      refreshPolicy = AutoPollingPolicy(cache, fetcher,
          maxInitWaitTime: Duration(seconds: maxWaitTimeForSyncCallsInSeconds),
          pollingInterval: Duration(seconds: 60));
    }
  }

  Future<dynamic> getValue(String key, dynamic defaultValue, {User user}) {
    return refreshPolicy.getConfiguration().then((config) {
      return _parser.parseValue(config, key, user);
    }).catchError((e) {
      logger.severe("getValue Error : $e", e);
    });
  }
}
