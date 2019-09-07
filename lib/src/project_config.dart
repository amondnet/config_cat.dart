import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'model/config.dart';

@immutable
class ProjectConfig extends Equatable {
  DateTime timeStamp = DateTime.now().toUtc();
  String eTag;
  Configurations configurations;

  ProjectConfig(this.configurations, {this.timeStamp, this.eTag})
      : super([configurations, eTag]);
}
