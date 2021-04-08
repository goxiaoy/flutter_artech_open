import 'package:artech_core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

//App底层代码模块
abstract class AppSubModuleBase with AppModuleMixin {
  Widget build(Widget child) {
    return child;
  }
}

//App最上层
abstract class AppMainModuleBase with AppModuleMixin {
  late final Widget bootstrap;
}

mixin AppModuleMixin {
  //dependent on modules will be loaded before this module
  late final List<AppModuleMixin> dependentOn = [];

  GetIt get services => serviceLocator;

  void preConfigureServices() {}

  //Inject get_it services here
  void configureServices() {}

  void postConfigureServices() {}

  Future<void> beforeApplicationInit() async {}

  Future<void> onApplicationInit() async {}

  //dispose services here
  Future<void> onApplicationQuit() async {}

  // void onModuleEnter() {
  //   services.pushNewScope(scopeName: name, dispose: disposeScopeServices);
  //   configureScopeServices();
  // }

  //register get_it scope services here
  void configureScopeServices() {}
  void disposeScopeServices() {}

  // void onModuleExit() {
  //   services.popScopesTill(name);
  // }
}
