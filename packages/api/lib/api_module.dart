import 'package:artech_api/api.dart';
import 'package:artech_api/http/timezone_interceptor.dart';
import 'package:artech_core/core.dart';
import 'package:artech_core/hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'exception_handlers.dart';
import 'health/health.dart';
import 'multi_localization_delegate.dart';

const String defaultClientName = 'defaultApiClient';

class ApiModule extends AppSubModuleBase with HasNamedLogger {
  @override
  List<AppModuleMixin> get dependentOn => [HiveModule()];

  @override
  void configureServices() {
    configTyped<LocalizationOption>(configurator: (p) {
      p.delegates.add(MultiAppLocalizationsDelegate.delegate);
    });

    configTyped<ExceptionProcessor>(configurator: (p) {
      p.addHandler(SocketExceptionHandler());
      p.addHandler(HandshakeExceptionHandler());
    });
    configTyped<DioOptions>(
        creator: () => DioOptions()
          ..interceptors.addAll([AuthInterceptor(), TimeZoneInterceptor()]));

    services.registerSingletonAsync<Store>(() async {
      return await HiveStore.open();
    }, dependsOn: [HiveReady]);

    configTyped<HealthCheckOption>(creator: () => HealthCheckOption());
    services.pushNewScope(scopeName: defaultClientName);
    // services.registerSingleton<HealthCheckEndpoint>(
    //     ClientSelfHealthCheckEndpoint());
  }

  @override
  Widget build(Widget child) {
    return HealthProvider(child: child);
  }

  @override
  String get loggerName => 'ApiModule';
}
