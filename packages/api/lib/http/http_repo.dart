import 'package:artech_core/core.dart';
import 'package:dio/dio.dart';

mixin HttpRepoMixin {
  Dio dioNamed({String name}) => serviceLocator.get<Dio>(instanceName: name);
}
