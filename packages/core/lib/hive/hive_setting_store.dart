import 'package:artech_core/settings/setting_store.dart';
import 'package:hive/hive.dart';

import 'hive_kv_store.dart';

class HiveSettingStore extends HiveKVStore implements SettingStore {
  HiveSettingStore(Future<Box<dynamic>> Function() box) : super(box);
  static const defaultBoxName = 'settings';
}
