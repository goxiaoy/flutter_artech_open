import 'dart:async';
import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui.dart';

//TODO clean this code
class ErrorDialog {
  static void showErrorDialog(
      BuildContext context, String title, dynamic error) {
    // TODO: Implementation
    showDialog<void>(context: context, builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: Text(error.toString()),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
        ],
      );
    });
  }
  //   ArgumentError.checkNotNull(context);
  //   ArgumentError.checkNotNull(title);
  //   ArgumentError.checkNotNull(error);
  //   String content;
  //   String code;
  //
  //   // Handles PlatformException
  //   if (error is PlatformException) {
  //     PlatformException exception = error;
  //     if (exception.code == 'SocketException') {
  //       Future<void>.delayed(Duration.zero).then((value) => showMessageSnackBar(
  //           context,
  //           type: MessageType.warn,
  //           message: '${S.of(context).socketError}'));
  //       return;
  //     } else if (exception.code == 'cancelled' ||
  //         exception.code == 'redirectCancelled' ||
  //         exception.code == 'purchaseCancelled') {
  //       var messages = '$title ${S.of(context).canceled}';
  //       if (kIsDebug) {
  //         messages += '-' + exception.message;
  //       }
  //       Future<void>.delayed(Duration.zero).then((value) => showMessageSnackBar(
  //           context,
  //           type: MessageType.warn,
  //           message: messages));
  //       return;
  //     } else if (exception.code == 'Forbidden') {
  //       Future<void>.delayed(Duration.zero).then((value) => showMessageSnackBar(
  //           context,
  //           type: MessageType.warn,
  //           message: '$title ${S.of(context).forbidden}'));
  //       return;
  //     } else if (exception.code == kNotSupported) {
  //       Future<void>.delayed(Duration.zero).then((value) => showMessageSnackBar(
  //           context,
  //           duration: const Duration(seconds: 4),
  //           type: MessageType.warn,
  //           message: exception.message));
  //       return;
  //     } else if (exception.code == kArtechWarningCode) {
  //       Future<void>.delayed(Duration.zero).then((value) => showMessageSnackBar(
  //           context,
  //           duration: const Duration(seconds: 4),
  //           type: MessageType.warn,
  //           message: exception.message));
  //       return;
  //     } else {
  //       content = exception.message;
  //       if (kIsDebug) {
  //         content = exception.stacktrace;
  //       }
  //       code = exception.code;
  //       content = exception.message;
  //     }
  //   } else {
  //     content = error.toString();
  //   }
  //
  //   Future<void>.delayed(Duration.zero).then((value) => showDialog(
  //       context: context,
  //       builder: (cxt) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //           ),
  //           title: Text(code != null ? code : title),
  //           content: Text(content ?? ''),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text(S.of(context).close),
  //               onPressed: () {
  //                 Navigator.of(cxt).pop();
  //               },
  //             )
  //           ],
  //         );
  //       }));
  // }
}
