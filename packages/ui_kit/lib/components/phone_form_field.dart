import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneFormField extends HealthFormFieldWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final ValueChanged<PhoneNumber>? onSaved;
  final AutovalidateMode? autoValidateMode;
  final String name;
  final bool isDense;
  const PhoneFormField(
      {Key? key,
      bool healthForm = false,
      bool isRequired = false,
      bool enabled = true,
      TextStyle? textStyle,
      required this.onChanged,
      required this.name,
      this.isDense = false,
      this.onSaved,
      this.autoValidateMode,
      this.initialValue})
      : super(
            key: key,
            isRequired: isRequired,
            enabled: enabled,
            isHealthForm: healthForm,
            textStyle: textStyle);
  @override
  State<StatefulWidget> createState() {
    return _PhoneFormFiledState();
  }
}

class _PhoneFormFiledState extends State<PhoneFormField>
    with MixinStateRequired {
  PhoneNumber? _phoneNumber;
  bool _phoneValid = false;

  void initState() {
    super.initState();
  }

  @override
  bool get enabled => widget.enabled;

  @override
  bool get isRequired => widget.isRequired;

  @override
  String get labelText => S.of(context).mobilePhone;

  @override
  bool get isEmpty => _phoneNumber == null;

  @override
  Widget buildField(BuildContext context) {
    return IntrinsicHeight(
      child: InternationalPhoneNumberInput(
        key: ValueKey<String>(widget.name),
        isEnabled: widget.enabled,
        scrollPadding: EdgeInsets.zero,
        textAlignVertical: TextAlignVertical.top,
        // There is no way to default country code!!!
        initialValue: _phoneNumber ?? PhoneNumber(isoCode: 'US'),
        selectorConfig: SelectorConfig(
            showFlags: isHealthForm ? false : true,
            leadingPadding: 0.0,
            setSelectorButtonAsPrefixIcon: false,
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
        countries: ['US', 'CN'],
        ignoreBlank: !widget.isRequired,
        spaceBetweenSelectorAndTextField: 0.0,
        selectorTextStyle: widget.textStyle,
        selectorButtonOnErrorPadding: 0.0,
        inputDecoration: CustomInputDecoration(context,
            isHealthForm: isHealthForm,
            enabled: enabled,
            isDense: widget.isDense,
            hintText: S.of(context).phoneNumber,
            label: label(context)),
        autoValidateMode: widget.autoValidateMode ?? AutovalidateMode.always,
        onInputValidated: (value) {
          _phoneValid = value;
          setState(() {});
        },
        textStyle: widget.textStyle,
        locale: Localizations.localeOf(context).languageCode,
        onInputChanged: (PhoneNumber value) {
          _phoneNumber = value;
          if (_phoneValid) widget.onChanged(_phoneNumber?.parseNumber());
        },
        onSaved: widget.onSaved,
      ),
    );
  }

  @override
  void clear() {
    setState(() {
      _phoneNumber = null;
    });
  }

  @override
  String get loggerName => 'PhoneFormField';
}
