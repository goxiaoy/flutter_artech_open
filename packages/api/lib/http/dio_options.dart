import 'package:dio/dio.dart';

class DioOptions {
  int? connectTimeout = 10000;
  int? receiveTimeout = 10000;
  Interceptors interceptors = Interceptors();
}
