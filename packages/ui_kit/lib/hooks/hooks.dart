import 'dart:math';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/pages/refreshable_page.dart';
import 'package:artech_ui_kit/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../menu/menu.dart';

Locale useSettingLocale() {
  var opt = serviceLocator.get<LocalizationOption>();
  var ss = serviceLocator.get<SettingStore>();
  //watch changes
  var entry =
      useMemoizedStream(() => ss.watch(key: LocalizationOption.settingKey));
  //load from store
  var load =
      useMemoizedFuture(() => ss.get<String>(LocalizationOption.settingKey));
  var current = (entry.data?.value as String?) ?? load.data;
  var locale = current == null
      ? opt.support.first.locale
      : opt.support
          .firstWhere((element) => element.locale.languageCode == current,
              orElse: () => opt.support.first)
          .locale;
  return locale;
}

class PaginationValue<T> {
  final ValueNotifier<int> start;
  final ValueNotifier<int> limit;
  final ValueNotifier<String?> sort;
  final ValueNotifier<bool> desc;
  final ValueNotifier<String?> search;
  final ValueNotifier<Iterable<T>?> data;
  final ValueNotifier<bool> cacheFlag;
  final ValueNotifier<bool> networkOnly;
  final ValueNotifier<bool> forceRefreshFlag;
  final ValueNotifier<bool> isRefresh;
  final ValueNotifier<bool> fetching;

  PaginationValue(
      {required this.start,
      required this.limit,
      required this.sort,
      required this.search,
      required this.desc,
      required this.data,
      required this.cacheFlag,
      required this.networkOnly,
      required this.forceRefreshFlag,
      required this.isRefresh,
      required this.fetching});

  void loadMore() {
    fetching.value = true;
    start.value = start.value + limit.value;
    cacheFlag.value = !cacheFlag.value;
    isRefresh.value = false;
  }

  void refresh() {
    // p.start.value = max(0, p.start.value - p.limit.value);
    //refresh set start value to 0
    fetching.value = true;
    start.value = 0;
    cacheFlag.value = !cacheFlag.value;
    isRefresh.value = true;
  }

  //clear previous data and refresh
  void forceRefresh() {
    forceRefreshFlag.value = true;
    //clear previous data
    data.value = null;
  }
}

PaginationValue<T> usePagination<T>(
    {int initStart = 0,
    int initLimit = 10,
    String? initSort,
    bool initDesc = true,
    String? initSearch,
    bool initNetworkOnly = false,
    bool initFetching = false}) {
  final start = useState(initStart);
  final limit = useState(initLimit);
  final sort = useState(initSort);
  final search = useState(initSearch);
  final desc = useState(initDesc);
  final dataList = useState<Iterable<T>?>(null);
  final cacheFlag = useState(true);
  final networkOnly = useState(initNetworkOnly);
  final forceRefreshFlag = useState(false);
  final isRefresh = useState(false);
  final fetching = useState(initFetching);
  return PaginationValue<T>(
      start: start,
      limit: limit,
      sort: sort,
      search: search,
      desc: desc,
      data: dataList,
      cacheFlag: cacheFlag,
      networkOnly: networkOnly,
      forceRefreshFlag: forceRefreshFlag,
      isRefresh: isRefresh,
      fetching: fetching);
}

void useRefreshablePage(BuildContext context, RefreshFunc refreshFunc) {
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
