import 'package:artech_ui_kit/menu/menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///home menu selected
final homeSelectedProvider = StateProvider<String?>((ref) => null);
final showDrawerProvider = StateProvider<bool>((ref) => false);

final mainMenuProvider =
    ChangeNotifierProvider<MenuGroup>((ref) => MenuGroup());

final settingMenuProvider =
    ChangeNotifierProvider<MenuGroup>((ref) => MenuGroup());
  
final testingMenuProvider =
    ChangeNotifierProvider<MenuGroup>((ref) => MenuGroup());