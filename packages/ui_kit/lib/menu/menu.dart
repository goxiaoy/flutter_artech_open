import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MenuGroup extends ChangeNotifier
    implements ValueListenable<Iterable<MenuGroupItem>> {
  MenuGroup({this.name, Iterable<MenuGroupItem> value = const []}) {
    // ignore: prefer_foreach
    for (final v in value) {
      _m.add(v);
    }
    notifyListeners();
  }
  final String? name;

  final HeapPriorityQueue<MenuGroupItem> _m =
      HeapPriorityQueue((a, b) => b.priority.compareTo(a.priority));

  MenuGroupItem? findOrNull(String name) {
    return _m
        .toUnorderedList()
        .firstWhereOrNull((element) => element.name == name);
  }

  MenuGroup addIfNotExits(MenuGroupItem m) {
    final l = findOrNull(m.name);
    if (l == null) {
      _m.add(m);
      notifyListeners();
    }
    return this;
  }

  MenuGroup addOrReplaceMenu(MenuGroupItem m) {
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
      {List<MenuGroupItem> adds = const [],
      List<String> removeNames = const []}) {
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

  MenuGroup replaceWith(List<MenuGroupItem> m) {
    _m.clear();
    _m.addAll(m);
    notifyListeners();
    return this;
  }

  @override
  Iterable<MenuGroupItem> get value => _m.toList();
}

class MenuGroupItem {
  MenuGroupItem(this.name,
      {this.priority = 0,
      this.widget,
      this.widget2,
      String Function(BuildContext context)? label}) {
    this.label = label ?? (_) => name;
  }
  final String name;
  final Map<String, dynamic> extra = <String, dynamic>{};

  late final String Function(BuildContext context) label;

  final WidgetBuilder? widget;
  final WidgetBuilder? widget2;

  final int priority;
}
