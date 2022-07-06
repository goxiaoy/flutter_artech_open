import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationCupertinoSheet extends StatelessWidget {
  final String? action;
  final String? title;
  final String? message;
  const ConfirmationCupertinoSheet(
      {Key? key, this.action, this.message, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.headline6,
            )
          : Text(action ?? S.of(context).confirm,
              style: Theme.of(context).textTheme.headline6),
      message: message != null
          ? Text(message!)
          : Text('${S.of(context).areYouSure} $action?'),
      actions: [
        CupertinoActionSheetAction(
          child: Text(
            action ?? S.of(context).confirm,
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop<bool>(true);
          },
        ),
      ],
      cancelButton: CancelButton(),
    );
  }
}

Future<bool?> showConfirmationPopup(BuildContext context,
    {String? actionText,
    required String title,
    required String message}) async {
  return await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationCupertinoSheet(
          title: title,
          message: message,
          action: actionText,
        );
      });
}
