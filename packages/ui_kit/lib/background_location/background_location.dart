import 'package:artech_core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class BackgroundLocation {

  Logger _logger = Logger('BackgroundLocation');

  BackgroundLocation();

  Future<Null> saveLocation(Position position) async {
    // TODO: implementation
  }

  @mustCallSuper
  void dispose() {
  }

}
