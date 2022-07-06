import 'package:flutter/material.dart';

class TileIcon extends StatelessWidget {
  const TileIcon({
    Key? key,
    required this.colorTween,
    required this.animation,
    this.iconSize,
    required this.selected,
    required this.icon,
    this.selectedIconTheme,
    this.unselectedIconTheme,
  }) : super(key: key);

  final ColorTween colorTween;
  final Animation<double> animation;
  final double? iconSize;
  final bool selected;
  final Widget icon;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = colorTween.evaluate(animation);
    final IconThemeData defaultIconTheme = IconThemeData(
      color: iconColor,
      size: iconSize,
    );
    final IconThemeData iconThemeData = IconThemeData.lerp(
      defaultIconTheme.merge(unselectedIconTheme),
      defaultIconTheme.merge(selectedIconTheme),
      animation.value,
    );

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: Container(
        child: IconTheme(
          data: iconThemeData,
          child: icon,
        ),
      ),
    );
  }
}
