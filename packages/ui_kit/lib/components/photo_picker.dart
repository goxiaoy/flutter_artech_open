import 'dart:io';

import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artech_ui_kit/ui_kit.dart';

// Take photo from camera or gallery
class PhotoPicker extends StatelessWidget {
  final Widget? icon;
  final double? iconSize;
  final String? title;
  final ValueChanged<File>? onSelected;
  final String? tooltip;
  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;

  const PhotoPicker(
      {this.icon,
      this.maxHeight,
      this.maxWidth,
      this.imageQuality,
      this.title,
      this.iconSize,
      this.tooltip,
      required this.onSelected})
      : super();

  void _onClicked(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            title: Text(
              title ?? S.of(context).photoPicker,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Theme.of(context).disabledColor),
            ),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var file = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                        imageQuality: imageQuality);
                    if (file != null) {
                      onSelected!(File(file.path));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.camera_alt,color: Theme.of(context).disabledColor,),
                        Text(S.of(context).camera),
                      ],
                    ),
                  )),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var file = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                        imageQuality: imageQuality);
                    if (file != null) {
                      onSelected!(File(file.path));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.photo,color: Theme.of(context).disabledColor,),
                        Text(S.of(context).fromAlbum),
                      ],
                    ),
                  ))
            ],
            cancelButton: CupertinoButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ArtechIconButton(
      padding: const EdgeInsets.all(0.0),
      tooltip: tooltip ?? S.of(context).photoPicker,
      iconSize: iconSize ?? 24.0,
      icon: icon ?? Icon(Icons.photo),
      onPressed: onSelected != null
          ? () {
              _onClicked(context);
            }
          : null,
    );
  }
}
