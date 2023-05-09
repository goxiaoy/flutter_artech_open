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
    try {
      await GlobalConfiguration()
          .loadFromAsset('appsettings')
          .then((p) => p.loadFromAsset(environmentJson));
    } catch (e) {
      print(e);
    }

    if (!kIsWeb && Platform.isAndroid) {
      //android simulator will be 10.0.2.2
      final items = GlobalConfiguration().appConfig.entries;
      for (final keyValue in items) {
        if (keyValue.value is String) {
          String stringValue = keyValue.value as String;
          stringValue = stringValue.replaceAll('localhost', '10.0.2.2');
          stringValue = stringValue.replaceAll('127.0.0.1', '10.0.2.2');
          GlobalConfiguration().updateValue(keyValue.key, stringValue);
        }
      }
    }
    _isLoaded = true;
  }

  T? getValue<T>(String key, {T? defaultValue}) {
    assert(_isLoaded);
    return GlobalConfiguration().getValue<T?>(key) ?? defaultValue;
  }
}
