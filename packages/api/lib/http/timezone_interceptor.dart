import 'package:dio/dio.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeZoneInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-TZ'] = tz.local.name;
    return super.onRequest(options, handler);
  }
}
