import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter_share/flutter_share.dart';

class ShareFile extends StatelessWidget {
  final String filePath;
  final Widget? child;
  final String title;
  final String? text;
  const ShareFile(
      {Key? key,
      required this.filePath,
      required this.title,
      this.text,
      this.child})
      : super(key: key);

  // TODO: file type is maters
  Future<bool?> _shareFile() async {
    await FlutterShare.shareFile(
        title: title, text: text, filePath: filePath, fileType: '*/pdf');
  }

  @override
  Widget build(BuildContext context) {
    if (child != null)
      return InkWell(
        onTap: _shareFile,
        child: child,
      );
    else
      return IconButton(
          tooltip: S.of(context).shareFile,
          onPressed: _shareFile,
          icon: Icon(Icons.share));
  }
}
