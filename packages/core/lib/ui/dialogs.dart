import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logging/logging.dart';

typedef LocalMessageFunc = String Function(BuildContext context);

void showMessageSnackBar(BuildContext context,
    {String message = '',
    Duration duration = const Duration(seconds: 2),
    MessageType type = MessageType.message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: duration,
    elevation: 4.0,
    backgroundColor: type.toColor(),
    content: Text(message),
  ));
}

Future<void> showToastContext(LocalMessageFunc messageFunc,
    {MessageType type = MessageType.success,
    double iconsSize = 100.0,
    double fontSize = 16.0,
    bool shortMessage = true,
    Color textColor = Colors.white}) async {
  ArgumentError.checkNotNull(messageFunc);
  final duration =
      shortMessage ? const Duration(seconds: 1) : const Duration(seconds: 4);
  final message = messageFunc(serviceLocator
      .get<NavigationService>()
      .navigatorKey
      .currentState!
      .context);
  EasyLoading.instance.backgroundColor = type.toColor();

  final f = Builder(builder: (context) {
    if (type == MessageType.success)
      return Icon(
        Icons.check_circle_outlined,
        color: textColor,
        size: iconsSize,
      );
    if (type == MessageType.error)
      return Icon(Icons.error_outline_rounded,
          color: textColor, size: iconsSize);
    if (type == MessageType.warn)
      return Icon(Icons.warning_amber_outlined,
          color: textColor, size: iconsSize);

    return const SizedBox(
      height: 12.0,
    );
  });

  EasyLoading.instance.infoWidget = f;
  return EasyLoading.showInfo(message, duration: duration);
}

Future<void> showToast(String message,
    {MessageType type = MessageType.success,
    double iconsSize = 100.0,
    double fontSize = 16.0,
    bool shortMessage = true,
    Color textColor = Colors.white}) async {
  return await showToastContext((_) => message,
      type: type,
      iconsSize: iconsSize,
      fontSize: fontSize,
      shortMessage: shortMessage,
      textColor: textColor);
}

enum MessageType {
  message,
  warn,
  success,
  error,
}

final _logger = Logger('MessageTypeExtension');

extension MessageTypeExtension on MessageType {
  Color toColor() {
    switch (this) {
      case MessageType.message:
      case MessageType.success:
        return Colors.black;
      case MessageType.warn:
        return Colors.orange[400]!;
      case MessageType.error:
        return Colors.red;
      default:
        _logger.warning('MessageType ${this} has no color');
        return Colors.black;
    }
  }
}
