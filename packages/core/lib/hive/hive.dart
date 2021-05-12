import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

export 'hive_kv_store.dart';
export 'hive_module.dart';
export 'hive_setting_store.dart';

bool _hasHiveInit = false;

final _logger = Logger('Hive');

extension SafeInitHive on GetIt {
  Future<void> initHiveSafely() async {
    if (!_hasHiveInit) {
      //init hive
      _logger.info('Init hive');
      await Hive.initFlutter();
      _hasHiveInit = true;
    }
  }
}
