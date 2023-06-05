import 'dart:io';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class CommonSettingPage extends StatelessWidget with ServiceGetter {
  @override
  Widget build(BuildContext context) {
    TextStyle style = (Theme.of(context).textTheme.bodyLarge ?? TextStyle())
        .copyWith(color: Theme.of(context).disabledColor);
    return scaffoldBuilder(context,
        resizeToAvoidBottomInset: true,
        title: Text(S.of(context).settings), body: SafeArea(child: HookConsumer(
      builder: (context, ref, child) {
        final value = ref.watch(settingMenuProvider).value;
        final sections = value
            .where((element) => element.widget!(context) is SettingsSection)
            .toList();
        final display = value
            .where((element) =>
                element.priority <= settingMenuDisplayPriority &&
                element.priority > settingMenuUserPriority)
            .toList(growable: false);
        final users = value
            .where((element) =>
                element.priority <= settingMenuUserPriority &&
                element.priority > settingMenuSystemPriority)
            .toList(growable: false);
        final systems = value
            .where((element) =>
                element.priority <= settingMenuSystemPriority &&
                element.priority > settingMenuHelpPriority)
            .toList(growable: false);
        final helps = value
            .where((element) => element.priority <= settingMenuHelpPriority)
            .toList(growable: false);
        return SettingsList(
          sections: [
            if (kIsDebug)
              SettingsSection(
                title: Text(
                  "Development Tools",
                  style: style,
                ),
                tiles: [
                  SettingsTile(
                      title: Text("Test Page"),
                      leading: Icon(Icons.developer_board),
                      trailing: ForwardIcon(),
                      onPressed: (context) async {
                        Navigator.of(context)
                            .pushNamed(UIKitRoute.devTestPageRoute);
                      })
                ],
              ),
            // Display
            if (display.length > 0)
              SettingsSection(
                title: Text(
                  S.of(context).displaySettings,
                  style: style,
                ),
                tiles: [
                  ...display
                      .map((e) => e.widget!(context))
                      .map((a) => a is AbstractSettingsTile
                          ? a
                          : CustomSettingsTile(child: a))
                      .toList(growable: false),
                ],
              ),

            if (sections.length > 0)
              ...sections
                  .map((e) => e.widget!(context) as SettingsSection)
                  .toList(),

            // Users
            if (users.length > 0)
              SettingsSection(
                title: Text(
                  S.of(context).userSettings,
                  style: style,
                ),
                tiles: [
                  ...users
                      .map((e) => e.widget!(context))
                      .map((a) => a is AbstractSettingsTile
                          ? a
                          : CustomSettingsTile(child: a))
                      .toList(growable: false),
                ],
              ),

            // System
            SettingsSection(
              title: Text(
                S.of(context).systemSettings,
                style: style,
              ),
              tiles: [
                ...systems
                    .map((e) => e.widget!(context))
                    .map((a) => a is AbstractSettingsTile
                        ? a
                        : CustomSettingsTile(child: a))
                    .toList(growable: false),
                SettingsTile(
                    title: Text(
                      S.of(context).restoreSettings,
                      style: style,
                    ),
                    leading: Icon(
                      Icons.restore_outlined,
                      color: Colors.red,
                    ),
                    trailing: ForwardIcon(),
                    onPressed: (context) async {
                      bool? restore = await showCupertinoModalPopup<bool>(
                          context: context,
                          builder: (ctx) {
                            return ConfirmationCupertinoSheet(
                                title: S.of(context).restoreSettings,
                                message:
                                    '${S.of(context).restoreMessage}\n${S.of(context).areYouSure}',
                                action: S.of(context).confirm);
                          });

                      if (restore == true) {
                        // clean storage
                        await serviceLocator.get<SettingStore>().clearAll();

                        // Delete temp
                        if (UniversalPlatform.isAndroid ||
                            UniversalPlatform.isIOS) {
                          var temp = (await getTemporaryDirectory()).path;
                          Directory(temp).delete(recursive: true);
                        }
                      }
                    })
              ],
            ),

            if (helps.length > 0)
              SettingsSection(
                title: Text(
                  S.of(context).helper,
                  style: style,
                ),
                tiles: [
                  ...helps
                      .map((e) => e.widget!(context))
                      .map((a) => a is AbstractSettingsTile
                          ? a
                          : CustomSettingsTile(child: a))
                      .toList(growable: false),
                ],
              ),
          ],
        );
      },
    )));
  }
}
