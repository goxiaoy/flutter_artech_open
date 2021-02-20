import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/core_module.dart';
import 'package:artech_core/settings/setting_store.dart';
import 'package:hive/hive.dart';

import 'hive.dart';
import 'hive_setting_store.dart';

class HiveModule extends AppSubModuleBase {
  @override
  List<AppModuleMixin> get dependentOn => [CoreModule()];

  @override
  void configureServices() {
    services.registerSingletonAsync<HiveReady>(() async {
      await services.initHiveSafely();
      return HiveReady();
    });

    services.registerSingletonAsync<SettingStore>(() async {
      final box = await Hive.openBox<dynamic>(HiveSettingStore.defaultBoxName);
      final hiveSettingStore = HiveSettingStore(box);
      await hiveSettingStore.init();
      return hiveSettingStore;
    }, dependsOn: [HiveReady]);
  }
}

class HiveReady {}
