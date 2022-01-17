import 'package:artech_core/errors/exception_context.dart';
import 'package:dio/dio.dart';
import 'exception_handler.dart';

class DioExceptionHandler implements ExceptionHandlerBase {
  @override
  bool canHandle(Object exception) {
    return exception is DioError;
  }

  String? _responseCode(int? code) {
    //TODO: implement when needed
    switch (code) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      default:
    }
  }

  @override
  void handle(ExceptionContext context) {
    final error = context.latestError as DioError;
    context.hasHandled = true;
    switch (error.type) {
      case DioErrorType.response:
        context.parsedException = _responseCode(error.response!.statusCode);
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.connectTimeout:
        break;
      case DioErrorType.sendTimeout:
        break;
      case DioErrorType.receiveTimeout:
        break;
      default:
        context.hasHandled = false;
    }
  }
}
