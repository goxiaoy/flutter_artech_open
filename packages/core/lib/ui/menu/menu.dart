import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const mainMenuName = 'main';

class MenuOption {
  final Map<String, MenuGroup> _map = {};

  MenuOption addGroup(MenuGroup group) {
    if (_map.containsKey(group.name)) {
      throw Exception('${group.name} already exists');
    }
    _map[group.name] = group;
    return this;
  }

  MenuOption addOrReplaceGroup(MenuGroup group) {
    _map[group.name] = group;
    return this;
  }

  MenuGroup getOrThrow(String name) {
    final res = _map[name];
    if (res == null) {
      throw Exception('$name not exists');
    }
    return res;
  }
}

class MenuGroup extends ChangeNotifier
    implements ValueListenable<Iterable<MenuItem>> {
  MenuGroup(this.name, {Iterable<MenuItem> value = const []}) {
    // ignore: prefer_foreach
    for (final v in value) {
      _m.add(v);
    }
    notifyListeners();
  }
  final String name;

  final HeapPriorityQueue<MenuItem> _m =
      HeapPriorityQueue((a, b) => b.priority.compareTo(a.priority));

  MenuItem? findOrNull(String name) {
    return _m
        .toUnorderedList()
        .firstWhereOrNull((element) => element.name == name);
  }

  MenuGroup addIfNotExits(MenuItem m) {
    final l = findOrNull(m.name);
    if (l == null) {
      _m.add(m);
      notifyListeners();
    }
    return this;
  }

  MenuGroup addOrReplaceMenu(MenuItem m) {
    final l = findOrNull(m.name);
    if (l != null) {
      _m.remove(l);
    }
    _m.add(m);
    notifyListeners();
    return this;
  }

  MenuGroup removeMenu(String name) {
    _removeMenuWithoutNotify(name);
    notifyListeners();
    return this;
  }

  void _removeMenuWithoutNotify(String name) {
    final l = findOrNull(name);
    if (l != null) {
      _m.remove(l);
    }
  }

  MenuGroup batch(
      {List<MenuItem> adds = const [], List<String> removeNames = const []}) {
    // ignore: prefer_foreach
    for (final value in removeNames) {
      _removeMenuWithoutNotify(value);
    }
    // ignore: prefer_foreach
    for (final add in adds) {
      _m.add(add);
    }
    notifyListeners();
    return this;
  }

  MenuGroup replaceWith(List<MenuItem> m) {
    _m.clear();
    _m.addAll(m);
    notifyListeners();
    return this;
  }

  @override
  Iterable<MenuItem> get value => _m.toList();
}

class MenuItem {
  MenuItem(this.name,
      {this.priority = 0,
      this.widget,
      this.widget2,
      String Function()? label}) {
    this.label = label ?? () => name;
  }
  final String name;
  final Map<String, dynamic> extra = <String, dynamic>{};

  late final String Function() label;

  final WidgetBuilder? widget;
  final WidgetBuilder? widget2;

  final int priority;
}
