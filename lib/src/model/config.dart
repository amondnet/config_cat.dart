import 'dart:collection';
import 'dart:convert';

import 'package:config_cat/src/model/percentage.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'rule.dart';
part 'config.g.dart';

class Configurations extends MapBase<String, Config> {
  final Map<String, Config> _map;
  Configurations(this._map);

  factory Configurations.fromJson(Map<String, dynamic> json) {
    return Configurations(json.map((k, v) => MapEntry(k, Config.fromJson(v))));
  }

  @override
  Config operator [](Object key) {
    return _map[key];
  }

  @override
  void operator []=(String key, Config value) {
    _map[key] = value;
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  Iterable<String> get keys => _map.keys;

  @override
  Config remove(Object key) {
    return _map.remove(key);
  }
}

@JsonSerializable()
@immutable
class Config extends Equatable {
  @JsonKey(name: 'Value')
  final dynamic value;
  @JsonKey(name: 'SettingType', fromJson: parseSettingType)
  final SettingType settingType;

  @JsonKey(name: "RolloutPercentageItems")
  final List<PercentageItem> rolloutPercentageItems;
  @JsonKey(name: "RolloutRules")
  final List<Rule> rolloutRules;

  Config(this.value, this.settingType, this.rolloutPercentageItems,
      this.rolloutRules)
      : super([value, settingType, rolloutPercentageItems, rolloutRules]);

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}

enum SettingType { BOOL, STRING, INT, DOUBLE }

SettingType parseSettingType(int value) {
  if (value == 0) {
    return SettingType.BOOL;
  } else if (value == 1) {
    return SettingType.BOOL;
  } else if (value == 2) {
    return SettingType.BOOL;
  } else if (value == 3) {
    return SettingType.BOOL;
  }
  throw Exception('Unsupported Type');
}
