import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditableMenuButton extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const EditableMenuButton({this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (int index) {
        if (index == 0) onDelete!();
        if (index == 1) {
          onEdit!();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).remove),
                ),
              ],
            ),
          ),
          PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).edit),
                  ),
                ],
              )),
        ];
      },
    );
  }
}
