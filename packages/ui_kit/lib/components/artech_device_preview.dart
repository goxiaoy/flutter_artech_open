import 'package:artech_core/core.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArtechDevicePreview extends HookWidget {
  ArtechDevicePreview({required this.builder, required this.locale});
  final Widget Function(
      BuildContext context, Locale? locale, TransitionBuilder builder) builder;

  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    var opt = serviceLocator.get<LocalizationOption>();
    var enable = kIsDebug &&
        !(View.of(context).physicalSize.width /
                View.of(context).devicePixelRatio <
            600.0);

    return DevicePreview(
        enabled: enable,
        availableLocales:
            opt.support.map((e) => e.locale).toList(growable: false),
        tools: [
          ...DevicePreview.defaultTools,
          const DevicePreviewScreenshot(),
        ],
        builder: (context) {
          return builder(
              context,
              enable && DevicePreview.isEnabled(context)
                  ? DevicePreview.locale(context)
                  : locale,
              DevicePreview.appBuilder);
        });
  }
}
