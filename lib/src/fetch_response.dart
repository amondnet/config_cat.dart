import 'package:json_annotation/json_annotation.dart';

class FetchResponse {
  Status status;
  String config;

  FetchResponse(this.status, this.config);

  get isFetched => status == Status.FETCHED;

  get isNotModified => status == Status.NOTMODIFIED;

  get isFailed => status == Status.FAILED;
}

enum Status { FETCHED, NOTMODIFIED, FAILED }
