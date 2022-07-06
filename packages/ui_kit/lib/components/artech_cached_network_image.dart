import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:artech_core/core.dart';

const double _defaultRadius = 8.0;

class ArtechCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final double? radius;
  final double? width;
  final double? height;
  final bool enabledClipper;
  const ArtechCachedNetworkImage(
      {Key? key,
      required this.imageUrl,
      this.errorWidget,
      this.width,
      this.height,
      this.fit,
      this.radius,
      this.enabledClipper=true,
      this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = this.radius ??
        serviceLocator.get<ApplicationConfig>().pictureClipRadius ??
        _defaultRadius;
    return enabledClipper
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: placeholder,
              errorWidget: errorWidget,
              fit: fit,
              width: width,
              height: height,
            ))
        : CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: placeholder,
            errorWidget: errorWidget,
            fit: fit,
            width: width,
            height: height,
          );
  }
}
