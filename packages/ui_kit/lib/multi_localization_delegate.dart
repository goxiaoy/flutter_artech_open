import 'package:artech_core/core.dart';
import 'package:flutter/cupertino.dart';

import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';

class MultiAppLocalizationsDelegate extends AppLocalizationDelegate {
  const MultiAppLocalizationsDelegate();

  static const AppLocalizationDelegate delegate =
      MultiAppLocalizationsDelegate();

  @override
  Future<S> load(Locale locale) {
    return MultipleLocalizations.load(
        initializeMessages, locale, (l) => S.load(locale),
        setDefaultLocale: true);
  }
}
