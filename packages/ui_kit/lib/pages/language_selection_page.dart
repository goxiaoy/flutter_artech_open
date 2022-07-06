import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  SettingStore get ss => serviceLocator.get<SettingStore>();

  @override
  Widget build(BuildContext context) {
    var opt = serviceLocator.get<LocalizationOption>();
    return scaffoldBuilder(context,
        title: Text(S.of(context).language),
        body: SafeArea(
          child: SettingsList(
            sections: [
              SettingsSection(
                  tiles: opt.support
                      .map((e) => SettingsTile(
                            title: e.textBuilder(context),
                            trailing: trailingWidget(e.locale),
                            onPressed: (_) async {
                              changeLanguage(e.locale);
                              Navigator.of(context).pop();
                            },
                            iosChevron: null,
                          ))
                      .toList()),
            ],
          ),
        ));
  }

  Widget trailingWidget(Locale index) {
    return (Localizations.localeOf(context) == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  Future<void> changeLanguage(Locale index) async {
    await ss.set(LocalizationOption.settingKey, index.languageCode);
    setState(() {});
  }
}
