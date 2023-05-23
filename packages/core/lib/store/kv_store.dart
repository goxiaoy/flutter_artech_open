import 'package:flutter/cupertino.dart';

abstract class KVStore {
  Stream<KeyChangeEvent> watch({String? key, bool immediate = true});

  Future<T?> get<T>(String key, {T? defaultValue});

  Future<void> set<T>(String key, T? value);

  Future<void> delete(String key);

  Future<Map<String, dynamic>> getList({String? prefix});

  Future<void> clearAll();
}

abstract class KVStoreTyped<T> {
  Stream<KeyChangeEventTyped<T>> watch({String? key});

  Future<T> get(String key, {T? defaultValue});

  Future<void> set(String key, T? value);

  Future<void> delete(String key);

  Future<Map<String, T>> getList({String? prefix});

  Future<void> clearAll();
}

class KeyChangeEvent extends KeyChangeEventTyped<dynamic> {
  const KeyChangeEvent(String key, dynamic value, bool isDelete)
      : super(key, value, isDelete);
}

@immutable
class KeyChangeEventTyped<T> {
  const KeyChangeEventTyped(this.key, this.value, this.isDelete);
  final String key;
  final T value;
  final bool isDelete;

  @override
  bool operator ==(dynamic other) {
    if (other is KeyChangeEventTyped<T>) {
      return other.key == key && other.value == value;
    }
    return false;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode ^ isDelete.hashCode;
}
