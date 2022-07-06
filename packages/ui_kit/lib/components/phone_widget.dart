import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// phoneCall = false, sending message
class PhoneWidget extends StatefulWidget {
  final String phoneNumber;
  final bool canMakeCall;
  final bool phoneCall;
  final bool dense;
  const PhoneWidget(
      {Key? key,
      required this.phoneNumber,
      this.phoneCall = true,
      this.dense = true,
      this.canMakeCall = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PhoneWidgetState();
  }
}

class _PhoneWidgetState extends State<PhoneWidget> with HasNamedLogger {
  PhoneNumber? _phoneNumber;
  PhoneNumberType? _type;

  Future<bool> _phoneCall() async {
    final result = await showCupertinoModalPopup(
        context: context,
        builder: (_) => ConfirmationCupertinoSheet(action: S.of(context).makePhoneCall));

    if (result != null) {
      final launch = serviceLocator.get<LaunchService>();
      // logger.info('Calling: ${_phoneNumber.phoneNumber}');
      if (UniversalPlatform.isWeb) return await launch.call(widget.phoneNumber);
      return await launch.call(_phoneNumber!.phoneNumber);
    }
    return false;
  }

  Future<bool> _textMessage() async {
    final result = await showCupertinoModalPopup(
        context: context,
        builder: (_) =>
            ConfirmationCupertinoSheet(action: S.of(context).sendTextMessage));

    if (result != null) {
      final launch = serviceLocator.get<LaunchService>();
      logger.info('Calling: ${_phoneNumber!.phoneNumber}');
      if (UniversalPlatform.isWeb) {
        return await launch.sendSms(widget.phoneNumber);
      } else
        return await launch.sendSms(_phoneNumber!.phoneNumber);
    }
    return false;
  }

  Future _init() async {
    try {
      _phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
          widget.phoneNumber, 'US');
      // TODO: type checking not working
      _type = await PhoneNumber.getPhoneNumberType(widget.phoneNumber, 'US');
      logger.info('Phone:$_phoneNumber Type:$_type');
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      logger.severe(error);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (!UniversalPlatform.isWeb) _init();
  }

  @override
  Widget build(BuildContext context) {
    var enableCall = widget.canMakeCall;
    if (!UniversalPlatform.isWeb)
      enableCall = widget.canMakeCall && _phoneNumber != null;

    return ListTile(
      dense: widget.dense,
      onTap: enableCall
          ? () async {
              if (widget.phoneCall)
                await _phoneCall();
              else
                await _textMessage();
            }
          : null,
      leading:
          widget.phoneCall ? Icon(Icons.phone) : Icon(Icons.message_outlined),
      title: SelectableText(widget.phoneNumber),
      trailing: enableCall ? ForwardIcon() : null,
    );
  }

  @override
  String get loggerName => '_PhoneWidgetState';
}
