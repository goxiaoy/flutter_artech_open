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
    if (node.dependentOn.isNotEmpty) {
      parentList.add(node.runtimeType);
      for (final element in node.dependentOn) {
        if (parentList.contains(element.runtimeType)) {
          throw Exception(
              "Circular dependency detected in ${parentList.join("=>")}");
        }
        if (!setOfAllModules.contains(element.runtimeType)) {
          _visitNode(parentList, element);
        }
      }
      parentList.remove(node.runtimeType);
    }
    listOfAllModules.add(node);
    setOfAllModules.add(node.runtimeType);
    _logger.info('[${node.runtimeType}]');
  }

  Future<void> load() async {
    await executeBeforeApplicationInit();
    configureAllServices();
    await executeApplicationInit();
  }

  void configureAllServices() {
    GetIt.I.allowReassignment = true;
    for (final element in listOfAllModules) {
      element.preConfigureServices();
    }
    for (final element in listOfAllModules) {
      element.configureServices();
    }
    for (final element in listOfAllModules) {
      element.postConfigureServices();
    }
  }

  Future<void> executeBeforeApplicationInit() async {
    for (final m in listOfAllModules) {
      await executeWithStopwatch(() => m.beforeApplicationInit(),
          overAction: (t) {
        _logger.warning(
            '${m.runtimeType} beforeApplicationInit cost $t milliseconds');
      });
    }
  }

  Future<void> executeApplicationInit() async {
    await executeWithStopwatch(() => GetIt.I.allReady(), overAction: (t) {
      _logger.warning('Injector cost $t milliseconds');
    });
    for (final m in listOfAllModules) {
      await executeWithStopwatch(() => m.onApplicationInit(), overAction: (t) {
        _logger.warning(
          '${m.runtimeType} onApplicationInit cost $t milliseconds',
        );
      });
    }
  }

  Future<void> executeApplicationQuit() async {
    for (final m in listOfAllModules.reversed) {
      await executeWithStopwatch(() => m.onApplicationQuit(), overAction: (t) {
        _logger.warning(
            '"${m.runtimeType} onApplicationQuit cost $t milliseconds');
      });
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
      return (listOfAllModules[index] as AppMainModuleBase).bootstrap;
    } else {
      return (listOfAllModules[index] as AppSubModuleBase)
          .build(_buildWidget(index + 1));
    }
  }
}
