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
    loadTimeFuture = _setCurrentZoneTime();
    // services.registerSingletonAsync(()async{
    //   await setCurrentZoneTime();
    //   return TimeReady();
    // });
  }

  Future<void> _setCurrentZoneTime() async {
    try {
      tz.initializeTimeZones(); //
      tz.setLocalLocation(tz.getLocation(await _getCurrentTimeZone()));
    } catch (error) {
      _log.severe('configureLocalTimeZone error: $error');
    }
  }

  Future<String> _getCurrentTimeZone() async {
    final loadFromTimeMachine = () async {
      await executeWithStopwatch(() async {
        await TimeMachine.initialize(
            <String, dynamic>{'rootBundle': rootBundle});
      }, name: 'Dart Time Machine Init');
      _log.info('Hello, ${DateTimeZone.local} from the Dart Time Machine!\n');
      return DateTimeZone.local.toString();
    };
    if (!kIsWeb) {
      //try load from native
      try {
        //TODO GMT can not be used https://github.com/pinkfish/flutter_native_timezone/issues/15
        final String currentTimeZone = await executeWithStopwatch(
            () => FlutterNativeTimezone.getLocalTimezone(),
            name: 'FlutterNativeTimezone.getLocalTimezone');
        _log.info('Native Time zone: $currentTimeZone');
        return currentTimeZone;
      } catch (e) {
        _log.severe('loadFromTimeMachine error: $e');
      }
    }
    return await loadFromTimeMachine();
  }
}

class TimeReady {}
