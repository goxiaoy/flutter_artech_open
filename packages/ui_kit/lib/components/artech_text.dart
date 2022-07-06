import 'package:flutter/material.dart';
import 'package:artech_core/core.dart';

/// Artech text override Text since flutter bug when overflow.ellipsis in Chinese
///
class ArtechText extends StatelessWidget {
  final String data;
  final int? maxLines;
  final TextStyle? style;
  final bool? softWrap;
  const ArtechText(this.data,
      {Key? key, this.maxLines, this.style, this.softWrap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _style = style;
    var _softWrap = softWrap;
    // We only find problem with web and overflow.ellipsis
    if (UniversalPlatform.isWeb &&
        style != null &&
        style!.overflow == TextOverflow.ellipsis) {
      _style = _style!.copyWith(overflow: TextOverflow.fade);
      // Disable soft wrap when this happened
      _softWrap = null;
    }
    return Text(
      data,
      maxLines: maxLines,
      style: _style,
      softWrap: _softWrap,
    );
  }
}
