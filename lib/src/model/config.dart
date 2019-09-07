import 'package:config_cat/src/model/percentage.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'rule.dart';
part 'config.g.dart';

mixin Configurations implements Map<String, Config> {}

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
