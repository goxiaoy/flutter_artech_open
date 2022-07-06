import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

/// Force to have [context]
class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration(BuildContext context,
      {Widget? icon,
      bool? isDense,
      bool enabled = true,
      String? hintText,
      TextStyle? hintStyle,
      Widget? label,
      String? labelText,
      TextStyle? labelStyle,
      Widget? prefixIcon,
      TextStyle? prefixStyle,
      Widget? suffix,
      Widget? suffixIcon,
      String? suffixText,
      TextStyle? suffixStyle,
      Color? fillColor,
      bool filled = false,
      InputBorder? focusedBorder,
      InputBorder? border,
      bool isHealthForm = false,
      //https://github.com/flutter/flutter/issues/19488
      bool alwaysShowSuffix = false,
      EdgeInsetsGeometry? contentPadding,
      FloatingLabelBehavior? floatingLabelBehavior})
      : super(
          enabled: enabled,
          contentPadding: contentPadding ??
              Theme.of(context).inputDecorationTheme.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
          isDense: isDense ?? Theme.of(context).inputDecorationTheme.isDense,

          // label
          label: isHealthForm ? null : label,
          labelStyle:
              labelStyle ?? Theme.of(context).inputDecorationTheme.labelStyle,
          floatingLabelBehavior: isHealthForm
              ? FloatingLabelBehavior.never
              : floatingLabelBehavior ?? FloatingLabelBehavior.always,

          // prefix
          prefixIcon: prefixIcon,
          prefixStyle:
              prefixStyle ?? Theme.of(context).inputDecorationTheme.prefixStyle,

          // hint
          hintText: isHealthForm ? S.of(context).input : hintText,
          hintStyle: hintStyle ??
              Theme.of(context).inputDecorationTheme.hintStyle ??
              Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: isHealthForm ? 10.0 : null,
                  color: Theme.of(context).disabledColor),
          hintMaxLines: 1,

          // suffix
          suffix: alwaysShowSuffix ? null : suffix,
          suffixIcon: suffixIcon ??
              (alwaysShowSuffix
                  ? Padding(padding: EdgeInsets.all(15), child: suffix)
                  : null),
          suffixText: suffixText,
          suffixStyle:
              suffixStyle ?? Theme.of(context).inputDecorationTheme.suffixStyle,

          // boarders
          disabledBorder: isHealthForm
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: _borderSideWidth))
              : border ??
                  Theme.of(context).inputDecorationTheme.disabledBorder ??
                  OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor)),
          border: isHealthForm
              ? _defaultHealthBoard
              : border ??
                  Theme.of(context).inputDecorationTheme.border ??
                  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26)),
          focusedErrorBorder:
              Theme.of(context).inputDecorationTheme.focusedErrorBorder ??
                  OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
          errorBorder: border ??
              Theme.of(context).inputDecorationTheme.errorBorder ??
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
          focusedBorder: focusedBorder ??
              Theme.of(context).inputDecorationTheme.focusedBorder ??
              OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
          enabledBorder: isHealthForm
              ? _defaultHealthBoard
              : border ??
                  Theme.of(context).inputDecorationTheme.enabledBorder ??
                  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26)),
          fillColor: fillColor ??
              Theme.of(context).inputDecorationTheme.fillColor ??
              Colors.yellow,
          filled: filled,
        );
}

InputBorder get _defaultHealthBoard =>
    UnderlineInputBorder(borderSide: BorderSide(width: _borderSideWidth));

const double _borderSideWidth = 0.2;
