import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:artech_core/core.dart';

/// Loading is configurable
/// * [color] color, default is using primaryColor
/// * [size] size
class Loading extends StatelessWidget {
  final Color? color;
  final double? size;
  final double strokeWidth;
  const Loading(
      {Key? key, this.color, this.size = 28.0, this.strokeWidth = 2.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final config = serviceLocator.get<ApplicationConfig>();
    if (config.loading != null)
      return SizedBox(
        height: size,
        width: size,
        child: IconTheme(
            data: IconThemeData(color: color ?? Theme.of(context).primaryColor),
            child: config.loading!(context)),
      );
    else {
      return CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      );
    }
  }
}
