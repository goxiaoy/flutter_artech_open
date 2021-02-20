import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';

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

Future<bool> showToast(String message,
    {MessageType type = MessageType.message}) async {
  return await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: type.toColor(),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum MessageType {
  message,
  warn,
  error,
}

final _logger = Logger('MessageTypeExtension');

extension MessageTypeExtension on MessageType {
  Color toColor() {
    switch (this) {
      case MessageType.message:
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
