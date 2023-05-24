import 'package:artech_core/core.dart';


abstract class ExceptionHandlerBase {
  bool canHandle(Object exception);

  void handle(ExceptionContext context);
}

class LogStackTraceExceptionHandler extends ExceptionHandlerBase
    with HasNamedLogger {
  @override
  bool canHandle(Object exception) => true;

  @override
  void handle(ExceptionContext context) {
    if (kIsDebug && context.rawStackTrace != null) {
      logger.severe(context.errors.map((e) => e.toString()).join('\n'),
          context.latestError, context.rawStackTrace);
    }
  }

  @override
  String get loggerName => 'LogStackTraceExceptionHandler';
}
