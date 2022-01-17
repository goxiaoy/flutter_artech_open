import 'dart:io';

import 'package:artech_core/core.dart';

import 'generated/l10n.dart';

class SocketExceptionHandler implements ExceptionHandlerBase {
  @override
  bool canHandle(Object exception) {
    return exception is SocketException;
  }

  @override
  void handle(ExceptionContext context) {
    final e = context.latestError as SocketException;
    context.hasHandled = true;
    context.parsedException = UserFriendlyException.fromCodeLocaleMessage(
        code: (context) => 'NetworkException',
        message: (context) => S.of(context).networkUnavailable);
  }
}

class HandshakeExceptionHandler implements ExceptionHandlerBase {
  @override
  bool canHandle(Object exception) {
    return exception is HandshakeException;
  }

  @override
  void handle(ExceptionContext context) {
    final e = context.latestError as HandshakeException;
    context.hasHandled = true;
    context.parsedException = UserFriendlyException.fromCodeLocaleMessage(
        code: (context) => 'NetworkException',
        message: (context) => S.of(context).networkException);
  }
}
