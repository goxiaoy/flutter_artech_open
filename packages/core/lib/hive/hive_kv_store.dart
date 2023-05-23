import 'package:artech_core/hive/hive.dart';
import 'package:artech_core/service_getter_mixin.dart';
import 'package:artech_core/store/kv_store.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final Logger _logger = Logger('HiveKVStore');

class HiveKVStore extends KVStore with ServiceGetter {
  HiveKVStore(this.boxCreator);

  Box<dynamic>? _box;

  Box<dynamic> get box {
    if (_box == null) {
      throw Exception('HiveKVStore not initialized');
    }
    return _box!;
  }

  final Future<Box<dynamic>> Function() boxCreator;

  Future<void> init() async {
    await services.initHiveSafely();
    _box = await boxCreator();
    _logger.info('Created box ${_box?.name}');
  }

  Future<void> unInit() async {
    await box.close();
    _logger.info('Closed box ${_box?.name}');
  }

  @override
  Future<T?> get<T>(String key, {T? defaultValue}) async {
    return await box.get(key, defaultValue: defaultValue) as T?;
  }

  @override
  Future<void> set<T>(String key, T? value) async {
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
  Stream<KeyChangeEvent> watch({String? key, bool immediate = true}) {
    var stream = box.watch(key: key).map((event) =>
        KeyChangeEvent(event.key as String, event.value, event.deleted));
    if (key != null && immediate) {
      stream = Stream.fromFuture(get<dynamic>(key))
          .map((event) => KeyChangeEvent(key, event, false))
          .concatWith([stream]);
    }
    return stream;
  }

  @override
  Future<void> clearAll() async {
    await box.clear();
  }

  @override
  Future<void> delete(String key) async {
    await box.delete(key);
  }
}
