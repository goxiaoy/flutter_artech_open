import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late Future<void> loadTimeFuture;

class TimeModule extends AppSubModuleBase {
  final Logger _log = Logger('TimeModule');

  @override
  Future<void> onApplicationInit() async {
    await loadTimeFuture;
  }

  @override
  void configureServices() {
    loadTimeFuture = _setCurrentZoneTime();
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
