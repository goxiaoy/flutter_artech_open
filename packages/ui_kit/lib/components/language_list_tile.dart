import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LanguageListTile extends StatefulHookWidget {
  const LanguageListTile({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LanguageListTileState();
  }
}

class _LanguageListTileState extends State<LanguageListTile> {
  @override
  Widget build(BuildContext context) {
    final localOpt = serviceLocator.get<LocalizationOption>();

    final _language = useWatchSettingKey<String>(
        serviceLocator.get<SettingStore>(), LocalizationOption.settingKey);

    return _language != null
        ? PopupMenuButton<Locale>(
            itemBuilder: (BuildContext context) => localOpt.support
                .map(
                  (e) => CheckedPopupMenuItem<Locale>(
                    checked: _language == e.locale.languageCode,
                    value: e.locale,
                    child: Text(e.textBuilder(context)),
                  ),
                )
                .toList(),
            child: ListTile(
              leading: const Icon(
                Icons.language,
                color: Colors.blue,
              ),
              title: Text(S.of(context).language),
              trailing: const Icon(Icons.more_vert, color: Colors.grey),
            ),
            //value: locale,
            onSelected: (Locale value) {
              if (value.languageCode != _language) {
                serviceLocator
                    .get<SettingStore>()
                    .set(LocalizationOption.settingKey, value.languageCode);
              }
            },
          )
        : Container();
  }
}
