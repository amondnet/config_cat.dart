import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'percentage.g.dart';

@JsonSerializable()
@immutable
class PercentageItem extends Equatable {
  @JsonKey(name: 'Order', defaultValue: 0)
  final int order;
  @JsonKey(name: 'Value')
  final dynamic value;
  @JsonKey(name: 'Percentage')
  final int percentage;

  PercentageItem(this.order, this.value, this.percentage)
      : super([order, value, percentage]);

  factory PercentageItem.fromJson(Map<String, dynamic> json) =>
      _$PercentageItemFromJson(json);
  Map<String, dynamic> toJson() => _$PercentageItemToJson(this);
}
