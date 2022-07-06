import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrScannerWidget extends StatelessWidget {
  final Color? color;
  final String? tooltip;
  final Function(BuildContext context, String code)? onQrCode;

  const QrScannerWidget(
      {Key? key, this.color, required this.onQrCode, this.tooltip})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip ?? S.of(context).scanner,
      icon: Icon(
        CupertinoIcons.qrcode_viewfinder,
        color: color ?? Colors.blue.shade700,
      ),
      onPressed: onQrCode != null
          ? () async {
              String barcodeScanRes;
              // Platform messages may fail, so we use a try/catch PlatformException.
              try {
                barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', S.of(context).cancel, true, ScanMode.QR);
                if (barcodeScanRes != '-1') onQrCode!(context, barcodeScanRes);
              } catch (error, stack) {
                showErrorDialog(tooltip ?? S.of(context).scanner, error,
                    stackTrace: stack);
              }
            }
          : null,
    );
  }
}
