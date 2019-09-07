import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'rule.g.dart';

@JsonSerializable()
@immutable
class Rule extends Equatable {
  @JsonKey(name: 'Order')
  int order = 0;
  @JsonKey(name: 'ComparisonAttribute')
  String comparisonAttribute;
  @JsonKey(name: 'Comparator', fromJson: parseComparator)
  Comparator comparator;
  @JsonKey(name: 'ComparisonValue')
  dynamic comparisonValue;
  @JsonKey(name: 'Value')
  dynamic value;

  Rule(this.order, this.comparisonAttribute, this.comparator,
      this.comparisonValue, this.value)
      : super([order, comparisonAttribute, comparator, comparisonValue, value]);

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
  Map<String, dynamic> toJson() => _$RuleToJson(this);
}

enum Comparator { IS_IN, IS_NOT_IN, CONTAINS, NOT_CONTAINS }
Comparator parseComparator(int value) {
  if (value == 0) {
    return Comparator.IS_IN;
  } else if (value == 1) {
    return Comparator.IS_NOT_IN;
  } else if (value == 2) {
    return Comparator.CONTAINS;
  } else if (value == 3) {
    return Comparator.NOT_CONTAINS;
  }
  throw Exception('Unsupported Comparator');
}
