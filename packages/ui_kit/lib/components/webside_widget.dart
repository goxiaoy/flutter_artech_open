import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class WebsiteWidget extends StatelessWidget {
  final String website;
  final bool canLaunch;
  const WebsiteWidget({required this.website, this.canLaunch = true});

  @override
  Widget build(BuildContext context) {
    final bool isValid = isURL(website);

    final enabled = canLaunch && isValid;
    return ListTile(
        onTap: enabled
            ? () async {
                final result = await showCupertinoModalPopup(
                    context: context,
                    builder: (_) =>
                        ConfirmationCupertinoSheet(action: S.of(context).launchWeb));

                if (result != null) {
                  final launch = serviceLocator.get<LaunchService>();
                  await launch.webView(website);
                }
              }
            : null,
        trailing: enabled ? ForwardIcon() : null,
        leading: Icon(Icons.web_outlined),
        title: SelectableText(
          website,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ));
  }
}
