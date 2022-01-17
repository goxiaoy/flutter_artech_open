import 'package:flutter/cupertino.dart';

class UserFriendlyException implements Exception {
  UserFriendlyException(
      {required this.code,
      this.message,
      this.details,
      this.stacktrace,
      this.localeText});

  factory UserFriendlyException.fromCodeMessage(
      {required String code,
      String? message,
      dynamic details,
      String? stacktrace}) {
    return UserFriendlyException(
        code: code, message: message, details: details, stacktrace: stacktrace);
  }

  factory UserFriendlyException.fromCodeLocaleMessage(
      {required String code,
      String Function(BuildContext context)? localeText,
      dynamic details,
      String? stacktrace}) {
    return UserFriendlyException(
        code: code,
        localeText: localeText,
        details: details,
        stacktrace: stacktrace);
  }

  /// An error code.
  final String code;

  /// A human-readable error message, possibly null.
  final String? message;

  final dynamic details;

  final String? stacktrace;

  final String Function(BuildContext context)? localeText;

  String getMessage(BuildContext context) {
    if (localeText != null) {
      return localeText!(context);
    }
    return message ?? '';
  }

  @override
  String toString() =>
      'UserFriendlyException($code, $message, $details, $stacktrace)';
}
