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
    {MessageType type = MessageType.success,
      double iconsSize = 100.0,
      double fontSize = 16.0,
      bool shortMessage = true,
      Color textColor = Colors.white}) async {
  ArgumentError.checkNotNull(message);

  if (FToast().context == null) {
    return await Fluttertoast.showToast(
        msg: message,
        toastLength: shortMessage ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: type.toColor(),
        textColor: textColor,
        fontSize: fontSize);
  } else {
    FToast().showToast(
        toastDuration: shortMessage
            ? const Duration(seconds: 2)
            : const Duration(seconds: 5),
        gravity: ToastGravity.CENTER,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: type.toColor(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(type == MessageType.success)
                Icon(Icons.check_circle_outlined, color: textColor,
                  size: iconsSize,),
              if(type == MessageType.error)
                Icon(Icons.error_outline_rounded, color: textColor,
                    size: iconsSize),
              if(type == MessageType.warn)
                Icon(Icons.warning_amber_outlined, color: textColor,
                    size: iconsSize),
              if(type != MessageType.message)
                const SizedBox(
                  height: 12.0,
                ),
              Text(message,
                style: TextStyle(color: textColor, fontSize: fontSize),),
            ],
          ),
        ));
    return Future.value(true);
  }
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

