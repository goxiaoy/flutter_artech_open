import 'package:flutter/material.dart';

// Largest device width
const _kDefaultWidth = 480.0;

// Used for constrain width with device
// Move child to center, constrain with mobile device with
class WidthConstrainContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double? minHeight;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;

  const WidthConstrainContainer(
      {Key? key,
      required this.child,
      this.maxWidth,
      this.minHeight,
      this.padding,
      this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final max = maxWidth ?? _kDefaultWidth;
    final minH = minHeight ?? 0.0;
    // final width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        padding: padding,
        decoration: decoration,
        constraints: BoxConstraints(
          maxWidth: max,
          minHeight: minH,
        ),
        child: Align(alignment: Alignment.topCenter, child: child),
      ),
    );
  }
}
