import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ProjectConfig extends Equatable {
  DateTime timeStamp;
  String eTag;
  String jsonString;

  ProjectConfig(this.jsonString, this.timeStamp, this.eTag)
      : super([jsonString, eTag]);
}
