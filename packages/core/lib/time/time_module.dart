import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/core.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logging/logging.dart';
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
    //   await setCurrentZoneTdevice_calendarime();
    //   return TimeReady();
    // });
  }

  Future<void> _setCurrentZoneTime() async {
    try {
      tz.initializeTimeZones(); //
      final timezone = await _getCurrentTimeZone();
      if (timezone != null) {
        tz.setLocalLocation(tz.getLocation(timezone));
      }
    } catch (error) {
      _log.severe('configureLocalTimeZone error: $error');
    }
  }

  Future<String?> _getCurrentTimeZone() async {
    //try load from native
    try {
      //TODO GMT can not be used https://github.com/pinkfish/flutter_native_timezone/issues/15
      final String currentTimeZone = await executeWithStopwatch(
          () => FlutterTimezone.getLocalTimezone(),
          name: 'FlutterNativeTimezone.getLocalTimezone');
      _log.info('Native Time zone: $currentTimeZone');
      return currentTimeZone;
    } catch (e) {
      _log.severe('FlutterNativeTimezone error: $e');
    }
    return null;
  }
}

class TimeReady {}
