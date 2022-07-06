import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

class EmailFormField extends HealthFormFieldWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final bool isDense;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final String name;
  final EdgeInsetsGeometry? padding;
  const EmailFormField(
      {Key? key,
      bool enabled = true,
      bool isRequired = false,
      bool healthForm = false,
      TextStyle? textStyle,
      required this.onChanged,
      required this.name,
      this.isDense = true,
      this.validator,
      this.autoValidateMode,
      this.padding,
      this.initialValue})
      : super(
            key: key,
            enabled: enabled,
            isRequired: isRequired,
            isHealthForm: healthForm,
            textStyle: textStyle);
  @override
  State<StatefulWidget> createState() {
    return _EmailFormFieldState();
  }
}

class _EmailFormFieldState extends State<EmailFormField>
    with MixinStateRequired {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  String? _validator(String? vale) {
    if (widget.isRequired) {
      return EmailValidator.validate(_controller.text)
          ? null
          : S.of(context).invalidEmail;
    } else {
      if (_controller.text.length > 0) {
        return EmailValidator.validate(_controller.text)
            ? null
            : S.of(context).invalidEmail;
      } else
        return null;
    }
  }

  @override
  void didUpdateWidget(covariant EmailFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  String get labelText => S.of(context).email;

  @override
  bool get isEmpty => _controller.text.isEmpty;

  @override
  Widget buildField(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      autovalidateMode: widget.autoValidateMode ?? AutovalidateMode.always,
      enabled: widget.enabled,
      style: style,
      onChanged: widget.onChanged,
      controller: _controller,
      validator: widget.validator ?? _validator,
      keyboardType: TextInputType.emailAddress,
      decoration: CustomInputDecoration(context,
          enabled: enabled,
          isHealthForm: isHealthForm,
          isDense: widget.isDense,
          hintText: S.of(context).email,
          suffixIcon: suffixIcon([Icon(Icons.email)]),
          label: label(
            context,
          )),
      // decoration: CustomInputDecoration(context,
      //     enabled: enabled,
      //     isHealthForm: isHealthForm,
      //     isDense: widget.isDense,
      //     hintText: S.of(context).email,
      //     suffixIcon: suffixIcon([]),
      //     label: label(context)),
    );
  }

  @override
  void clear() {
    _controller.text = '';
  }

  @override
  // TODO: implement loggerName
  String get loggerName => throw UnimplementedError();
}
