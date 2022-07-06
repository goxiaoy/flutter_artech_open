import 'package:flutter/cupertino.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Text(S.of(context).cancel),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }
}
