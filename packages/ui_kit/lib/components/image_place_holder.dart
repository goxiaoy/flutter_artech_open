
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';

class ImagePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56.0),
      color: Colors.black12,
      child: Center(child: LoadingGif(),),
    );
  }
}