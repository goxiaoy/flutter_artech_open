import 'dart:ui';

import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/errors/exception_handler.dart';
import 'package:artech_core/errors/exception_processor.dart';
import 'package:artech_core/l10n/localization_option.dart';
import 'package:artech_core/security/persistent_security_storage.dart';
import 'package:artech_core/settings/memory_setting_store.dart';
import 'package:artech_core/settings/setting_store.dart';
import 'package:artech_core/time/time.dart';
import 'package:artech_core/ui/navigation_service.dart';
import 'package:artech_core/ui/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

import 'configuration/app_config.dart';
import 'services_extension.dart';
import 'token/token_manager.dart';
import 'token/token_storage.dart';

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
          ]));
    configTyped<ExceptionProcessor>(
        creator: () =>
            ExceptionProcessor()..addHandler(LogStackTraceExceptionHandler()));

    ifNotRegistered<SettingStore>((services) {
      services.registerSingleton<SettingStore>(MemorySettingStore());
    });

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

    configTyped<MenuOption>(
        creator: () => MenuOption().addGroup(MenuGroup(mainMenuName)));
  }

  @override
  Future<void> onApplicationInit() async {
    final appConfig = services.get<AppConfig>();
    final level = appConfig.getValue<String?>('logging.level');
    //init logging
    final configLevel = convertFromString(level);
    if (configLevel != null) {
      Logger.root.level = configLevel;
    }
    await services.get<TokenManager>().start();
  }

  Level? convertFromString(String? level, {Level? l}) {
    if (level == null) {
      return null;
    }
    var logLevel = l ?? Level.INFO;

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

  @override
  TransitionBuilder innerBuilder() {
    return (context, child) {
      return EasyLoading.init()(context, child);
    };
  }
}
