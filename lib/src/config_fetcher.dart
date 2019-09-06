import 'dart:convert';

import 'package:config_cat/src/fetch_response.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class ConfigFetcher {
  final Logger logger = Logger('ConfigFetcher');
  final Dio _dio;
  String _url;
  String _version = "0.0.1";
  String _mode;

  String _eTag;
  ConfigFetcher(this._dio, String apiKey,
      {String baseUrl = "https://cdn.configcat.com"}) {
    this._url = '$baseUrl/configuration-files/" + apiKey + "/config_v2.json';
  }

  setUrl(String url) {
    _url = url;
  }

  setMode(String mode) {
    _mode = mode;
  }

  Future<FetchResponse> getConfigurationJsonString() {
    return _dio.get<String>('', options: getRequest()).then((response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        logger.fine('Fetch was successful: new config fetched');
        return FetchResponse(Status.FETCHED, response.data);
      } else if (response.statusCode == 304) {
        logger.fine('Fetch was successful: config not modified');
        return FetchResponse(Status.NOTMODIFIED, response.data);
      } else {
        logger.fine('Non success status code: ${response.statusCode}');
      }
      return FetchResponse(Status.FAILED, response.data);
    }).catchError((e) {
      logger.severe(
          'An error occurred during fetching the latest configuration.', e);
      return FetchResponse(Status.FAILED, null);
    });
  }

  void close() {
    _dio.clear();
  }

  RequestOptions getRequest() {
    final header = {'X-ConfigCat-UserAgent': 'ConfigCat-Java/$_mode-$_version'};

    if (_eTag != null) {
      header['If-None-Match'] = _eTag;
    }
    return RequestOptions(headers: header, baseUrl: this._url);
  }
}
