import 'dart:math';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/pages/refreshable_page.dart';
import 'package:artech_ui_kit/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../menu/menu.dart';

Locale useSettingLocale() {
  final opt = serviceLocator.get<LocalizationOption>();
  final ss = serviceLocator.get<SettingStore>();

  final current = useWatchSettingKey<String>(ss, LocalizationOption.settingKey);

  final locale = current == null
      ? opt.support.first.locale
      : opt.support
          .firstWhere((element) => element.locale.languageCode == current,
              orElse: () => opt.support.first)
          .locale;
  return locale;
}

void useLockOrientation() {
  useEffect(() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return () {
      SystemChrome.setPreferredOrientations([
        ...DeviceOrientation.values,
      ]);
    };
  });
}

void useRefreshablePage(RefreshFunc refreshFunc) {
  final context = useContext();
  final page = RefreshablePage.of(context);
  useEffect(() {
    if (page != null) {
      return page.addListener(refreshFunc);
    }
    return () {};
  }, [page]);
}

final String _tagSelectedKey = 'app.home.selected';

class MainMenuState {
  final List<MenuGroupItem>? menus;

  final WidgetRef ref;

  MainMenuState({this.menus, required this.ref});

  int get currentIndex {
    final _homeSelected = ref.read(homeSelectedProvider);
    var index = _homeSelected == null
        ? 0
        : menus!.indexWhere((element) => element.name == _homeSelected);
    index = min(max(index, 0), menus!.length - 1);
    return index;
  }

  void setSelected(int newIndex) {
    var selectedMenu = menus![newIndex];
    final newName = selectedMenu.name;
    final _homeSelected = ref.read(homeSelectedProvider.notifier);
    if (_homeSelected.state != newName) {
      serviceLocator.get<SettingStore>().set(_tagSelectedKey, newName);
      _homeSelected.update((state) => newName);
      //_homeSelected.state = newName;
    }
  }

  set showDrawer(bool show) {
    final _showDrawer = ref.read(showDrawerProvider.notifier);
    if (show != _showDrawer.state) {
      Future.microtask(() => _showDrawer.state = show);
    }
  }

  bool get showDrawer => ref.read(showDrawerProvider);
}

MainMenuState useMainMenuState(WidgetRef ref) {
  ref.watch(showDrawerProvider);
  ref.watch(homeSelectedProvider);

  //load from setting store
  final AsyncSnapshot<Null> _ = useMemoizedFuture(() async {
    final v =
        await serviceLocator.get<SettingStore>().get<String>(_tagSelectedKey);
    final homeSelected = ref.read(homeSelectedProvider.notifier);
    homeSelected.state = homeSelected.state ?? v;
  });
  final mainmenu = ref.watch(mainMenuProvider);
  final menus = mainmenu.value.toList();
  return MainMenuState(ref: ref, menus: menus);
}

