import 'package:flutter/material.dart';

// Force tooltip
class ArtechPopupButton<T> extends PopupMenuButton<T> {
  const ArtechPopupButton(
      {Key? key,
      required PopupMenuItemBuilder<T> itemBuilder,
      Widget? child,
      PopupMenuItemSelected<T>? onSelected,
      T? initialValue,
      EdgeInsetsGeometry? padding,
      required String tooltip})
      : super(
            key: key,
            initialValue: initialValue,
            itemBuilder: itemBuilder,
            child: child,
            padding: padding ?? const EdgeInsets.all(8.0),
            tooltip: tooltip,
            onSelected: onSelected);
}
