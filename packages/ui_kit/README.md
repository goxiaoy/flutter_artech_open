# ui_kit

### Features

 - Phone widget, click dial phone call, android and iOS
 - Video picker,
 - Photo picker, 
 - Make phone call
```dart
     PhoneWidget
```
 - Send email
 ```dart
    EmailWidge
 ```
 - Send message
  ```dart
    PhoneWidget(phoneCall:false);
  ```
 - Webview
  ```dart
    WebsideWidget
   ```
 
 ### QR scannser
  - Config: [https://pub.dev/packages/flutter_barcode_scanner](https://pub.dev/packages/flutter_barcode_scanner)
  - Barcode scanner `BarcodeScannerWidget`
  - Qr scanner `QrScannerWidget`

## Route System
https://github.com/lukepighetti/fluro

```dart
import 'package:artech_ui_kit/ui_kit.dart';


void configureServices() {
   addRoute("/users/:id", handler: usersHandler);
}

```

In your `MaterialApp.onGenerateRoute` replace with `onGenerateRoute: router.generator`

- run `flutter pub run build_runner build --delete-conflicting-outputs` to generate json class
