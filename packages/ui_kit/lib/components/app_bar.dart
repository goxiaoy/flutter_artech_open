import 'package:flutter/material.dart';
import 'package:artech_core/core.dart';

class AppBarOptions {
  bool? centerTitle;
  // VRCA use white app bar
  bool whiteBar = false;
  // Button color, override defaults
  List<Color>? buttonGradientColors;
}

AppBar appBarBuilder(BuildContext context,
    {Widget? title,
    List<Widget>? actions,
    bool? centerTitle,
    Color? backgroundColor,
    Widget? leading,
    bool? closeButton,
    bool Function()? onExit,
    bool? canPop,
    double? elevation,
    Color? shadowColor,
    bool automaticallyImplyLeading = true}) {
  final options = serviceLocator.get<AppBarOptions>();
  final color = Colors.black87;

  final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
  final bool useCloseButton = closeButton ??
      parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

  final _canPop = canPop ?? Navigator.of(context).canPop();

  return AppBar(
    title: title,
    automaticallyImplyLeading: automaticallyImplyLeading,
    centerTitle: options.centerTitle,
    shadowColor: shadowColor,
    leading: leading != null
        ? leading
        : _canPop
            ? useCloseButton
                ? CloseButton(
                    onPressed: onExit,
                  )
                : IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      if (onExit == null)
                        Navigator.pop(context);
                      else if (onExit()) Navigator.pop(context);
                    })
            : Container(),
    actions: actions,
    elevation: elevation!=null? elevation:options.whiteBar ? 0.0 : null,
    backgroundColor: options.whiteBar
        ? Theme.of(context).canvasColor
        : options.whiteBar
            ? backgroundColor
            : null,
    foregroundColor: options.whiteBar ? color : null,
    iconTheme: options.whiteBar
        ? Theme.of(context).iconTheme.copyWith(color: color)
        : null,
    actionsIconTheme: options.whiteBar
        ? Theme.of(context).iconTheme.copyWith(color: color)
        : null,
  );
}
