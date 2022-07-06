import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';

enum EditType {
  text,
  email,
  phone,
  sex,
  year,
}

class EditPage<T> extends StatefulWidget {
  final T? initialValue;
  final EditType type;
  final String? hintText;
  const EditPage(
      {Key? key, required this.type, this.initialValue, this.hintText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditPageState<T>();
  }
}

class _EditPageState<T> extends State<EditPage> with HasNamedLogger {
  T? _value;

  Widget _body() {
    if (widget.type == EditType.sex)
      return TextEditor<Gender>(
        initialValue: _value as Gender?,
        type: widget.type,
      );
    else if (widget.type == EditType.year) {
      return TextEditor<DateTime>(
        initialValue: _value as DateTime?,
        type: widget.type,
      );
    } else
      return TextEditor<String>(
        initialValue: _value as String?,
        type: widget.type,
      );
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,
        resizeToAvoidBottomInset: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
          tooltip: S.of(context).cancel,
          onPressed: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.hintText ?? S.of(context).edit),
        body: SingleChildScrollView(child: _body()));
  }

  @override
  String get loggerName => '_EditPageState<T>';
}
