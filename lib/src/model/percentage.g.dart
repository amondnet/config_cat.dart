// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'percentage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PercentageItem _$PercentageItemFromJson(Map<String, dynamic> json) {
  return PercentageItem(
      json['Order'] as int ?? 0, json['Value'], json['Percentage'] as int);
}

Map<String, dynamic> _$PercentageItemToJson(PercentageItem instance) =>
    <String, dynamic>{
      'Order': instance.order,
      'Value': instance.value,
      'Percentage': instance.percentage
    };
