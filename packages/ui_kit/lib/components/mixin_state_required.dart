import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_core/core.dart';

const double _healthFormFieldHeight = 40.0; //kMinInteractiveDimension;

abstract class HealthFormFieldWidget extends StatefulWidget {
  final bool isRequired;
  final bool enabled;
  final bool isHealthForm;
  final TextStyle? textStyle;
  const HealthFormFieldWidget({
    Key? key,
    this.isRequired = false,
    this.isHealthForm = false,
    this.enabled = true,
    required this.textStyle,
  }) : super(key: key);
}

abstract class HealthFormFieldHookWidget extends StatefulHookWidget
    implements HealthFormFieldWidget {
  final bool isRequired;
  final bool enabled;
  final bool isHealthForm;
  final TextStyle? textStyle;
  const HealthFormFieldHookWidget({
    Key? key,
    this.isRequired = false,
    this.isHealthForm = false,
    this.enabled = true,
    required this.textStyle,
  }) : super(key: key);
}

mixin MixinStateRequired<T extends HealthFormFieldWidget> on State<T>
    implements HasNamedLogger {
  late FocusNode focusNode;

  bool _hasFocus = false;

  @protected
  Widget buildField(BuildContext context);

  @protected
  bool get enabled => widget.enabled;
  @protected
  bool get isHealthForm => widget.isHealthForm;
  @protected
  bool get filled => widget.isHealthForm && widget.enabled && widget.isRequired;
  @protected
  bool get isRequired => widget.isRequired;
  @protected
  String get labelText;
  InputBorder? get border => filled ? const UnderlineInputBorder() : null;
  @protected
  bool get isEmpty;
  @protected
  void clear();
  @protected
  TextStyle get style => (widget.textStyle ?? TextStyle())
      .copyWith(color: enabled ? null : Theme.of(context).disabledColor);

  void _listener() {
    _hasFocus = focusNode.hasFocus;
    logger.fine("$labelText Has focus: ${focusNode.hasFocus}");
    if (mounted) {
      setState(() {});
    }
  }

  @protected
  Widget suffixIcon(List<Widget> suffixIcon) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...suffixIcon.toList(),
            if (!isEmpty && enabled && _hasFocus)
              // Always fist
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: clear,
                  tooltip: S.of(context).clear,
                  icon: Icon(Icons.clear)),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(_listener);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Logger get logger => Logger(loggerName);

  @override
  void dispose() {
    focusNode.removeListener(_listener);
    focusNode.dispose();
    super.dispose();
  }

  @protected
  Widget label(BuildContext context) {
    TextStyle style = widget.textStyle ??
        Theme.of(context).textTheme.bodyText2 ??
        TextStyle();
    style = style.copyWith(overflow: TextOverflow.ellipsis);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isEmpty && widget.isRequired && widget.enabled)
          Text(
            ' * ',
            style: style.copyWith(color: Colors.red),
          ),
        Text(widget.isHealthForm ? '$labelText:' : labelText,
            maxLines: 1, style: style),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isHealthForm
        ? Row(
            children: [
              label(context),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: _healthFormFieldHeight,
                  ),
                  child: buildField(context),
                ),
              ),
            ],
          )
        : buildField(context);
  }
}
