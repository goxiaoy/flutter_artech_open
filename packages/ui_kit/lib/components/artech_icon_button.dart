import 'package:flutter/material.dart';

// Force to have tooltip
class ArtechIconButton extends IconButton {
  const ArtechIconButton(
      {Key? key,
      required VoidCallback? onPressed,
      required Widget icon,
      required String tooltip,
      double? iconSize,
      BoxConstraints? constraints,
      EdgeInsetsGeometry? padding})
      : super(
            key: key,
            onPressed: onPressed,
            icon: icon,
            iconSize: iconSize ?? 24.0,
            tooltip: tooltip,
            padding: padding ?? const EdgeInsets.all(8.0),
            constraints: constraints);
}
