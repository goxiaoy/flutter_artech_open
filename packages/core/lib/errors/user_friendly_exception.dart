import 'package:flutter/services.dart';

class UserFriendlyException extends PlatformException {
  UserFriendlyException({
    required String code,
    String? message,
    dynamic details,
    String? stacktrace,
  }) : super(
            code: code,
            message: message,
            details: details,
            stacktrace: stacktrace);
}
