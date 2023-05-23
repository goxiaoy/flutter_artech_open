import 'package:artech_core/core.dart';
import 'package:artech_core/generated/l10n.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushTo(MaterialPageRoute<dynamic> route) {
    return navigatorKey.currentState!.push(route);
  }

  Future<void> showErrorDialog(String title, Object error,
      {StackTrace? stackTrace, BuildContext? context}) async {
    final newCtx = context ?? navigatorKey.currentState?.context;
    if (newCtx != null) {
      final processor = serviceLocator.get<ExceptionProcessor>();
      final e = processor.process(error, stackTrace);

      String text = '';
      String code = '';
      if (e is UserFriendlyException) {
        text = e.getMessage(newCtx);
        code = e.getCode(newCtx);
      } else {
        text = e.toString();
      }

      showDialog<String>(
          context: newCtx,
          builder: (_) => AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      code,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(text),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(newCtx).pop();
                      },
                      child: Text(S.of(newCtx).close))
                ],
              ));
    } else {
      return;
    }
  }
}
