import 'package:flutter/material.dart';

class LoadingGif extends StatelessWidget {
  final double? size;
  final Color? color;
  const LoadingGif({Key? key, this.size, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      AssetImage(
        'assets/images/loading.gif',
        package: 'artech_ui_kit',
      ),
      size: size ?? 1.8,
      color: color,
    );
  }
}
