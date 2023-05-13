library artech_ui_kit;

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'menu/menu.dart';

export 'package:app_settings/app_settings.dart';
export 'package:artech_ui_kit/data/address_data.dart';
export 'package:artech_ui_kit/data/position_data.dart';
export 'package:csc_picker/csc_picker.dart';
export 'package:cupertino_icons/cupertino_icons.dart';
export 'package:email_validator/email_validator.dart';
export 'package:fluro/fluro.dart';
export 'package:flutter_form_builder/flutter_form_builder.dart';
export 'package:flutter_settings_ui/flutter_settings_ui.dart';
export 'package:flutter_slidable/flutter_slidable.dart';
export 'package:flutter_spinbox/flutter_spinbox.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:form_builder_validators/form_builder_validators.dart';
export 'package:sprintf/sprintf.dart';
export 'package:webview_flutter/webview_flutter.dart';

export 'artech_app.dart';
export 'background_location/background_location.dart';
export 'background_location/position_widget.dart';
export 'color_extension.dart';
export 'components/components.dart';
export 'data/gender.dart';
export 'data/media_file_info.dart';
export 'data/multiple_media_file_info.dart';
export 'data/search_item.dart';
export 'data/sort_text.dart';
export 'decoding/decoding.dart';
export 'dev/test_page.dart';
export 'gender_extension.dart';
export 'hooks/hooks.dart';
export 'launch_service/launch_service.dart';
export 'menu/menu.dart';
export 'menu/menu_modifier.dart';
export 'pages/pages.dart';
export 'provider/provider.dart';
export 'routes.dart';
export 'ui_kit_module.dart';


const int settingMenuDisplayPriority = 800;
const int settingMenuUserPriority = 600;
const int settingMenuSystemPriority = 400;
const int settingMenuHelpPriority = 200;

const homeRoute = Navigator.defaultRouteName;


/// [appName] override application name in about
/// [image] company log in about page
/// [copyRight] copy right in about page
/// [circleAvatar] use circle avatar
class ApplicationConfig {
  String? Function(BuildContext context)? appName;
  String? Function(BuildContext context)? appNameWeb;
  WidgetBuilder? image;
  String? Function(BuildContext context)? copyRight;
  Future<String> Function()? availableVersion;
  List<WidgetBuilder> aboutWidgets = [];
  bool? circleAvatar;
  WidgetBuilder? loading;
  double? pictureClipRadius;
}

final router = FluroRouter();

/// * [isPage] widget2 is page
extension AppMenuItemExtension on MenuGroupItem {
  bool get hasAppSidebar => (extra['hasAppBarBuilder'] as bool?) ?? false;
  set hasAppSidebar(bool value) => extra['hasAppBarBuilder'] = value;
  bool get isPage => (extra['isPage'] as bool?) ?? true;
  set isPage(bool value) => extra['isPage'] = value;
}

extension RouteParamsExtension<T> on Map<String, List<T>> {
  T? firstParam(String key) {
    final v = this[key];
    if (v == null) {
      return null;
    }
    return v.firstWhereOrNull((element) => true);
  }
}
