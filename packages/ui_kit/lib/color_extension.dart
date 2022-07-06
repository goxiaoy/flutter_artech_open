import 'package:flutter/material.dart';

Color artechColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

String artechColorToHex(Color color) {
  return '#${color.value.toRadixString(16)}';
}
