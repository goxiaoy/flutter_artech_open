import 'package:artech_core/core.dart';
import 'package:flutter/cupertino.dart';

class UserFriendlyException implements Exception {
  UserFriendlyException._({
    String? code,
    this.localeCode,
    String? message,
    this.localeText,
    this.details,
    this.stacktrace,
  })  : _code = code,
        _message = message;

  factory UserFriendlyException.fromCodeMessage(
      {required String code,
      String? message,
      dynamic details,
      String? stacktrace}) {
    return UserFriendlyException._(
        code: code, message: message, details: details, stacktrace: stacktrace);
  }

  factory UserFriendlyException.fromCodeLocaleMessage(
      {required String Function(BuildContext context) code,
      String Function(BuildContext context)? message,
      dynamic details,
      String? stacktrace}) {
    return UserFriendlyException._(
        localeCode: code,
        localeText: message,
        details: details,
        stacktrace: stacktrace);
  }

  /// An error code.
  final String? _code;

  final String? _message;

  final dynamic details;

  final String? stacktrace;

  final String Function(BuildContext context)? localeText;
  final String Function(BuildContext context)? localeCode;

  String getMessage(BuildContext context) {
    if (localeText != null) {
      return localeText!(context);
    }
    return _message ?? '';
  }

  String getCode(BuildContext context) {
    if (localeCode != null) {
      return localeCode!(context);
    }
    return _code ?? '';
  }

  @override
  String toString() {
    final context =
        serviceLocator.get<NavigationService>().navigatorKey.currentContext!;
    return 'UserFriendlyException(${getCode(context)},  ${getMessage(context)}, $details, $stacktrace)';
  }
}
