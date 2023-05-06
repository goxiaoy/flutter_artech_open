import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';

import 'ui_kit.dart';

class UIKitRoute {
  static String settingPageRoute = '/settings';

  static String settingLanguagePageRoute = '/settings/language';

  static String devTestPageRoute = '/dev/testPage';
}

/// Build param then call FluroRouter navigateTo
Future navigateTo(
  BuildContext context,
  String path, {
  Map<String, dynamic>? params,
  bool replace = false,
  bool clearStack = false,
  bool maintainState = true,
  bool rootNavigator = false,
  Duration? transitionDuration,
  RouteSettings? routeSettings,
  RouteTransitionsBuilder? transitionBuilder,
  TransitionType transition = TransitionType.native,
  bool? opaque,
}) async {
  if (router.match(path) == null) {
    // Don't want to get asserts
    showErrorDialog('Route Error', 'Route $path not provided');
    return null;
  }

  String query = "";
  if (params != null) {
    int index = 0;
    for (var key in params.keys) {
      var value = Uri.encodeComponent(params[key]);
      if (index == 0) {
        query = "?";
      } else {
        query = query + "\&";
      }
      query += "$key=$value";
      index++;
    }
  }
  path = path + query;
  try {
    return await router.navigateTo(context, path,
        transition: transition,
        replace: replace,
        clearStack: clearStack,
        maintainState: maintainState,
        rootNavigator: rootNavigator,
        routeSettings: routeSettings,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        opaque: opaque);
  } catch (error) {
    rethrow;
  }
}
