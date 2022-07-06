import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

///use RepaintBoundary to capture widget to png  https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html
Future<Uint8List> capturePng(GlobalKey globalKey) async {
  RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  if (boundary.debugNeedsPaint) {
    //if debugNeedsPaint return to function again.. and loop again until boundary have paint.
    //https://stackoverflow.com/questions/57645037/unable-to-take-screenshot-in-flutter
    return Future.delayed(Duration(milliseconds: 100))
        .then((value) => capturePng(globalKey));
  }
  ui.Image image = await boundary.toImage();
  ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
      as FutureOr<ByteData>);
  Uint8List pngBytes = byteData.buffer.asUint8List();
  return pngBytes;
}
