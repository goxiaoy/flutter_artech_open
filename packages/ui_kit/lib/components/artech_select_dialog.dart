import 'package:artech_ui_kit/components/components.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

class ArtechSelectDialog<T> extends StatefulWidget {
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsets? insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final String title;
  final T? initialValue;
  final List<T> items;
  const ArtechSelectDialog(
      {Key? key,
      required this.items,
      required this.title,
      this.initialValue,
      this.backgroundColor,
      this.elevation,
      this.insetPadding,
      this.shape,
      this.clipBehavior = Clip.none,
      this.alignment})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArtechSelectDialogState<T>();
  }
}

class _ArtechSelectDialogState<T> extends State<ArtechSelectDialog<T>> {
  T? _value;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final DialogTheme dialogTheme = DialogTheme.of(context);

    Widget dialogChild = IntrinsicWidth(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment(0.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.title,
                          style: dialogTheme.titleTextStyle,
                        ),
                      )),
                  Align(
                    alignment: Alignment(1.0, -1.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop<T>(null);
                        },
                        child: Icon(
                          Icons.close,
                          size: 20.0,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: 40.0,
                child: DropdownButtonFormField<T>(
                    style: dialogTheme.titleTextStyle,
                    decoration: CustomInputDecoration(context),
                    value: _value,
                    items: [
                      ...widget.items
                          .map((e) => DropdownMenuItem<T>(
                                value: e,
                                child: Text(e.toString()),
                              ))
                          .toList()
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
              child: ArtechRaisedButton(
                  width: 200.0,
                  height: 28.0,
                  child: Text(S.of(context).confirm),
                  onPressed: () {
                    if (_value != widget.initialValue)
                      Navigator.of(context).pop<T>(_value);
                    else
                      Navigator.of(context).pop<T>(null);
                  }),
            )
          ],
        ),
      ),
    );

    return Dialog(
      backgroundColor: widget.backgroundColor,
      elevation: widget.elevation,
      insetPadding: widget.insetPadding,
      clipBehavior: widget.clipBehavior,
      shape: widget.shape,
      alignment: widget.alignment,
      child: dialogChild,
    );
  }
}
