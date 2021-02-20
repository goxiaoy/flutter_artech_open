import 'package:artech_core/core.dart';

import 'exception_context.dart';
import 'exception_handler.dart';

class ExceptionProcessor {
  final List<ExceptionHandlerBase> _handler = [];

  void addHandler(ExceptionHandlerBase handler) {
    _handler.add(handler);
  }

  Object process(Object e, StackTrace stackTrace) {
    final context = ExceptionContext(this, e, stackTrace);
    processContext(context);
    return context.finalException;
  }

  void processContext(ExceptionContext context) {
    for (final h in _handler) {
      if (h.canHandle(context.latestError)) {
        h.handle(context);
        if (context.hasHandled) {
          break;
        }
      }
    }
  }
}
