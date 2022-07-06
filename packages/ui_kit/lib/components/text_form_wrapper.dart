import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

/// Handles input clear,
/// [actions] action icons
/// [suffixIcon] field type icon
/// [labelText] title or label
/// [name] filed name
class TextFormFieldWrapper extends HealthFormFieldWidget {
  final String name;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;
  final Widget? suffixIcon;
  final List<Widget>? actions;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool isDense;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;
  const TextFormFieldWrapper(
      {Key? key,
      bool enabled = true,
      bool isRequired = false,
      bool isHealthForm = false,
      TextStyle? textStyle,
      required this.name,
      this.controller,
      this.obscureText = false,
      this.readOnly = false,
      this.suffixIcon,
      this.labelText,
      this.hintText,
      this.initialValue,
      this.validator,
      this.onChanged,
      this.keyboardType,
      this.onTap,
      this.padding,
      this.isDense = true,
      this.actions})
      : super(
            key: key,
            isRequired: isRequired,
            enabled: enabled,
            textStyle: textStyle,
            isHealthForm: isHealthForm);

  @override
  State<StatefulWidget> createState() {
    return _TextFormFieldWrapperState();
  }
}

class _TextFormFieldWrapperState extends State<TextFormFieldWrapper>
    with MixinStateRequired {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant TextFormFieldWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.dispose();
      _controller = widget.controller ??
          TextEditingController(text: widget.initialValue ?? '');
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) _controller.dispose();
    super.dispose();
  }

  Widget _build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      enabled: widget.enabled,
      focusNode: focusNode,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      style: style,
      onTap: widget.onTap,
      onChanged: (value) {
        if (widget.onChanged != null) widget.onChanged!(value);
        setState(() {});
      },
      validator: widget.validator ??
          (value) {
            if (isRequired && _controller.text.isEmpty) {
              return S.of(context).error;
            }
            return null;
          },
      controller: _controller,
      keyboardType: widget.keyboardType,
      decoration: CustomInputDecoration(context,
          enabled: enabled,
          isHealthForm: isHealthForm,
          isDense: widget.isDense,
          hintText: widget.hintText,
          suffixIcon: suffixIcon(widget.actions ?? []),
          label: label(
            context,
          )),
    );
  }

  @override
  String get labelText => widget.labelText ?? '';

  @override
  bool get isEmpty => _controller.text.isEmpty;

  @override
  Widget buildField(BuildContext context) {
    return _build(context);
  }

  @override
  void clear() {
    _controller.text = '';
  }

  @override
  String get loggerName => 'TextFormFieldWrapper';
}
