import 'package:artech_core/app_module_base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RivderpodModule extends AppSubModuleBase {
  @override
  Widget build(Widget child) {
    return ProviderScope(child: child);
  }
}
