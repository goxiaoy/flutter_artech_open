import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/errors/exception_handler.dart';
import 'package:artech_core/errors/exception_processor.dart';
import 'package:artech_core/security/app_persistent_security_storage.dart';
import 'package:artech_core/security/persistent_security_storage.dart';
import 'package:artech_core/security/web_persistent_security_storage.dart';
import 'package:artech_core/settings/memory_setting_store.dart';
import 'package:artech_core/settings/setting_store.dart';
import 'package:artech_core/time/time.dart';
import 'package:artech_core/ui/ui.dart';
import 'package:logging/logging.dart';
import 'package:universal_platform/universal_platform.dart';

import 'configuration/app_config.dart';
import 'services_extension.dart';

class CoreModule extends AppSubModuleBase {
  @override
  List<AppModuleMixin> get dependentOn => [TimeModule()];

  @override
  void configureServices() {
    configTyped<ExceptionProcessor>(
        creator: () =>
            ExceptionProcessor()..addHandler(LogStackTraceExceptionHandler()));

    ifNotRegistered<SettingStore>((services) {
      services.registerSingleton<SettingStore>(MemorySettingStore());
    });

    services.registerLazySingleton<PersistentSecurityStorageBase>(() {
      if (!UniversalPlatform.isWeb) {
        return AppPersistentSecurityStorage();
      } else {
        return WebPersistentSecurityStorage();
      }
    });
    services.registerSingletonAsync(() async {
      final res = AppConfig();
      await res.init();
      return res;
    });

    configTyped<MenuOption>(
        creator: () => MenuOption().addGroup(MenuGroup(mainMenuName)));
  }

  @override
  Future<void> onApplicationInit() async {
    final appConfig = services.get<AppConfig>();
    final level = appConfig.getValue<String?>('logging.level');
    //init logging
    Logger.root.level = convertFromString(level);
  }

  Level convertFromString(String? level, {Level? l}) {
    var logLevel = l ?? Level.INFO;
    if (level == null) {
      return logLevel;
    }

    switch (level.toUpperCase()) {
      case 'ALL':
        logLevel = Level.ALL;
        break;
      case 'FINEST':
        logLevel = Level.FINEST;
        break;
      case 'FINER':
        logLevel = Level.FINER;
        break;
      case 'FINE':
        logLevel = Level.FINE;
        break;
      case 'CONFIG':
        logLevel = Level.CONFIG;
        break;
      case 'INFO':
        logLevel = Level.INFO;
        break;
      case 'WARNING':
        logLevel = Level.WARNING;
        break;
      case 'SEVERE':
        logLevel = Level.SEVERE;
        break;
      case 'SHOUT':
        logLevel = Level.SEVERE;
        break;
      case 'OFF':
        logLevel = Level.OFF;
        break;
      default:
        throw ArgumentError.value(level, 'Level should be one of ');
    }
    return logLevel;
  }
}
