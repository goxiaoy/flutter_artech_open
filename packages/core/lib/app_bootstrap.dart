import 'dart:collection';

import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class AppBootstrap {
  AppBootstrap(this.mainModule) {
    _init();
  }

  final AppMainModuleBase mainModule;
  final _logger = Logger('AppBootstrap');

  final List<AppModuleMixin> listOfAllModules = [];
  final HashSet<Type> setOfAllModules = HashSet();

  void _init() {
    //init base on main module
    //DFS
    _visitNode([], mainModule);
  }

  void _visitNode(List<Type> parentList, AppModuleMixin node) {
    dfs<AppModuleMixin, Type>(node, (n) => n.runtimeType, (n) => n.dependentOn,
        (node, parents) {
      if (parents.any((element) => element.runtimeType == node.runtimeType)) {
        throw Exception("Circular dependency detected in ${[
          ...parentList.map((e) => e.runtimeType),
          node.runtimeType
        ].join("=>")}");
      }
      listOfAllModules.add(node);
      setOfAllModules.add(node.runtimeType);
      _logger.info('[${node.runtimeType}]');
    });
  }

  Future<void> load() async {
    await executeWithStopwatch(() async => await executeBeforeApplicationInit(),
        name: 'executeBeforeApplicationInit');
    // await executeBeforeApplicationInit();
    await executeWithStopwatch(() async => await configureAllServices(),
        name: 'configureAllServices');
    await executeWithStopwatch(() async => await executeApplicationInit(),
        name: 'executeApplicationInit');
    // await executeApplicationInit();
  }

  Future<void> configureAllServices() async {
    GetIt.I.allowReassignment = true;
    for (final element in listOfAllModules) {
      await executeWithStopwatch(() => element.preConfigureServices(),
          name: '${element.runtimeType} preConfigureServices');
      //element.preConfigureServices();
    }
    for (final element in listOfAllModules) {
      await executeWithStopwatch(() => element.configureServices(),
          name: '${element.runtimeType} configureServices');
      //element.configureServices();
    }
    for (final element in listOfAllModules) {
      await executeWithStopwatch(() => element.postConfigureServices(),
          name: '${element.runtimeType} postConfigureServices');
      //element.postConfigureServices();
    }
  }

  Future<void> executeBeforeApplicationInit() async {
    for (final m in listOfAllModules) {
      await executeWithStopwatch(() => m.beforeApplicationInit(),
          name: '${m.runtimeType} beforeApplicationInit');
    }
  }

  Future<void> executeApplicationInit() async {
    await executeWithStopwatch(() => GetIt.I.allReady(),
        name: 'Injector Ready');
    for (final m in listOfAllModules) {
      await executeWithStopwatch(() => m.onApplicationInit(),
          name: '${m.runtimeType} onApplicationInit');
    }
  }

  Future<void> executeApplicationQuit() async {
    for (final m in listOfAllModules.reversed) {
      await executeWithStopwatch(() => m.onApplicationQuit(),
          name: '${m.runtimeType} onApplicationQuit');
    }
  }
}

@immutable
class ModuleApp extends StatelessWidget {
  const ModuleApp({Key? key, required this.bootstrap}) : super(key: key);

  final AppBootstrap bootstrap;
  List<AppModuleMixin> get listOfAllModules => bootstrap.listOfAllModules;

  @override
  Widget build(BuildContext context) {
    if (listOfAllModules.isEmpty) {
      return Container(
        child: const Text('No modules'),
      );
    } else {
      return _buildWidget(0);
    }
  }

  Widget _buildWidget(int index) {
    if (index == listOfAllModules.length - 1) {
      return (listOfAllModules[index] as AppMainModuleBase)
          .bootstrap((context, child) {
        return _buildInnerWidget(index, context, child);
      });
    } else {
      return (listOfAllModules[index] as AppSubModuleBase)
          .build(_buildWidget(index + 1));
    }
  }

  Widget _buildInnerWidget(int index, BuildContext context, Widget? child) {
    if (index == 0) {
      //build
      return listOfAllModules[index].innerBuilder()(context, child);
    } else {
      return listOfAllModules[index].innerBuilder()(
          context, _buildInnerWidget(index - 1, context, child));
    }
  }
}
