library core;

import 'package:artech_core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

export 'package:artech_core/app_bootstrap.dart';
export 'package:artech_core/app_module_base.dart';
export 'package:artech_core/configuration/app_config.dart';
export 'package:artech_core/core_module.dart';
export 'package:artech_core/data/data.dart';
export 'package:artech_core/errors/errors.dart';
export 'package:artech_core/hooks/hooks.dart';
export 'package:artech_core/locale/localization_option.dart';
export 'package:artech_core/logging/logger_mixin.dart';
export 'package:artech_core/security/persistent_security_storage.dart';
export 'package:artech_core/service_getter_mixin.dart';
export 'package:artech_core/service_getter_mixin.dart';
export 'package:artech_core/settings/setting_store.dart';
export 'package:artech_core/store/kv_store.dart';
export 'package:artech_core/time/date_time_extension.dart';
export 'package:artech_core/ui/menu/menu.dart';
export 'package:artech_core/ui/navigation_service.dart';
export 'package:artech_core/ui/ui.dart';
export 'package:artech_core/utils/utils.dart';
export 'package:flutter_native_timezone/flutter_native_timezone.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:logging/logging.dart';
export 'package:multiple_localization/multiple_localization.dart';
export 'package:rxdart/rxdart.dart';
export 'package:timezone/timezone.dart';
export 'package:universal_platform/universal_platform.dart';
export 'package:uuid/uuid.dart';

export 'event/event_emitter.dart';
export 'services_extension.dart';
export 'token/token_manager.dart';
export 'token/token_model.dart';

final serviceLocator = GetIt.I;

final emitter = EventEmitter();

/// Utility function
/// [title] title
/// [error]
/// [stackTrace] force to have stackTrace
void showErrorDialog(String title, Object error,
    {StackTrace? stackTrace, BuildContext? context}) {
  serviceLocator
      .get<NavigationService>()
      .showErrorDialog(title, error, stackTrace: stackTrace, context: context);
}
