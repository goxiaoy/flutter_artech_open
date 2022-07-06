import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'components.dart';

const String _kTimeFormat = 'HH:mm';

enum PickMode {
  time,
  day,
  dateTime,
}

class DataPicks {
  static Future<DateTime?> showDateTimePicker(BuildContext context,
      {PickMode mode = PickMode.time,
      String? title,
      int? maximumYear,
      DateTime? initialDateTime,
      DateTime? maxDate,
      DateTime? minimumDate,
      int minuteInterval = 1,
      bool showAction = true,
      ValueChanged<DateTime>? onValueChange}) async {
    return await showArtechModalBottomSheet<DateTime>(
        context: context,
        builder: (context) {
          return _DateTimePicker(
            maxDate: maxDate,
            title: title,
            mode: mode,
            maximumYear: maximumYear,
            minimumDate: minimumDate,
            initialDateTime: initialDateTime,
            minuteInterval: minuteInterval,
            showAction: showAction,
            onValueChange: onValueChange,
          );
        });
  }

  static Widget timeFormField(
    BuildContext context, {
    required TextEditingController controller,
    required String initialDateTime,
    required String title,
    required ValueChanged<DateTime> onChanged,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool enabled = true,
    String? placeHolder,
  }) {
    return new TextFormField(
      readOnly: true,
      onTap: () async {
        final DateTime? time = await showDateTimePicker(context,
            mode: PickMode.time,
            title: title,
            initialDateTime: DateFormat(_kTimeFormat).parse(initialDateTime));
        if (time != null) {
          controller.text = DateFormat(_kTimeFormat).format(time);
          onChanged(time);
        }
      },
      decoration: CustomInputDecoration(
        context,
        hintText: placeHolder,
      ),
      enabled: enabled,
      focusNode: focusNode,
      controller: controller,
      validator: validator,
    );
  }

  static Future<int> showNumberPicker(BuildContext context,
      {required String title,
      required int initValue,
      required int minValue,
      required int maxValue,
      required int step}) async {
    ArgumentError.checkNotNull(context);
    throw UnimplementedError();
    //TODO https://github.com/MarcinusX/NumberPicker/issues/106
    // return await showDialog<int>(
    //     context: context,
    //     builder: (context) {
    //       return NumberPickerDialog.integer(
    //         title: title != null
    //             ? Text(
    //                 title,
    //                 style: Theme.of(context).textTheme.headline6,
    //               )
    //             : null,
    //         initialIntegerValue: initValue ?? 0,
    //         minValue: minValue ?? 0,
    //         maxValue: maxValue ?? 1000,
    //         step: step ?? 1,
    //       );
    //     });
  }
}

class _DateTimePicker extends StatefulWidget {
  final PickMode mode;
  final String? title;
  final DateTime? initialDateTime;
  final int minuteInterval;
  final DateTime? maxDate;
  final bool showAction;
  final DateTime? minimumDate;
  final int? maximumYear;
  final ValueChanged<DateTime>? onValueChange;

  const _DateTimePicker(
      {this.mode = PickMode.time,
      this.maxDate,
      this.minimumDate,
      this.maximumYear,
      this.title,
      this.initialDateTime,
      required this.minuteInterval,
      this.showAction = true,
      this.onValueChange});

  @override
  State<StatefulWidget> createState() {
    return _DateTimePickerState();
  }
}

class _DateTimePickerState extends State<_DateTimePicker> {
  DateTime? _dateTime;

  CupertinoDatePickerMode _getMode() {
    switch (widget.mode) {
      case PickMode.dateTime:
        return CupertinoDatePickerMode.dateAndTime;
      case PickMode.day:
        return CupertinoDatePickerMode.date;
      case PickMode.time:
        return CupertinoDatePickerMode.time;
      default:
        throw UnimplementedError();
    }
  }

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: widget.title != null
                ? Text(
                    widget.title!,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.grey),
                  )
                : null,
          ),
          Expanded(
            child: CupertinoDatePicker(
              maximumYear: widget.maximumYear,
              maximumDate: widget.maxDate,
              minimumDate: widget.minimumDate,
              initialDateTime: _dateTime,
              mode: _getMode(),
              minuteInterval: widget.minuteInterval,
              onDateTimeChanged: (DateTime dateTime) {
                _dateTime = dateTime;
                widget.onValueChange?.call(dateTime);
              },
            ),
          ),
          if (widget.showAction)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CupertinoButton(
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop<DateTime>(null);
                    },
                  ),
                  VerticalDivider(
                    thickness: 2.0,
                  ),
                  CupertinoButton(
                    child: Text(S.of(context).ok,
                        style: TextStyle(fontSize: 20.0)),
                    onPressed: () {
                      Navigator.of(context).pop<DateTime>(_dateTime);
                    },
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _NumberPicker extends StatefulWidget {
  final int initValue;
  final int? minValue;
  final int? maxValue;
  final int? step;

  const _NumberPicker(
      {required this.initValue, this.maxValue, this.minValue, this.step});

  @override
  State<StatefulWidget> createState() {
    return _NumberPickerState();
  }
}

class _NumberPickerState extends State<_NumberPicker> {
  late int _currentIntValue;

  @override
  void initState() {
    super.initState();
    _currentIntValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new NumberPicker(
            value: _currentIntValue,
            minValue: widget.minValue ?? -100,
            maxValue: widget.maxValue ?? 100,
            step: widget.step ?? 1,
            onChanged: (value) => setState(() => _currentIntValue = value),
          ),
        ],
      ),
    );
  }
}

class NumberPad extends StatefulWidget {
  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  void _appendToOutput(String value) {
    if (value.contains('.') &&
        Provider.of<NumberPadProvider>(context, listen: false)
            .currentValue
            .contains('.')) {
      return;
    } else {
      Provider.of<NumberPadProvider>(context, listen: false)
          .appendedValue(value);
    }
  }

  Widget numericInputButton(String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
//This will append the value, also note that decimal value is not appended twice.
            _appendToOutput(value);
          },
          splashColor: Colors.blue,
          child: Container(
            height: 50,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100]!,
                  blurRadius: 3.0,
                )
              ],
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              // style: Theme.styles.h3
              //     .copyWith(fontSize: 19.0, color: Color(0xFF676767)),
            ),
          ),
        )
      ],
    );
  }

  Widget backButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
//Clicking on the back button removes erase the last number
            Provider.of<NumberPadProvider>(context, listen: false)
                .removeValue();
          },
          child: Container(
            height: 60,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100]!,
                  blurRadius: 3.0,
                )
              ],
            ),
            child: Icon(
              Icons.backspace,
              color: Color(0xFF676767),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 411.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey[900]!,
              offset: Offset(0.0, 3.0),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 35.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton('1'),
                      numericInputButton('2'),
                      numericInputButton('3'),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton('4'),
                      numericInputButton('5'),
                      numericInputButton('6'),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton('7'),
                      numericInputButton('8'),
                      numericInputButton('9'),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton('.'),
                      numericInputButton('0'),
                      backButton()
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 8.0, right: 8.0, top: 29.0),
            child: RoundedInkButton(
              child: Text("Done"),
              onTap: () {
                Navigator.of(context).pop(
                    Provider.of<NumberPadProvider>(context, listen: false)
                        .currentValue);
              },
            ),
          )
        ],
      ),
    );
  }
}

class RoundedInkButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const RoundedInkButton({required this.child, required this.onTap}) : super();
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ignore: prefer_mixin
class NumberPadProvider with ChangeNotifier {
  var _newValue = '';
  String get currentValue => _newValue;

  void appendedValue(String value) {
    _newValue = _newValue == '' ? value : _newValue + value;
    notifyListeners();
  }

  void removeValue() {
    if (_newValue != '') {
      _newValue = _newValue.substring(0, _newValue.length - 1);
    }
    notifyListeners();
  }

  // bool clearCurrentValue() {
  //   _newValue = '';
  //   notifyListeners();
  // }
}
