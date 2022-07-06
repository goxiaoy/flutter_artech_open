import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/material.dart';

class LanguageListTile extends StatefulWidget {
  const LanguageListTile({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LanguageListTileState();
  }
}

class _LanguageListTileState extends State<LanguageListTile>
    with MixinSettingState, ServiceGetter {
  String? _language;
  late StreamSubscription<KeyChangeEvent> _languageSubscription;

  @override
  void initState() {
    super.initState();
    _languageSubscription =
        settingStore.watch(key: LocalizationOption.settingKey).listen((event) {
      if (mounted) {
        setState(() {
          _language = event.value;
        });
      }
    });
    settingStore.get<String>(LocalizationOption.settingKey).then((value) {
      if (mounted) {
        if (value == null) {
          final opt = services.get<LocalizationOption>();
          _language = opt.defaultLocale!.languageCode;
        } else {
          setState(() {
            _language = value;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _languageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localOpt = services.get<LocalizationOption>();
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
                settingStore.set(
                    LocalizationOption.settingKey, value.languageCode);
              }
            },
          )
        : Container();
  }
}
