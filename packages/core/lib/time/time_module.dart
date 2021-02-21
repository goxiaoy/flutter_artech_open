import 'package:artech_core/app_module_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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
    loadTimeFuture = setCurrentZoneTime();
    // services.registerSingletonAsync(()async{
    //   await setCurrentZoneTime();
    //   return TimeReady();
    // });
  }

  Future<void> setCurrentZoneTime() async {
    try {
      tz.initializeTimeZones(); // There is no checking, call this anyway
      if (!kIsWeb) {
        //TODO GMT can not be used https://github.com/pinkfish/flutter_native_timezone/issues/15
        final String currentTimeZone =
            await FlutterNativeTimezone.getLocalTimezone();
        _log.info('Time zone: $currentTimeZone');
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
      }
    } catch (error) {
      _log.severe('configureLocalTimeZone error: $error');
    }
  }
}

class TimeReady {}
