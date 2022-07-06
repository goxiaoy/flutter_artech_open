import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

const _kHeight = 40.0;

/// Validate value
class TextEditor<T> extends StatefulWidget {
  final T? initialValue;
  final String? hintText;
  final EditType type;
  const TextEditor({required this.type, this.initialValue, this.hintText})
      : super();

  @override
  State<StatefulWidget> createState() {
    return _TextEditorState<T>();
  }
}

class _TextEditorState<T> extends State<TextEditor> with HasNamedLogger {
  final _formKey = GlobalKey<FormState>(debugLabel: '_TextEditorState');
  PhoneNumber? _phoneNumber;
  PhoneNumber? _initialPhoneNumber;
  late bool _phoneValid;
  Gender? _gender;
  DateTime? _dateTime;
  TextEditingController? _controller;
  String? _error;

  bool get _changed {
    // switch(widget.type) {
    //   case EditType.sex:
    //     return widget.initialValue != _gender;
    //   case EditType.birthday:
    //     return widget.initialValue != _dateTime;
    //   case EditType.phone:
    //     return _phoneNumber != _initialphoneNumber;
    //   default:
    //     return widget.initialValue != _controller.text;
    // }
    return true;
  }

  void _onSubmit() async {
    var value;
    switch (widget.type) {
      case EditType.phone:
        value = await PhoneNumber.getParsableNumber(_phoneNumber!);
        break;
      case EditType.sex:
        value = _gender;
        break;
      case EditType.email:
        value = _controller!.text;
        final bool isValid = EmailValidator.validate(_controller!.text);
        if (!isValid) {
          setState(() {
            _error = S.of(context).invalidEmail;
          });
          return;
        }
        break;
      case EditType.year:
        value = _dateTime;
        break;
      default:
        value = _controller!.text;
    }
    logger.info('Value:$value');
    Navigator.of(context).pop<T>(value);
  }

  bool get _isTextEdit =>
      widget.type == EditType.text || widget.type == EditType.email;

  Widget _actionButton(BuildContext context) {
    return ArtechRaisedButton(
        //width: MediaQuery.of(context).size.width * 0.6,
        child: Text(S.of(context).ok),
        onPressed: _changed
            ? () {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                _onSubmit();
              }
            : null);
  }

  TextInputType _keyboardType() {
    switch (widget.type) {
      case EditType.text:
        return TextInputType.text;
      case EditType.email:
        return TextInputType.emailAddress;
      case EditType.phone:
        return TextInputType.phone;
      default:
        throw UnimplementedError();
    }
  }

  void _showYearPicker({DateTime? firstDate}) {
    Future.delayed(Duration.zero).then((_) async {
      final date = await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime(1900),
        initialDate: _dateTime!,
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        locale: Localizations.localeOf(context),
      );
      setState(() {
        _dateTime = date;
        _controller!.text =
            _dateTime != null ? _dateTime!.toLocalFormatYearText() : null ?? '';
      });
    });
  }

  Widget _widget() {
    if (_isTextEdit) {
      return Column(
        children: [
          TextField(
            onSubmitted: (value) {
              _onSubmit();
            },
            autofocus: true,
            keyboardType: _keyboardType(),
            controller: _controller,
            decoration:
                CustomInputDecoration(context, hintText: widget.hintText),
          ),
          _error != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(_error!, style: TextStyle(color: Colors.red)),
                )
              : Container(),
          SizedBox(
            height: _kHeight,
          ),
          _actionButton(context),
        ],
      );
    } else if (widget.type == EditType.phone) {
      if (_initialPhoneNumber != null)
        return InternationalPhoneNumberInput(
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            //useEmoji: true
          ),
          validator: (_) {},
          autoFocus: true,
          // autoFocusSearch:true,
          countries: ['US', 'CN'],
          //textFieldController:_controller,
          autoValidateMode: AutovalidateMode.always,
          onInputValidated: (value) {
            logger.info('onInputValidated:$value');
            _phoneValid = value;
          },
          locale: Localizations.localeOf(context).languageCode,
          initialValue: _initialPhoneNumber,
          inputDecoration: CustomInputDecoration(context,
              hintText: S.of(context).phoneNumber),
          onInputChanged: (value) {
            logger.info('onInputChanged $value');
            setState(() {
              _phoneNumber = value;
            });
          },
          onSubmit: () {
            logger.info('onSubmit $_phoneNumber $_phoneValid');
            if (_phoneValid) {
              Navigator.of(context).pop<String>(_phoneNumber?.toString());
            }
          },
          onSaved: (value) {
            logger.info('onSubmit');
            throw UnimplementedError();
          },
        );
      else {
        return Container();
      }
    } else if (widget.type == EditType.sex) {
      return Column(
        children: [
          DropdownButtonFormField<Gender>(
            decoration:
                CustomInputDecoration(context, hintText: widget.hintText),
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
            value: _gender,
            autofocus: true,
            items: [
              ...Gender.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toLocaleText(context)),
                      ))
                  .toList()
            ],
          ),
          SizedBox(
            height: _kHeight,
          ),
          _actionButton(context),
        ],
      );
    } else if (widget.type == EditType.year) {
      return Column(
        children: [
          TextFormField(
            controller: _controller,
            onTap: () {
              _showYearPicker();
            },
            autofocus: true,
            readOnly: true,
            decoration:
                CustomInputDecoration(context, hintText: widget.hintText),
          ),
          SizedBox(
            height: _kHeight,
          ),
          _actionButton(context),
        ],
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneValid = false;
    if (widget.type == EditType.phone) {
      if (widget.initialValue == null)
        _initialPhoneNumber = PhoneNumber(isoCode: 'US');
      else {
        PhoneNumber.getRegionInfoFromPhoneNumber(widget.initialValue, 'US')
            .then((value) {
          if (mounted)
            setState(() {
              _initialPhoneNumber = value;
            });
        }).catchError((error) {
          if (mounted)
            setState(() {
              _initialPhoneNumber = PhoneNumber(isoCode: 'US');
            });
        });
      }
    } else if (widget.type == EditType.sex) {
      _gender = widget.initialValue as Gender?;
    } else if (widget.type == EditType.year) {
      _dateTime = widget.initialValue as DateTime?;
      _controller = TextEditingController(
          text: _dateTime != null ? _dateTime!.toLocalFormatDayText() : null);
      _showYearPicker();
    } else {
      _controller = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      child: FormBuilder(key: _formKey, child: _widget()),
    );
  }

  @override
  String get loggerName => 'TextEditor';
}
