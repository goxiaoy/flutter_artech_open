import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'kv_store.dart';

class MemoryKVStore extends KVStore {
  final Map<String, dynamic> _store = <String, dynamic>{};
  final StreamController<KeyChangeEvent> _controller = StreamController();

  @override
  Future clearAll() async {
    final keys = _store.keys.toList(growable: false);
    for (final k in keys) {
      await delete(k);
    }
  }

  @override
  Future delete(String key) async {
    _store.remove(key);
    _controller.add(KeyChangeEvent(key, null, true));
  }

  @override
  Future<T?> get<T>(String key, {T? defaultValue}) async {
    final dynamic v = _store[key];
    return v == null ? defaultValue : v as T?;
  }

  @override
  Future<Map<String, dynamic>> getList({String? prefix}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future set<T>(String key, T? value) async {
    _store[key] = value;
    _controller.add(KeyChangeEvent(key, value, false));
  }

  @override
  Stream<KeyChangeEvent> watch({String? key, bool immediate = true}) {
    var stream = _controller.stream;
    if (key != null) {
      stream = stream.where((event) => event.key == key);
      if (immediate) {
        stream = Stream.fromFuture(get(key))
            .map((event) => KeyChangeEvent(key, event, false))
            .concatWith([stream]);
      }
    }
    return stream;
  }
}
