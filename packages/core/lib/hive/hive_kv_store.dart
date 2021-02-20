import 'package:artech_core/hive/hive.dart';
import 'package:artech_core/service_getter_mixin.dart';
import 'package:artech_core/store/kv_store.dart';
import 'package:hive/hive.dart';

class HiveKVStore extends KVStore with ServiceGetter {
  HiveKVStore(this.box);
  final Box box;
  Future init() async {
    await services.initHiveSafely();
  }

  Future unInit() async {
    await box.close();
  }

  @override
  Future<T?> get<T>(String key, {T? defaultValue}) async {
    return await box.get(key, defaultValue: defaultValue) as T?;
  }

  @override
  Future set<T>(String key, T? value) async {
    await box.put(key, value);
  }

  @override
  Future<Map<String, dynamic>> getList({String? prefix}) async {
    final m = box.toMap().entries;
    return Map<String, dynamic>.fromEntries((prefix != null
            ? m.where((element) => (element.key as String).startsWith(prefix))
            : m)
        .map((e) => MapEntry<String, dynamic>(e.key as String, e.value)));
  }

  @override
  Stream<KeyChangeEvent> watch({String? key}) {
    return box.watch(key: key).map((event) =>
        KeyChangeEvent(event.key as String, event.value, event.deleted));
  }

  @override
  Future clearAll() async {
    await box.clear();
  }

  @override
  Future delete(String key) async {
    await box.delete(key);
  }
}
