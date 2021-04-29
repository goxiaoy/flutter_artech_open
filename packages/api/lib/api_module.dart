import 'package:artech_api/api.dart';
import 'package:artech_core/core.dart';
import 'package:artech_core/hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

import 'exception_handlers.dart';
import 'health/health.dart';
import 'ui/health_provider.dart';

const String defaultClientName = 'defaultApiClient';

class ApiModule extends AppSubModuleBase with HasNamedLogger {
  @override
  List<AppModuleMixin> get dependentOn => [HiveModule()];

  @override
  void configureServices() {
    configTyped<ExceptionProcessor>(configurator: (p) {
      p.addHandler(SocketExceptionHandler());
    });
    configTyped<DioOptions>(
        creator: () => DioOptions()..interceptors.add(AuthInterceptor()));
    services.registerSingletonAsync(() async {
      await Hive.openBox<dynamic>(HiveStore.defaultBoxName);
      return ApiStoreReady();
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

class ApiStoreReady {}
