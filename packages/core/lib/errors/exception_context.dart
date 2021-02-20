import 'package:artech_core/core.dart';

class ExceptionContext {
  ExceptionContext(this.processor, Object rawException, this.rawStackTrace) {
    errors.add(rawException);
  }

  final ExceptionProcessor processor;

  final List<Object> errors = [];

  final StackTrace? rawStackTrace;

  Object get latestError => errors.last;

  bool hasHandled = false;

  Object? parsedException;

  Object get finalException => parsedException ?? latestError;

  void addError(Object error) {
    errors.add(error);
  }
}
