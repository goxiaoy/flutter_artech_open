import 'package:artech_core/core.dart';
import 'package:workmanager/workmanager.dart';

final _logger = Logger('JobManager');

typedef BackgroundTaskHandler = Future<bool> Function(
    String taskName, Map<String, dynamic>? inputData);

BackgroundTaskHandler selector(
    String matchTaskName, final BackgroundTaskHandler backgroundTask) {
  return (taskName, inputData) {
    if (taskName == matchTaskName) {
      return backgroundTask(taskName, inputData);
    } else {
      return Future.value(true);
    }
  };
}

final _handlers = <BackgroundTaskHandler>[];

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final allResults =
          await Future.wait(_handlers.map((e) => e(task, inputData)));
      if (allResults.any((e) => !e)) {
        return Future.value(false);
      }
      return Future.value(true);
    } catch (err) {
      _logger.severe(
          err); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }
  });
}

// https://pub.dev/packages/workmanager
class JobModule extends AppSubModuleBase {
  @override
  Future<void> beforeApplicationInit() async {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerOneOffTask('test-task', 'simpleTask');
  }
}

extension JobAppMainModuleExtension on AppModuleMixin {
  void addTaskHandler(final BackgroundTaskHandler backgroundTask) {
    _handlers.add(backgroundTask);
  }
}
