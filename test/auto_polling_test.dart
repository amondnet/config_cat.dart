import 'dart:convert';
import 'dart:io';

import 'package:config_cat/config_cat.dart';
import 'package:config_cat/src/model/config.dart';
import 'package:config_cat/src/policy/auto_polling_policy.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

import 'utils.dart';

MockWebServer _server;

void main() {
  group(AutoPollingPolicy, () {
    AutoPollingPolicy policy;
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    setUp(() async {
      _server = new MockWebServer();
      await _server.start();
    });
    tearDown(() async {
      await _server.shutdown();
      policy?.dispose();
    });

    test('AutoPollingPolicy Test', () async {
      policy = AutoPollingPolicy(
          InMemoryConfigCache(), ConfigFetcher(Dio(), '', baseUrl: _server.url),
          pollingInterval: Duration(seconds: 1));
      _server.enqueue(body: readFile('test_resources/test.json'));
      final config = await policy.getConfiguration();

      expect(config, isNotNull);
      expect(config['test'].value, isTrue);
      expect(config['test'].settingType, equals(SettingType.BOOL));
      await policy.dispose();
    });

    test("config changed test", () async {
      _server.enqueue(body: readFile('test_resources/test.json'));
      _server.enqueue(body: readFile('test_resources/test2.json'));
      _server.enqueue(body: readFile('test_resources/test.json'));
      _server.enqueue(body: readFile('test_resources/test.json'));
      _server.enqueue(body: readFile('test_resources/test.json'));

      Configurations newConfig;
      final _policy = AutoPollingPolicy(
          InMemoryConfigCache(), ConfigFetcher(Dio(), '', baseUrl: _server.url),
          pollingInterval: const Duration(seconds: 1));
      _policy.addConfigurationChangeListener(
          (ConfigurationParser parser, Configurations newConfiguration) {
        print('changed : $newConfiguration');
        newConfig = newConfiguration;
      });
      //await policy.refresh();
      await Future.delayed(const Duration(milliseconds: 1500), () {});
      expect(newConfig, isNotNull);
      expect(newConfig['test'].value, isTrue);
      await Future.delayed(const Duration(seconds: 1), () {});
      expect(newConfig['test'].value, isFalse);
      await _policy.dispose();
    });

    test("refresh test", () async {
      _server.enqueue(body: readFile('test_resources/test.json'));
      _server.enqueue(body: readFile('test_resources/test2.json'));

      Configurations newConfig;
      policy?.dispose();
      policy = AutoPollingPolicy(
          InMemoryConfigCache(), ConfigFetcher(Dio(), '', baseUrl: _server.url),
          pollingInterval: const Duration(seconds: 10000));
      policy.addConfigurationChangeListener(
          (ConfigurationParser parser, Configurations newConfiguration) {
        print('changed : $newConfiguration');
        newConfig = newConfiguration;
      });
      await policy.refresh();
      expect(newConfig, isNotNull);
      expect(newConfig['test'].value, isTrue);
      await policy.refresh();
      expect(newConfig['test'].value, isFalse);
    });
  });

}
