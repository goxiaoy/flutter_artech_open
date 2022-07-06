import 'package:flutter/material.dart';

const double _radius = 8.0;

Future<T?> showArtechModalBottomSheet<T>(
    {required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    ShapeBorder? shape}) async {
  return await showModalBottomSheet(
      context: context,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      shape: shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius))));
}
