import 'package:artech_core/utils/json_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioOptions {
  int? connectTimeout = 10000;
  int? receiveTimeout = 10000;
  Interceptors interceptors = Interceptors();
  bool webWithCredentials = true;
  bool ignoreBadCert = false;
}

void patchOption(Dio dio, DioOptions opt) {
  if (opt.connectTimeout != null) {
    dio.options.connectTimeout = opt.connectTimeout!;
  }
  if (opt.receiveTimeout != null) {
    dio.options.receiveTimeout = opt.receiveTimeout!;
  }
  dio.interceptors.addAll(opt.interceptors);
  if (opt.webWithCredentials && kIsWeb) {
    (dio.httpClientAdapter as dynamic).withCredentials = true;
  }
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = computeParseJson;
}
