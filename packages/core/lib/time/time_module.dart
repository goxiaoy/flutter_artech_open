import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:logging/logging.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late Future loadTimeFuture;

class TimeModule extends AppSubModuleBase {
  final Logger _log = Logger('TimeModule');

  @override
  Future<void> onApplicationInit() async {
    await loadTimeFuture;
  }

  @override
  void configureServices() {
    loadTimeFuture = setCurrentZoneTime();
    // services.registerSingletonAsync(()async{
    //   await setCurrentZoneTime();
    //   return TimeReady();
    // });
  }

  Future<void> setCurrentZoneTime() async {
    try {
      tz.initializeTimeZones(); //

      if (!kIsWeb) {
        //TODO GMT can not be used https://github.com/pinkfish/flutter_native_timezone/issues/15
        final String currentTimeZone = await executeWithStopwatch(
            () => FlutterNativeTimezone.getLocalTimezone(),
            name: 'FlutterNativeTimezone.getLocalTimezone');
        _log.info('Time zone: $currentTimeZone');
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
      } else {
        await _loadFromTimeMachine();
      }
    } catch (error) {
      _log.severe('configureLocalTimeZone error: $error');
      await _loadFromTimeMachine();
    }
  }

  Future<void> _loadFromTimeMachine() async {
    try {
      await executeWithStopwatch(() async {
        await TimeMachine.initialize(
            <String, dynamic>{'rootBundle': rootBundle});
      }, name: 'Dart Time Machine Init');
      _log.info('Hello, ${DateTimeZone.local} from the Dart Time Machine!\n');
      tz.setLocalLocation(tz.getLocation(DateTimeZone.local.toString()));
    } catch (error) {
      _log.severe('loadFromTimeMachine error: $error');
    }
  }
}

class TimeReady {}
