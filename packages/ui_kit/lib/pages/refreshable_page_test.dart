import 'package:artech_ui_kit/components/artech_scaffold.dart';
import 'package:artech_ui_kit/hooks/hooks.dart';
import 'package:artech_ui_kit/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:artech_core/core.dart';

class RefreshablePageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context, title: Text("Refreshable Test"),
        body: RefreshablePage(
      child: HookConsumer(
        builder: (context, ref, child) {
          useRefreshablePage(() async {
            await showToast("Refresh 1");
          });
          useRefreshablePage(() async {
            await showToast("Refresh 2");
          });
          useRefreshablePage(() async {
            await showToast("Refresh 3");
          });
          return ListView();
        },
      ),
    ));
  }
}
