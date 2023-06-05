import 'package:artech_api/api.dart';
import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/background_location/position_test_page.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/launch_service/launch_test_page.dart';
import 'package:artech_ui_kit/riverpod/riverpod.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:settings_ui/settings_ui.dart';

import 'multi_localization_delegate.dart';
import 'timeago_extension.dart';

class UIKitModule extends AppSubModuleBase {
  @override
  List<AppModuleMixin> get dependentOn => [ApiModule(), RivderpodModule()];

  @override
  void configureServices() {
    configTyped<AppBarOptions>(creator: () {
      return AppBarOptions();
    });

    configTyped<ApplicationConfig>(creator: () {
      return ApplicationConfig();
    });

    services.registerSingleton<MediaFileUrlNormalizer>(
        EmptyMediaFileUrlNormalizer());

    configTyped<LocalizationOption>(configurator: (opt) {
      opt.delegates.add(MultiAppLocalizationsDelegate.delegate);
    });
    addUIKitRoute();
    initTimeAgo();

    services.registerSingleton<LaunchService>(LaunchService());
    services.registerSingleton<BackgroundLocation>(BackgroundLocation());
    // services.registerLazySingletonAsync<GoogleMapsGeocoding>(() async {
    //   return GoogleMapsGeocoding(
    //     apiKey: services.get<AppConfig>().getValue('google.map.apiKey'),
    //   );
    // });
  }

  testMenu(MenuGroup t) {
    if (kIsDebug) {
      t
        ..addOrReplaceMenu(
            MenuGroupItem('launchService', widget2: (_) => LaunchTestPage()));

      if (!kIsWeb) {
        t
          ..addIfNotExits(MenuGroupItem('qr_scanner',
              widget: (_) => QrScannerWidget(
                    onQrCode: (context, code) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(code),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok'))
                                ],
                              ));
                    },
                  )))
          ..addIfNotExits(MenuGroupItem('barcode_scanner',
              widget: (_) => BarcodeScannerWidget(
                    onBarcode: (context, code) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(code),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok'))
                                ],
                              ));
                    },
                  )));
      }
    }
  }

  void _addLocationTestMenu(MenuGroup testMenu) {
    if (kIsDebug) {
      testMenu.addIfNotExits(MenuGroupItem('location_test_page',
          label: (_) => 'GPS position test Page',
          widget2: (_) => PositionTestPage(),
          widget: (_) => Icon(Icons.location_off_sharp)));
    }
  }

  void _addAddressMapTest(MenuGroup testMenu) {
    if (kIsDebug) {
      testMenu.addIfNotExits(MenuGroupItem('address_widget_test',
          widget: (_) => AddressWidget(
              address: '225 W Valley Blvd, San Gabriel, CA 91776')));
    }
    ;
  }

  void _addAppSettings(MenuGroup settings) {
    settings.addIfNotExits(MenuGroupItem('app_setting',
        priority: settingMenuSystemPriority - 50,
        label: (context) => S.of(context).appSettings,
        widget: (context) => SettingsTile(
              title: Text(S.of(context).appSettings),
              leading: Icon(
                Icons.app_settings_alt_outlined,
                color: Colors.blue.shade700,
              ),
              trailing: ForwardIcon(),
              onPressed: (context) {
                AppSettings.openAppSettings();
              },
            )));
  }

  void _addGpsSettings(MenuGroup settings) {
    settings.addIfNotExits(MenuGroupItem('gps_position',
        priority: settingMenuSystemPriority - 1,
        label: (context) => S.of(context).locationSettings,
        widget: (context) => SettingsTile(
              title: Text(S.of(context).locationSettings),
              leading: Icon(
                Icons.gps_fixed_outlined,
                color: Colors.red.shade700,
              ),
              trailing: ForwardIcon(),
              onPressed: (_) {
                Geolocator.openLocationSettings();
              },
            )));
  }

  void _addLanguageSettings(MenuGroup settings) {
    settings.addOrReplaceMenu(MenuGroupItem(
      'language',
      priority: settingMenuDisplayPriority,
      widget: (context) {
        var languageOpt = services.get<LocalizationOption>();
        var current = Localizations.localeOf(context);
        return SettingsTile.navigation(
          title: Text(S.of(context).language),
          value: Text(languageOpt.support
                  .firstWhereOrNull((element) => element.locale == current)
                  ?.textBuilder(context) ??
              ""),
          leading: Icon(
            Icons.language,
            color: Colors.lightBlueAccent,
          ),
          trailing: ForwardIcon(),
          onPressed: (BuildContext context) async {
            Navigator.of(context)
                .pushNamed(UIKitRoute.settingLanguagePageRoute);
          },
        );
      },
    ));
  }

  @override
  Widget build(Widget child) {
    return GestureDetector(
        onTap: () {
          //https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MenuModifierWidget(
              provider: testingMenuProvider,
              child: MenuModifierWidget(
                provider: settingMenuProvider,
                child: child,
                modifer: [
                  _addLanguageSettings,
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                    _addGpsSettings,
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                    _addAppSettings
                ],
              ),
              modifer: [testMenu, _addLocationTestMenu, _addAddressMapTest],
            ));
  }
}

extension AppMainModuleExtension on AppMainModuleBase {
  MenuModifier addModuleVisualization() {
    return (MenuGroup menu) {
      if (kIsDebug) {
        menu.addOrReplaceMenu(MenuGroupItem('dependency_view',
            widget: (_) => Text("dependency_view"),
            widget2: (_) => ModuleVisualization(
                  mainModule: this,
                )));
      }
      ;
    };
  }
}

extension FluroRouteModuleExtension on AppModuleMixin {
  void addRoute(String routePath,
      {required Handler handler,
      TransitionType? transitionType,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder? transitionBuilder}) {
    router.define(routePath,
        handler: handler,
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder);
  }
}

extension UIKitRouteExtension on UIKitModule {
  void addUIKitRoute() {
    addRoute(UIKitRoute.settingPageRoute,
        handler: Handler(handlerFunc: (context, params) {
      return CommonSettingPage();
    }), transitionType: TransitionType.native);
    addRoute(UIKitRoute.settingLanguagePageRoute,
        handler: Handler(handlerFunc: (context, params) {
      return LanguageSelectionPage();
    }));
    addRoute(UIKitRoute.devTestPageRoute,
        handler: Handler(handlerFunc: (context, params) {
      return TestPage();
    }));
  }
}
