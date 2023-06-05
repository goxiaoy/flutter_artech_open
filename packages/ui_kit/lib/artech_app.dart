import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyRouteObserver<R extends Route<dynamic>> extends RouteObserver<R>
    with HasNamedLogger {
  @override
  String get loggerName => 'MyRouteObserver';

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    logger.fine('didPush route: $route,previousRoute:$previousRoute');
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    logger
        .fine('didStartUserGesture route: $route,previousRoute:$previousRoute');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    logger.fine('didReplace newRoute: $newRoute,oldRoute:$oldRoute');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    logger.fine('didRemove route: $route,previousRoute:$previousRoute');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    logger.fine('didPop route: $route,previousRoute:$previousRoute');
  }
}

class ArtechApp extends StatefulHookWidget {
  final Widget? home;
  final String? initialRoute;
  final ThemeData? themeData;
  final String title;
  final TransitionBuilder? innerBuilder;

  // User default locale
  final Locale defaultLocale;

  ArtechApp(
      {Key? key,
      this.home,
      this.title = '',
      this.defaultLocale = const Locale('en'),
      this.themeData,
      this.initialRoute,
      this.innerBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArtechAppState();
  }
}

class ArtechAppState extends State<ArtechApp> with HasNamedLogger {
  final RouteObserver<Route<dynamic>> routeObserver = MyRouteObserver();

  Locale get defaultLocale {
    final opt = serviceLocator.get<LocalizationOption>();
    return opt.defaultLocale ?? widget.defaultLocale;
  }

  @override
  String get loggerName => 'ArtechAppState';

  @override
  Widget build(BuildContext context) {
    final opt = serviceLocator.get<LocalizationOption>();
    final initRoute =
        widget.home != null ? null : widget.initialRoute ?? homeRoute;

    final settingLocale = useWatchSettingKey<String>(
        serviceLocator.get<SettingStore>(), LocalizationOption.settingKey);
    final _locale = settingLocale != null
        ? Locale(settingLocale)
        : (opt.defaultLocale ?? widget.defaultLocale);
    return ArtechDevicePreview(
      locale: _locale,
      builder: (context, locale, builder) => MaterialApp(
          useInheritedMediaQuery: true,
          navigatorKey: serviceLocator<NavigationService>().navigatorKey,
          locale: locale,
          builder: (context, child) {
            return builder(
                context,
                widget.innerBuilder == null
                    ? child
                    : widget.innerBuilder!(
                        context,
                        child,
                      ));
          },
          localizationsDelegates: [...opt.reversedDelegates],
          supportedLocales:
              opt.support.map((e) => e.locale).toList(growable: false),
          localeResolutionCallback:
              (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
            if (deviceLocale == null) {
              return defaultLocale;
            }
            if (supportedLocales.firstWhereOrNull((element) =>
                    element.languageCode == deviceLocale.languageCode) !=
                null) {
              return deviceLocale;
            } else {
              logger
                  .warning('Locale ${deviceLocale.languageCode} not supported');
              return defaultLocale;
            }
          },
          navigatorObservers: [routeObserver],
          onGenerateRoute: router.generator,
          title: widget.title,
          initialRoute: initRoute,
          theme: widget.themeData ??
              ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
          home: widget.home),
    );
  }
}
