import 'dart:io';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_ui/src/colors.dart';
import 'package:path_provider/path_provider.dart';

export 'package:restart_app/restart_app.dart';

class CommonSettingPage extends StatelessWidget with ServiceGetter {
  @override
  Widget build(BuildContext context) {
    const bgColor = backgroundGray;
    TextStyle style = (Theme.of(context).textTheme.bodyText1 ?? TextStyle())
        .copyWith(color: Theme.of(context).disabledColor);
    return scaffoldBuilder(context,
        resizeToAvoidBottomInset: true,
        backgroundColor: bgColor,
        title: Text(S.of(context).settings),
        body: SafeArea(
            child: WidthConstrainContainer(
                padding: const EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: bgColor,
                ),
                child: HookBuilder(
                  builder: (BuildContext context) {
                    final value = useMenuGroup(settingMenuName);
                    final sections = value
                        .where((element) => element.widget!(context) is SettingsSection).toList();
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
                        .where((element) =>
                            element.priority <= settingMenuHelpPriority)
                        .toList(growable: false);
                    return SettingsList(
                      shrinkWrap: true,
                      backgroundColor: bgColor,
                      sections: [
                        if (kIsDebug)
                          SettingsSection(
                            titleTextStyle: style,
                            title: "Development Tools",
                            tiles: [
                              SettingsTile(
                                  title: "Test Page",
                                  leading: Icon(Icons.developer_board),
                                  trailing: ForwardIcon(),
                                  iosChevron: null,
                                  onPressed: (context) async {
                                    Navigator.of(context)
                                        .pushNamed(UIKitRoute.devTestPageRoute);
                                  })
                            ],
                          ),
                        // Display
                        if (display.length > 0)
                          SettingsSection(
                            title: S.of(context).displaySettings,
                            titleTextStyle: style,
                            tiles: [
                              ...display
                                  .map((e) => e.widget!(context))
                                  .map((a) => a is AbstractTile
                                      ? a
                                      : CustomTile(child: a))
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
                            title: S.of(context).userSettings,
                            titleTextStyle: style,
                            tiles: [
                              ...users
                                  .map((e) => e.widget!(context))
                                  .map((a) => a is AbstractTile
                                      ? a
                                      : CustomTile(child: a))
                                  .toList(growable: false),
                            ],
                          ),

                        // System
                        SettingsSection(
                          title: S.of(context).systemSettings,
                          titleTextStyle: style,
                          tiles: [
                            ...systems
                                .map((e) => e.widget!(context))
                                .map((a) => a is AbstractTile
                                    ? a
                                    : CustomTile(child: a))
                                .toList(growable: false),
                            SettingsTile(
                                title: S.of(context).restoreSettings,
                                leading: Icon(
                                  Icons.restore_outlined,
                                  color: Colors.red,
                                ),
                                trailing: ForwardIcon(),
                                iosChevron: null,
                                onPressed: (context) async {
                                  bool? restore =
                                      await showCupertinoModalPopup<bool>(
                                          context: context,
                                          builder: (ctx) {
                                            return ConfirmationCupertinoSheet(
                                                title: S
                                                    .of(context)
                                                    .restoreSettings,
                                                message:
                                                    '${S.of(context).restoreMessage}\n${S.of(context).areYouSure}',
                                                action: S.of(context).confirm);
                                          });

                                  if (restore == true) {
                                    // clean storage
                                    await serviceLocator
                                        .get<SettingStore>()
                                        .clearAll();

                                    // Delete temp
                                    if (UniversalPlatform.isAndroid ||
                                        UniversalPlatform.isIOS) {
                                      var temp =
                                          (await getTemporaryDirectory()).path;
                                      Directory(temp).delete(recursive: true);
                                    }

                                    // Restart
                                    if (UniversalPlatform.isAndroid) {
                                      // Not working my debug version
                                      // TODO:
                                      Restart.restartApp();
                                    }
                                    if (UniversalPlatform.isIOS)
                                      // TODO:
                                      exit(0); // iOS fina non packages
                                  }
                                })
                          ],
                        ),

                        if (helps.length > 0)
                          SettingsSection(
                            titleTextStyle: style,
                            title: S.of(context).helper,
                            tiles: [
                              ...helps
                                  .map((e) => e.widget!(context))
                                  .map((a) => a is AbstractTile
                                      ? a
                                      : CustomTile(child: a))
                                  .toList(growable: false),
                            ],
                          ),
                      ],
                    );
                  },
                ))));
  }
}
