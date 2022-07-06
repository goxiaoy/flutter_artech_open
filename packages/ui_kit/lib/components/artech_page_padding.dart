import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

/// Page horizontal padding base on layout
class ArtechHorizontalPadding extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double horizontal;
  const ArtechHorizontalPadding(
      {Key? key,
      required this.child,
      required this.padding,
      this.horizontal = 40})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => Padding(
        child: child,
        padding: padding,
      ),
      watch: (_) => Padding(
        child: child,
        padding:
            padding.add(EdgeInsets.only(left: horizontal, right: horizontal)),
      ),
      desktop: (_) => Padding(
        child: child,
        padding:
            padding.add(EdgeInsets.only(left: horizontal, right: horizontal)),
      ),
      tablet: (_) => Padding(
        child: child,
        padding:
            padding.add(EdgeInsets.only(left: horizontal, right: horizontal)),
      ),
    );
  }
}
