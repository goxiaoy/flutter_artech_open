import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';

class ErrorDialog {
  static void showErrorDialog(
      BuildContext context, String title, dynamic error) {
    //TODO locale
    String text = error.toString();
    if (error is UserFriendlyException) {
      text = '${error.code}\n${error.message}';
    }
    Future<void>.delayed(Duration.zero).then((value) => showDialog<void>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: SelectableText(text),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_outlined)),
            ],
          );
        }));
  }
}
