import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/data/address_data.dart';
import 'package:artech_ui_kit/data/position_data.dart';
import 'package:google_geocoding/google_geocoding.dart';

import 'decoding.dart';

Decoding getDecoding() => DecodingImpl();

class DecodingImpl with HasNamedLogger implements Decoding {
  @override
  Future<List<PositionData>> fromAddress(String address) async {
    // final GeocodingResponse response =
    //     await (await serviceLocator.getAsync<GoogleMapsGeocoding>())
    //         .searchByAddress(address);
    // logger.info('${response.status}');
    // if (response.isOkay) {
    //   return response.results
    //       .map<PositionData>((e) => PositionData(
    //           lat: e.geometry.location.lat, lon: e.geometry.location.lng))
    //       .toList();
    // } else {
    //   logger.severe('${response.errorMessage}');
    // }
    return [];
  }

  @override
  Future<List<AddressData>> fromPosition(PositionData positionData) async {
    return [];
  }

  @override
  String get loggerName => 'DecodingWeb';
}
