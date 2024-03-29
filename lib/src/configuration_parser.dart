import 'dart:convert';

import 'package:config_cat/src/model/config.dart';

import 'package:config_cat/src/model/user.dart';
import 'rollout_evaluator.dart';

class ConfigurationParser {
  final RolloutEvaluator _rolloutEvaluator = new RolloutEvaluator();

  List<String> getAllKeys(Map<String, Config> configurations) {
    return configurations.keys.toList();
  }

  dynamic parseValue(
      Map<String, Config> configurations, String key, User user) {
    return _rolloutEvaluator.evaluate(configurations[key], key, user);
  }
}
