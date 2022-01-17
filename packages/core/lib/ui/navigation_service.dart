import 'package:artech_core/core.dart';
import 'package:artech_core/generated/l10n.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushTo(MaterialPageRoute route) {
    return navigatorKey.currentState!.push(route);
  }

  Future showErrorDialog(String? title, Object error,
      {StackTrace? stackTrace, BuildContext? context}) async {
    BuildContext? newCtx = context ?? navigatorKey.currentState?.context;
    if (newCtx != null) {
      final processor = serviceLocator.get<ExceptionProcessor>();
      final e = processor.process(error, stackTrace);

      String? codeTitle = title;
      String text = '';
      if (e is UserFriendlyException) {
        text = e.getMessage(newCtx);
        if (codeTitle == null) {
          final t = e.getCode(newCtx);
          if (t.isNotEmpty) {
            codeTitle = t;
          }
        }
      } else {
        text = e.toString();
      }

      showDialog<String>(
          context: newCtx,
          builder: (_) => AlertDialog(
                title: Text(codeTitle ?? ''),
                content: Text(text),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(newCtx).pop();
                      },
                      child: Text(S.of(newCtx).close))
                ],
              ));
    } else {
      return null;
    }
  }
}
