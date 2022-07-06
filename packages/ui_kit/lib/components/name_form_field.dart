import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

class NameFormField extends StatelessWidget {
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final int nameLength;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final bool isRequired;
  final bool healthForm;
  final bool isDense;
  final TextStyle? textStyle;
  final String name;
  NameFormField({
    Key? key,
    required this.onChanged,
    required this.name,
    this.initialValue,
    this.validator,
    this.nameLength = 5,
    this.enabled = true,
    this.isRequired = true,
    this.healthForm = false,
    this.textStyle,
    this.isDense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWrapper(
      isRequired: isRequired,
      enabled: enabled,
      isDense: isDense,
      name: name,
      textStyle: textStyle,
      isHealthForm: healthForm,
      initialValue: initialValue,
      onChanged: onChanged,
      labelText: S.of(context).fullName,
      hintText: S.of(context).fullName,
      validator: validator ??
          (value) {
            if (value == null || value.length < nameLength)
              return isRequired ? S.of(context).fullNameError : null;
            if (value.length < 2) return S.of(context).fullNameError;
            return null;
          },
    );
  }
}
