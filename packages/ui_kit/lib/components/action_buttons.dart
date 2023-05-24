import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ArtechRaisedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final bool? clicked;
  final double? loadingImageSize;
  final double? elevation;
  const ArtechRaisedButton(
      {required this.child,
      required this.onPressed,
      this.clicked = false,
      this.loadingImageSize,
      this.elevation,
      this.width,
      this.height})
      : super();

  @override
  Widget build(BuildContext context) {
    final List<Color> colors =
        serviceLocator.get<AppBarOptions>().buttonGradientColors ??
            [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ];

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: height ?? 40.0, maxWidth: width ?? 250.0),
      child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient:
                  onPressed != null ? LinearGradient(colors: colors) : null,
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: elevation ?? 4.0)
              ]
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              primary: Colors.transparent, //Color(0xFF522D80),
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (clicked == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: LoadingGif(
                      size: loadingImageSize ?? 20.0,
                      color: Colors.white,
                    ),
                  ),
                child,
              ],
            ),
            onPressed: () {
              if (onPressed != null) onPressed!();
            },
          )),
    );
  }
}

class ArtechOutLinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final bool? clicked;
  final double? loadingImageSize;
  final Color? color;
  const ArtechOutLinedButton(
      {required this.child,
      required this.onPressed,
      this.clicked = false,
      this.loadingImageSize,
      this.color,
      this.width,
      this.height})
      : super();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: height ?? 40.0, maxWidth: width ?? 200.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 1.0, color: color ?? Theme.of(context).primaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (clicked == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: LoadingGif(
                  size: loadingImageSize ?? 20.0,
                  color: Colors.white,
                ),
              ),
            if (clicked != true) child,
          ],
        ),
        onPressed: () {
          if (onPressed != null) onPressed!();
        },
      ),
    );
  }
}

class ArtechFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget label;
  final bool clicked;
  final double loadingImageSize = 20.0;
  final double? width;
  final double? height;
  final String? tooltip;
  final double? elevation;
  final Object? heroTag;

  const ArtechFloatingActionButton(
      {this.width,
      this.height,
      this.tooltip,
      this.elevation,
      this.heroTag,
      required this.onPressed,
      required this.label,
      this.clicked = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 250.0,
      height: height ?? 40.0,
      child: FloatingActionButton.extended(
          elevation: elevation ?? 8.0,
          tooltip: tooltip,
          disabledElevation: 0.0,
          //https://stackoverflow.com/a/59725528/15527691
          heroTag: heroTag ?? null,
          onPressed: clicked ? null : onPressed,
          label: Row(
            children: [
              clicked
                  ? LoadingGif(
                      size: loadingImageSize,
                      color: Colors.white,
                    )
                  : Container(),
              label,
            ],
          )),
    );
  }
}
