import 'package:artech_ui_kit/data/gender.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

extension GenderExtension on Gender {
  String toLocaleText(BuildContext context) {
    if (this == Gender.male)
      return S.of(context).genderMale;
    else if (this == Gender.female)
      return S.of(context).genderFemale;
    else if (this == Gender.other)
      return S.of(context).genderOther;
    else if (this == Gender.unknown)
      return S.of(context).genderNotDecided;
    else
      throw UnimplementedError();
  }
}
