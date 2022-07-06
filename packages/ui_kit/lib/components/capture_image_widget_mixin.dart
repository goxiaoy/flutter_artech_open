import 'dart:typed_data';

import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

mixin CaptureImageWidgetMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey _key = GlobalKey();

  Widget buildRender({Widget? child}) {
    return RepaintBoundary(
      key: _key,
      child: child,
    );
  }

  Future<Uint8List> capture() {
    return capturePng(_key);
  }
}
