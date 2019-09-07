import 'dart:async';

import 'package:config_cat/src/cache/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';
import 'package:config_cat/src/configuration_parser.dart';
import 'package:config_cat/src/model/config.dart';
import 'package:config_cat/src/policy/refresh_policy.dart';

class AuthPollingPolicy extends RefreshPolicy {
  Timer timer;
  final List<ConfigurationChangeListener> listeners = [];
  StreamController _streamController;
  DateTime _maxInitWaitExpire;
  Stream<ConfigurationChangedEvent> stream;
  static final ConfigurationParser _parser = new ConfigurationParser();

  AuthPollingPolicy(
    ConfigCache cache,
    ConfigFetcher configFetcher, {
    Duration pollingInterval = const Duration(seconds: 60),
    Duration maxInitWaitTime = const Duration(seconds: 10),
  }) : super(cache, configFetcher) {
    this.timer = Timer.periodic(pollingInterval, (_) {
      _refresh('auto');
    });

    _streamController = StreamController();
    stream = _streamController.stream.asBroadcastStream();
    _maxInitWaitExpire = DateTime.now().toUtc().add(maxInitWaitTime);
  }

  void dispose() {
    this.timer?.cancel();
    this._streamController.close();
  }

  @override
  Future<Configurations> getConfiguration() async {
    var d = this._maxInitWaitExpire.difference(DateTime.now().toUtc());
    if (d > Duration.zero) {
      await _refreshAsync("init").timeout(d);
    }
    return Future.value(cache.get().configurations);
  }

  @override
  Future<void> refresh() {
    return _refreshAsync("manual");
  }

  Future<void> _refreshAsync(String sender) async {
    var lastConfig = cache.get();
    final response = await fetcher.fetch(lastConfig);
    final newConfig = response.config;

    if (response.isFetched && lastConfig != newConfig) {
      cache.set(newConfig);
      _broadcastConfigurationChanged(newConfig.configurations);
    }
  }

  void _refresh(String sender) async {
    await this._refreshAsync(sender);
  }

  void addConfigurationChangeListener(ConfigurationChangeListener listener) {
    listeners.add(listener);
  }

  void removeConfigurationChangeListener(ConfigurationChangeListener listener) {
    listeners.remove(listener);
  }

  void _broadcastConfigurationChanged(Configurations newConfiguration) {
    listeners.forEach((listener) {
      listener.onConfigurationChanged(_parser, newConfiguration);
    });
  }
}

abstract class ConfigurationChangeListener {
  void onConfigurationChanged(
      ConfigurationParser parser, Configurations newConfiguration);
}

class ConfigurationChangedEvent {
  final ConfigurationParser parser;
  final Configurations newConfiguration;

  ConfigurationChangedEvent(this.parser, this.newConfiguration);
}
