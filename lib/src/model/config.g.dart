// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
      json['Value'],
      json['SettingType'] == null
          ? null
          : parseSettingType(json['SettingType'] as int),
      (json['RolloutPercentageItems'] as List)
          ?.map((e) => e == null
              ? null
              : PercentageItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['RolloutRules'] as List)
          ?.map((e) =>
              e == null ? null : Rule.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'Value': instance.value,
      'SettingType': instance.settingType == null
          ? null
          : settingTypeToInt(instance.settingType),
      'RolloutPercentageItems': instance.rolloutPercentageItems,
      'RolloutRules': instance.rolloutRules
    };
