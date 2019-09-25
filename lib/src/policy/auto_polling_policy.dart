import 'dart:async';

import 'package:async/async.dart';
import 'package:config_cat/src/cache/config_cache.dart';
import 'package:config_cat/src/config_fetcher.dart';
import 'package:config_cat/src/configuration_parser.dart';
import 'package:config_cat/src/model/config.dart';
import 'package:config_cat/src/policy/refresh_policy.dart';
import 'package:logging/logging.dart';

class AutoPollingPolicy extends RefreshPolicy {
  final Logger logger = Logger('AutoPollingPolicy');
  Stream timer;
  final List<ConfigurationChangeListener> listeners = [];
  StreamController _streamController;
  DateTime _maxInitWaitExpire;
  Stream<ConfigurationChangedEvent> stream;
  static final ConfigurationParser _parser = new ConfigurationParser();
  Duration pollingInterval;
  Future _initFuture;
  bool _initCompleted = false;

  AutoPollingPolicy(
    ConfigCache cache,
    ConfigFetcher configFetcher, {
    this.pollingInterval = const Duration(seconds: 60),
    Duration maxInitWaitTime = const Duration(seconds: 10),
  }) : super(cache, configFetcher) {
    logger.fine('pollingInterval : $pollingInterval');
    _streamController = StreamController<ConfigurationChangedEvent>();
    stream = _streamController.stream.asBroadcastStream();
    _maxInitWaitExpire = DateTime.now().toUtc().add(maxInitWaitTime);
    start();
  }

  Future<void> _init() async {
    if (_initFuture == null) {
      _initFuture = _refreshAsync('init');
      await _initFuture.whenComplete(() {
        _initCompleted = true;
      });
    }
    return _initFuture;
  }

  void start() async {
    await _init();
    timer = new Stream.periodic(pollingInterval, (count) {
      logger.finer('autoPoilling');
      _refresh('auto');
    });
    //timer.listen(onData)
  }

  void dispose() {
    logger.finer('dispose');
    this._streamController.close();
  }

  @override
  Future<Configurations> getConfiguration() async {
    var d = this._maxInitWaitExpire.difference(DateTime.now().toUtc());
    if (!_initCompleted && d > Duration.zero) {
      await _init().timeout(d);
    }
    return Future.value(cache.get().configurations);
  }

  @override
  Future<void> refresh() {
    logger.finer('refresh');
    return _refreshAsync("manual");
  }

  Future<void> _refreshAsync(String sender) async {
    logger.finer('_refreshAsync ( $sender )');

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
    logger.finer('addConfigurationChangeListener');
    listeners.add(listener);
  }

  void removeConfigurationChangeListener(ConfigurationChangeListener listener) {
    listeners.remove(listener);
  }

  void _broadcastConfigurationChanged(Configurations newConfiguration) {
    logger.finer('_broadcastConfigurationChanged');
    listeners.forEach((listener) {
      listener(_parser, newConfiguration);
      //listener.onConfigurationChanged(_parser, newConfiguration);
    });
  }
}

typedef void ConfigurationChangeListener(
    ConfigurationParser parser, Configurations newConfiguration);

/*
abstract class ConfigurationChangeListener {
  void onConfigurationChanged(
      ConfigurationParser parser, Configurations newConfiguration);
}*/

class ConfigurationChangedEvent {
  final ConfigurationParser parser;
  final Configurations newConfiguration;

  ConfigurationChangedEvent(this.parser, this.newConfiguration);
}
