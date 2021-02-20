import 'package:artech_core/settings/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  SettingStore get settingStore => GetIt.I.get<SettingStore>();
}
