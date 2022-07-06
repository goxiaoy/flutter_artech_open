import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:artech_ui_kit/ui_kit.dart';

/// Title
/// text style will be changed base upon screen layout
class ArtechTitle extends StatelessWidget {
  final String data;
  final int? maxLines;
  const ArtechTitle(this.data, {Key? key, this.maxLines}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) {
        return ArtechText(data,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis));
      },
      watch: (context) {
        return ArtechText(
          data,
          maxLines: maxLines ?? 1,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
        );
      },
      desktop: (context) {
        return ArtechText(
          data,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
        );
      },
      tablet: (context) {
        return ArtechText(
          data,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
