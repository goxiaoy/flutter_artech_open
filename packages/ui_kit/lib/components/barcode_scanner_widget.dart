import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerWidget extends StatelessWidget {
  final Color? color;
  final String? tooltip;
  final Function(BuildContext context, String code) onBarcode;

  const BarcodeScannerWidget(
      {Key? key, this.color, this.tooltip, required this.onBarcode})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip??S.of(context).scanner,
      icon: Icon(
        CupertinoIcons.barcode,
        color: color ?? Colors.grey.shade600,
      ),
      onPressed: () async {
        String barcodeScanRes;
        // Platform messages may fail, so we use a try/catch PlatformException.
        try {
          barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', S.of(context).cancel, true, ScanMode.BARCODE);
          if (barcodeScanRes != '-1') onBarcode(context, barcodeScanRes);
        } catch (error, stack) {
          showErrorDialog(S.of(context).scanner, error, stackTrace: stack);
        }
      },
    );
  }
}
