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
      {StackTrace? stackTrace,BuildContext? c}) async {
    final BuildContext? context = c ?? navigatorKey.currentState?.context;
    if (context != null) {
      final processor = serviceLocator.get<ExceptionProcessor>();
      final e = processor.process(error, stackTrace);

      String? codeTitle = title;
      String text = '';
      if (e is UserFriendlyException) {
        text = e.getMessage(context);
        if (codeTitle == null) {
          final t = e.getCode(context);
          if (t.isNotEmpty) {
            codeTitle = t;
          }
        }
      } else {
        text = e.toString();
      }

      showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(codeTitle ?? ''),
                content: Text(text),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(S.of(context).close))
                ],
              ));
    } else {
      return null;
    }
  }
}
