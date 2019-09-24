import 'dart:convert';
import 'dart:io';

import 'package:config_cat/src/fetch_response.dart';
import 'package:config_cat/src/project_config.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/config.dart';

class ConfigFetcher {
  final Logger logger = Logger('ConfigFetcher');
  final Dio _dio;
  String _url;
  String _version = "0.0.1";
  String _mode;

  ConfigFetcher(this._dio, String apiKey,
      {String baseUrl = "https://cdn.configcat.com"}) {
    this._url = '$baseUrl/configuration-files/$apiKey/config_v2.json';
  }

  setUrl(String url) {
    _url = url;
  }

  setMode(String mode) {
    _mode = mode;
  }

  Future<FetchResponse> fetch([ProjectConfig lastConfig]) {
    return _dio
        .get<String>(_url, options: getRequest(lastConfig))
        .then((response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        logger.fine('Fetch was successful: new config fetched');
        return FetchResponse(
            Status.FETCHED,
            ProjectConfig(parse(response.data),
                eTag: response.headers.value(HttpHeaders.etagHeader)));
      } else if (response.statusCode == 304) {
        logger.fine('Fetch was successful: config not modified');
        return FetchResponse(Status.NOTMODIFIED, lastConfig);
      } else {
        logger.fine('Non success status code: ${response.statusCode}');
      }
      return FetchResponse(Status.FAILED, lastConfig);
    }).catchError((e) {
      logger.severe(
          'An error occurred during fetching the latest configuration. : $e',
          e);
      return FetchResponse(Status.FAILED, ProjectConfig(null));
    });
  }

  Configurations parse(dynamic data) {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return Configurations.fromJson(json);
  }

  void close() {
    _dio.clear();
  }

  RequestOptions getRequest([ProjectConfig lastConfig]) {
    final header = {'X-ConfigCat-UserAgent': 'ConfigCat-Java/$_mode-$_version'};

    if (lastConfig != null && lastConfig.eTag != null) {
      header['If-None-Match'] = lastConfig.eTag;
    }
    return RequestOptions(headers: header, baseUrl: this._url);
  }
}
