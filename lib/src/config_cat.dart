import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'user.dart';

class ConfigCat {
  final Logger logger = Logger('ConfigCat');

  ConfigCat._internal() {
    _cacheChannel.receiveBroadcastStream((args) {});
  }
}
