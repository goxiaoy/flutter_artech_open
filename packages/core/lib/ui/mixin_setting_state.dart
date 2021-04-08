import 'package:artech_core/core.dart';
import 'package:artech_core/settings/setting_store.dart';
import 'package:flutter/material.dart';

mixin MixinSettingState<T extends StatefulWidget> on State<T> {
  @protected
  Future<void> onSharedPreferenceInitialized() async {}

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    onSharedPreferenceInitialized().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  SettingStore get settingStore => serviceLocator.get<SettingStore>();
}
