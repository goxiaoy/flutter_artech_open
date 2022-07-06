import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

/// Handles input clear,
/// [actions] action icons
/// [suffixIcon] field type icon
/// [labelText] title or label
/// [name] filed name
class DropdownFormFieldWrapper<T> extends HealthFormFieldWidget {
  final String name;
  final T? initialValue;
  final FormFieldValidator<T>? validator;
  final ValueChanged<T?>? onChanged;
  final Widget? suffixIcon;
  final List<Widget>? actions;
  final String? labelText;
  final String? hintText;
  final bool? isDense;

  final List<DropdownMenuItem<T>> items;
  const DropdownFormFieldWrapper(
      {Key? key,
      bool enabled = true,
      bool isRequired = false,
      bool isHealthForm = false,
      TextStyle? textStyle,
      required this.name,
      required this.items,
      this.suffixIcon,
      this.labelText,
      this.hintText,
      this.initialValue,
      this.validator,
      this.onChanged,
      this.isDense,
      this.actions})
      : super(
            key: key,
            isHealthForm: isHealthForm,
            enabled: enabled,
            isRequired: isRequired,
            textStyle: textStyle);

  @override
  State<StatefulWidget> createState() {
    return _DropdownFormFieldWrapperState<T>();
  }
}

class _DropdownFormFieldWrapperState<T>
    extends State<DropdownFormFieldWrapper<T>> with MixinStateRequired {
  T? _value;
  @override
  bool get isRequired => widget.isRequired;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  String get labelText => widget.labelText ?? '';

  @override
  // TODO: implement isEmpty
  bool get isEmpty => _value == null;

  @override
  Widget buildField(BuildContext context) {
    return FormBuilderDropdown<T>(
      name: widget.name,
      initialValue: _value,
      isExpanded: true,
      enabled: widget.enabled,
      items: widget.items,
      style: widget.textStyle,
      onChanged: (T? value) {
        if (widget.onChanged != null) widget.onChanged!(value);
        setState(() {});
      },
      validator: widget.validator ??
          (value) {
            if (isRequired && value == null) {
              return S.of(context).emptyError;
            }
            return null;
          },
      decoration: CustomInputDecoration(context,
          isDense: widget.isDense,
          enabled: widget.enabled,
          label: label(context),
          hintText: widget.hintText),
    );
  }

  @override
  void clear() {
    setState(() {
      _value = null;
    });
  }

  @override
  String get loggerName => 'DropdownFormFieldWrapper';
}
