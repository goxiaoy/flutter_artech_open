import 'package:artech_core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<IO.OptionBuilder> resolveBuilder({String tokenKey = 'token'}) async {
  var builder = IO.OptionBuilder();
  if (!kIsWeb) {
    builder = builder.setTransports(['websocket']);
  }
  final token = await serviceLocator.get<TokenManager>().get();
  if (token != null) {
    builder.setAuth(<dynamic, dynamic>{'token': token.token});
  }
  return builder;
}
