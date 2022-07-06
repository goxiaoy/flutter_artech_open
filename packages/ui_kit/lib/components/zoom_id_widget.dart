import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class ZoomIdWidget extends StatelessWidget {
  final String meetingId;
  const ZoomIdWidget({required this.meetingId}) : super();

  String _url() {
    if (isURL(meetingId)) {
      return meetingId;
    } else {
      return 'https://www.zoom.us/';
    }
  }

  String _parseId() {
    if (isURL(meetingId)) {
      final id = meetingId.split('j/').last.substring(0, 10);
      return id;
    } else {
      return meetingId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final launch = serviceLocator.get<LaunchService>();
        await launch.launch(_url());
      },
      dense: true,
      title: SelectableText(_parseId()),
      leading: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
          child: Icon(
            Icons.videocam,
            color: Colors.white,
          ),
        ),
      ),
      trailing: ForwardIcon(),
    );
  }
}
