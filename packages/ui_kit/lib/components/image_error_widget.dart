import 'package:flutter/material.dart';
import 'package:artech_ui_kit/generated/l10n.dart';

class ImageErrorHolder extends StatelessWidget {
  final dynamic error;
  const ImageErrorHolder({this.error}):super();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56.0),
      color: Colors.black12,
      child: Center(
        child: Text(
          S.of(context).imageError,
          style: TextStyle(color: Colors.yellow.shade700),
        ),
      ),
    );
  }
}
