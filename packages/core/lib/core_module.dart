import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/errors/exception_handler.dart';
import 'package:artech_core/errors/exception_processor.dart';
import 'package:artech_core/id/uid_generator.dart';
import 'package:artech_core/locale/localization_option.dart';
import 'package:artech_core/security/persistent_security_storage.dart';
import 'package:artech_core/settings/memory_setting_store.dart';
import 'package:artech_core/settings/setting_store.dart';
import 'package:artech_core/time/time.dart';
import 'package:artech_core/token/token_storage.dart';
import 'package:artech_core/ui/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

import 'configuration/app_config.dart';
import 'id/generator.dart';
import 'logging/logger_mixin.dart';
import 'multi_localization_delegate.dart';
import 'services_extension.dart';
import 'token/token_manager.dart';

class CoreModule extends AppSubModuleBase {
  @override
  List<AppModuleMixin> get dependentOn => [TimeModule()];

  @override
  void configureServices() {
    configTyped<LocalizationOption>(
        creator: () => LocalizationOption()
          ..support.addAll([
            SettingLocale(
                locale: const Locale('en'),
                textBuilder: (_) => 'English'), // English
            SettingLocale(locale: const Locale('zh'), textBuilder: (_) => '中文'),
          ])
          ..delegates.addAll([
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            MultiAppLocalizationsDelegate.delegate
          ]));
    configTyped<ExceptionProcessor>(
        creator: () =>
            ExceptionProcessor()..addHandler(LogStackTraceExceptionHandler()));

    ifNotRegistered<SettingStore>((services) {
      services.registerSingleton<SettingStore>(MemorySettingStore());
    });
    services.registerSingleton<IdGenerator>(UIdGenerator());
    services.registerSingleton<PersistentSecurityStorage>(
        PersistentSecurityStorage());
    services.registerSingletonAsync<AppConfig>(() async {
      final res = AppConfig();
      await res.init();
      return res;
    });
    services.registerSingletonAsync<TokenStorage>(() async {
      final t = TokenStorage();
      await t.init();
      return t;
    });
    services.registerSingletonAsync<TokenManager>(() async {
      final t = TokenManager();
      return t;
    }, dependsOn: [TokenStorage]);
    services.registerLazySingleton(() => NavigationService());
  }

  @override
  Future<void> onApplicationInit() async {
    final appConfig = services.get<AppConfig>();
    final level = appConfig.getValue<String?>('logging.level');
    //init logging
    final configLevel = convertLogLevelFromString(level);
    if (configLevel != null) {
      Logger.root.level = configLevel;
    }
    await services.get<TokenManager>().start();
  }

  @override
  TransitionBuilder innerBuilder() {
    return (context, child) {
      return EasyLoading.init()(context, child);
    };
  }
}
