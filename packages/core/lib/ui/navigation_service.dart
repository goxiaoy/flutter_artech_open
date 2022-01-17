import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushTo(MaterialPageRoute route) {
    return navigatorKey.currentState!.push(route);
  }

  Future showErrorDialog(String title, Object error,
      {StackTrace? stackTrace}) async {
    final BuildContext? context = navigatorKey.currentState?.context;
    if (context != null) {
      final processor = serviceLocator.get<ExceptionProcessor>();
      final e = processor.process(error, stackTrace);
      showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(title),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'))
                ],
              ));
    } else {
      return null;
    }
  }
}
