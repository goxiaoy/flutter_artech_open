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
  Widget bootstrap(TransitionBuilder innerBuilder);
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

  TransitionBuilder innerBuilder() {
    return (context, child) {
      assert(child != null);
      return child!;
    };
  }
}
