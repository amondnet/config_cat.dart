import 'dart:convert';
import 'dart:io';

import 'package:config_cat/config_cat.dart';
import 'package:config_cat/src/model/config.dart';
import 'package:test/test.dart';

void main() {
  group(ConfigurationParser, () {
    ConfigurationParser parser;
    setUp(() {
      parser = ConfigurationParser();
    });

    test('ConfigurationParser Test', () async {
      final file = new File('test_resources/test.json');
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

      final Configurations configurations = Configurations.fromJson(map);
      configurations.keys.forEach((s) => print(s));

      final value = parser.parseValue(configurations, "test", null);

      expect(value, isTrue);
    });
  });
}
