import 'dart:io';

import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Take video from camera or gallery
class VideoPicker extends StatelessWidget {
  final Widget? icon;
  final Widget? title;
  final ValueChanged<File> onSelected;
  final String? message;

  const VideoPicker(
      {Key? key, this.icon, this.title, this.message, required this.onSelected})
      : super(key: key);

  void _onClicked(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            title: title ?? Text(S.of(context).video),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var file = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (file != null) {
                      onSelected(File(file.path));
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).camera)),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      onSelected(File(file.path));
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).fromAlbum))
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
    return IconButton(
      padding: const EdgeInsets.all(0.0),
      icon: icon ?? Icon(Icons.video_call_outlined),
      onPressed: () {
        _onClicked(context);
      },
    );
  }
}
