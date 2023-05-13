import 'package:artech_ui_kit/menu/menu.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef MenuModifier = Function(MenuGroup menu);

class MenuModifierWidget extends HookConsumerWidget {
  final List<MenuModifier> modifer;
  final ChangeNotifierProvider<MenuGroup> provider;
  final Widget child;

  MenuModifierWidget({
    required this.provider,
    this.modifer = const [],
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(() {
      Future.microtask(() {
        final v = ref.read(provider.notifier);
        modifer.forEach((element) {
          element(v);
        });
      });
    });
    return child;
  }
}
