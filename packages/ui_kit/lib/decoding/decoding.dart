import 'package:artech_ui_kit/ui_kit.dart';

import 'decoding_stub.dart'
    if (dart.library.io) 'decoding_native.dart'
    if (dart.library.html) 'decoding_web.dart';

abstract class Decoding {
  Future<List<AddressData>> fromPosition(PositionData positionData);
  Future<List<PositionData>> fromAddress(String address);
}

final decoder = getDecoding();
