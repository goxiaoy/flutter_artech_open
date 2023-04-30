import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:artech_ui_kit/ui_kit.dart';

class CachedNetworkImageView extends StatefulWidget {
  final String imageUrl;
  final PlaceholderWidgetBuilder? placeholder;
  final BoxFit? fit;
  final LoadingErrorWidgetBuilder? errorWidget;
  final bool? tightMode;

  const CachedNetworkImageView(
      {Key? key,
      required this.imageUrl,
      this.placeholder,
      this.fit,
      this.tightMode,
      this.errorWidget})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CachedNetworkImageViewState();
  }
}

class _CachedNetworkImageViewState extends State<CachedNetworkImageView> {
  @override
  Widget build(BuildContext context) {
    return PhotoView.customChild(
        tightMode: widget.tightMode,
        minScale: 1.0,
        maxScale: 5.0,
        child: ArtechCachedNetworkImage(
            imageUrl: widget.imageUrl,
            placeholder: widget.placeholder,
            fit: widget.fit,
            errorWidget: widget.errorWidget));
  }
}

Future showPhotoDialog(BuildContext context, {required String imageUrl}) async {
  await showDialog(
      context: context,
      builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(0.0),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CachedNetworkImageView(
                  tightMode: true,
                  imageUrl: imageUrl,
                )),
          ));
}
