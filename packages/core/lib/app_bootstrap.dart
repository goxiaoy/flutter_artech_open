import 'dart:collection';

import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class AppBootstrap {
  AppBootstrap(this.mainModule) {
    _init();
  }

  final AppMainModuleBase mainModule;
  final _logger = Logger('AppBootstrap');

  final List<AppModuleMixin> listOfAllModules = [];
  final HashSet<String> setOfAllModules = HashSet();

  void _init() {
    //init base on main module
    //DFS
    _visitNode([], mainModule);
  }

  void _visitNode(List<String> parentList, AppModuleMixin node) {
    if (node.dependentOn.isNotEmpty) {
      parentList.add(node.name);
      for (final element in node.dependentOn) {
        if (parentList.contains(element.name)) {
          throw Exception(
              "Circular dependency detected in ${parentList.join("=>")}");
        }
        if (!setOfAllModules.contains(element.name)) {
          _visitNode(parentList, element);
        }
      }
      parentList.remove(node.name);
    }
    listOfAllModules.add(node);
    setOfAllModules.add(node.name);
    _logger.info('[${node.name}]');
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
        _logger.warning('${m.name} beforeApplicationInit cost $t milliseconds');
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
          '${m.name} onApplicationInit cost $t milliseconds',
        );
      });
    }
  }

  Future<void> executeApplicationQuit() async {
    for (final m in listOfAllModules.reversed) {
      await executeWithStopwatch(() => m.onApplicationQuit(), overAction: (t) {
        _logger.warning('"${m.name} onApplicationQuit cost $t milliseconds');
      });
    }
  }
}
