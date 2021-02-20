import 'package:artech_core/core.dart';
import 'package:artech_core/hive/hive.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

import 'exception_handlers.dart';
import 'graphql/graphql.dart';

class ApiModule extends AppSubModuleBase with HasSelfLoggerTyped<ApiModule> {
  @override
  List<AppModuleMixin> get dependentOn => [HiveModule()];

  @override
  void configureServices() {
    configTyped<ExceptionProcessor>(configurator: (p) {
      p.addHandler(SocketExceptionHandler());
      p.addHandler(ServerExceptionHandler());
      p.addHandler(OperationExceptionHandler());
    });

    services.registerSingletonAsync(() async {
      await Hive.openBox<dynamic>(HiveStore.defaultBoxName);
      return ApiStoreReady();
    }, dependsOn: [HiveReady]);
  }
}

class ApiStoreReady {}
