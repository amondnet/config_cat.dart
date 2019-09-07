// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) {
  return Rule(
      json['Order'] as int,
      json['ComparisonAttribute'] as String,
      json['Comparator'] == null
          ? null
          : parseComparator(json['Comparator'] as int),
      json['ComparisonValue'],
      json['Value']);
}

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'Order': instance.order,
      'ComparisonAttribute': instance.comparisonAttribute,
      'Comparator': _$ComparatorEnumMap[instance.comparator],
      'ComparisonValue': instance.comparisonValue,
      'Value': instance.value
    };

const _$ComparatorEnumMap = <Comparator, dynamic>{
  Comparator.IS_IN: 'IS_IN',
  Comparator.IS_NOT_IN: 'IS_NOT_IN',
  Comparator.CONTAINS: 'CONTAINS',
  Comparator.NOT_CONTAINS: 'NOT_CONTAINS'
};
