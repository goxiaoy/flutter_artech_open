import 'package:artech_ui_kit/routes.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:artech_core/core.dart';

class AppBarOptions {
  bool? centerTitle;
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

  var _canPop = canPop ?? false;
  if (Navigator.of(context).canPop()) {
    _canPop = true;
  } else if (ModalRoute.of(context)?.settings.name?.isNotEmpty ?? false) {
    _canPop = true;
  }
  final popAction = () {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      navigateTo(context, homeRoute, replace: true);
    }
  };

  Navigator.of(context).canPop();
  final leadingWidget = leading != null
      ? leading
      : _canPop
          ? useCloseButton
              ? CloseButton(
                  onPressed: onExit,
                )
              : IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (onExit == null || onExit()) {
                      popAction();
                    }
                  })
          : null;
  return AppBar(
    title: title,
    automaticallyImplyLeading: automaticallyImplyLeading,
    centerTitle: options.centerTitle,
    shadowColor: shadowColor,
    leading: leadingWidget,
    actions: actions,
    elevation: elevation != null
        ? elevation
        : options.whiteBar
            ? 0.0
            : null,
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
