import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';

//should use const for tree shaking
const kIsDebug = !kReleaseMode;

class AppConfig {
  bool _isLoaded = false;
  Future<void> init() async {
    String environmentJson = '';
    if (kIsDebug) {
      environmentJson = 'appsettings.development';
    } else {
      environmentJson = 'appsettings.production';
    }
    await GlobalConfiguration()
        .loadFromAsset('appsettings')
        .then((p) => p.loadFromAsset(environmentJson));

    if (!kIsWeb && Platform.isAndroid) {
      //android simulator will be 10.0.2.2
      for (final keyValue in GlobalConfiguration().appConfig.entries) {
        if (keyValue.value is String) {
          final String stringValue = keyValue.value as String;
          GlobalConfiguration().updateValue(
              keyValue.key, stringValue.replaceAll('localhost', '10.0.2.2'));
          GlobalConfiguration().updateValue(
              keyValue.key, stringValue.replaceAll('127.0.0.1', '10.0.2.2'));
        }
      }
    }
    _isLoaded = true;
  }

  T? getValue<T>(String key, {T? defaultValue}) {
    assert(_isLoaded);
    return GlobalConfiguration().getValue<T>(key) ?? defaultValue;
  }
}
