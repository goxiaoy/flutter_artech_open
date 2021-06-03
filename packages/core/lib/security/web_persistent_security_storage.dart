import 'package:artech_core/security/persistent_security_storage.dart';
import 'package:artech_core/store/kv_store.dart';
import 'package:universal_html/html.dart' show window;

PersistentSecurityStorage getSecurityStorage() =>
    WebPersistentSecurityStorage();

const defaultPrefix = 's/';

class WebPersistentSecurityStorage implements PersistentSecurityStorage {
  WebPersistentSecurityStorage({this.prefix = defaultPrefix});
  final String prefix;

  final _storage = window.localStorage;

  String _normalizeKey(String key) {
    return prefix + key;
  }

  @override
  Future<void> clearAll() async {
    _storage.removeWhere((key, value) => key.startsWith(prefix));
  }

  @override
  Future delete(String key) async {
    _storage.remove(_normalizeKey(key));
  }

  @override
  Future<String?> get(String key, {String? defaultValue}) async {
    return _storage[_normalizeKey(key)];
  }

  @override
  Future<Map<String, String?>> getList({String? prefix}) async {
    var e = _storage.entries;
    if (prefix != null) {
      e = e.where((element) => element.key.startsWith(prefix));
    }
    return Map.fromEntries(e);
  }

  @override
  Future set(String key, String? value) async {
    assert(value != null);
    _storage[_normalizeKey(key)] = value ?? '';
  }

  @override
  Stream<KeyChangeEventTyped<String?>> watch({String? key}) {
    // TODO: implement watch
    throw UnimplementedError();
  }
}
