import 'package:artech_core/core.dart';
import 'package:dio/dio.dart';

const disableAuthKey = 'disableAuth';

extension OptionsExtension on Options {
  Options disableAuth() {
    //disable auth
    extra = extra ?? <String, dynamic>{};
    extra![disableAuthKey] = true;
    return this;
  }
}

class AuthInterceptor extends Interceptor {
  TokenManager get tokenManager => serviceLocator.get<TokenManager>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[disableAuthKey] == true) {
      return super.onRequest(options, handler);
    }
    tokenManager.get().then((token) {
      if (token != null) {
        options.headers['Authorization'] = 'Bearer ${token.token}';
      }
      return super.onRequest(options, handler);
    }, onError: (dynamic e, StackTrace s) {
      return super.onRequest(options, handler);
    });
  }
}
