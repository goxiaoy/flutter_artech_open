import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LocalizationOption {
  static const settingKey = 'app.locale.languageCode';
  //default locale
  Locale? defaultLocale;
  final Set<SettingLocale> support = <SettingLocale>{};
  final Set<LocalizationsDelegate> delegates = <LocalizationsDelegate>{};
}

@immutable
class SettingLocale {
  const SettingLocale({required this.locale, required this.textBuilder});
  final Locale locale;
  final String Function(BuildContext conext) textBuilder;

  @override
  bool operator ==(Object other) {
    if (other is! SettingLocale) {
      return false;
    }
    return other.locale == locale;
  }

  @override
  int get hashCode => locale.hashCode;
}
