import 'package:artech_core/core.dart';
import 'package:dio/dio.dart';

const disableAuthKey = 'disableAuth';

class AuthInterceptor extends Interceptor {
  TokenManager get tokenManager => serviceLocator.get<TokenManager>();

  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    if (options.extra[disableAuthKey] == true) {
      return super.onRequest(options);
    }
    final token = await tokenManager.get();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer ${token.token}';
    }
    return super.onRequest(options);
  }
}
