import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';

class EmailWidget extends StatelessWidget {
  final String email;
  final bool canMakeEmail;
  final bool dense;
  final bool textOnly;
  const EmailWidget(
      {Key? key,
      required this.email,
      this.textOnly = false,
      this.dense = true,
      this.canMakeEmail = true})
      : super(key: key);

  void _onTap(BuildContext context) async {
    final result = await showCupertinoModalPopup(
        context: context,
        builder: (_) => ConfirmationCupertinoSheet(action: S.of(context).sendEmail));

    if (result != null) {
      final launch = serviceLocator.get<LaunchService>();
      await launch.sendEmail(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = EmailValidator.validate(email);

    final enableCall = canMakeEmail && isValid;

    return textOnly
        ? GestureDetector(
            onTap: () => enableCall?_onTap(context):null,
            child: Text(
              email,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          )
        : ListTile(
            dense: dense,
            onTap: enableCall ? () => _onTap(context) : null,
            leading: textOnly ? null : Icon(Icons.email_outlined),
            title: SelectableText(email),
            trailing: enableCall && !textOnly ? ForwardIcon() : null,
          );
  }
}
