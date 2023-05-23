import 'package:artech_core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class BackgroundLocation with HasNamedLogger {
  BackgroundLocation();

  Future<Null> saveLocation(Position position) async {
    // TODO: implementation
  }

  @mustCallSuper
  void dispose() {}

  @override
  String get loggerName => 'BackgroundLocation';
}
