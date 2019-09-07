import 'dart:convert';
import 'dart:io';

import 'package:config_cat/config_cat.dart';
import 'package:config_cat/src/model/config.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('First Test', () async {
      final file = new File('test_resources/test.json');
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final configurations =
          map.map((string, value) => MapEntry(string, Config.fromJson(value)));
      configurations.keys.forEach((s) => print(s));
    });
  });
}
