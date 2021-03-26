import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';

import 'error_dialog.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushTo(MaterialPageRoute route) {
    return navigatorKey.currentState!.push(route);
  }

  void showErrorDialog(String title, Object error, {StackTrace? stackTrace}) {
    final BuildContext context = navigatorKey.currentState!.context;
    final processor = serviceLocator.get<ExceptionProcessor>();
    var e = processor.process(error, stackTrace);
    ErrorDialog.showErrorDialog(context, title, e);
  }

  static void showErrorDialogContext(
      BuildContext context, String title, Object error,
      {StackTrace? stackTrace}) {
    final processor = serviceLocator.get<ExceptionProcessor>();
    var e = processor.process(error, stackTrace);
    ErrorDialog.showErrorDialog(context, title, e);
  }
}
