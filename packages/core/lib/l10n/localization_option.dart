import 'dart:ui';

import 'package:flutter/widgets.dart';

class LocalizationOption {
  final Set<Locale> support = <Locale>{};
  final Set<LocalizationsDelegate> delegates = <LocalizationsDelegate>{};
}
