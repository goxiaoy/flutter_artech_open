import 'dart:async';

import 'package:artech_core/security/persistent_security_storage.dart';
import 'package:artech_core/store/kv_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

PersistentSecurityStorage getSecurityStorage() =>
    AppPersistentSecurityStorage();

class AppPersistentSecurityStorage implements PersistentSecurityStorage {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> clearAll() {
    return _storage.deleteAll();
  }

  @override
  Future<void> delete(String key) async {
    return _storage.delete(key: key);
  }

  @override
  Future<String?> get(String key, {String? defaultValue}) {
    return _storage.read(key: key);
  }

  @override
  Future<Map<String, String?>> getList({String? prefix}) {
    return _storage.readAll();
  }

  @override
  Future<void> set(String key, String? value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Stream<KeyChangeEventTyped<String?>> watch({String? key}) {
    throw UnimplementedError();
  }
}
