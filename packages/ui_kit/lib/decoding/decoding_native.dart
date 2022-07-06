import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:geocoding/geocoding.dart' as geocode;

Decoding getDecoding() => DecodingImpl();

class DecodingImpl with HasNamedLogger implements Decoding {
  @override
  Future<List<PositionData>> fromAddress(String address) async {
    try {
      List<geocode.Location> locations =
          await geocode.locationFromAddress(address);
      return locations
          .map<PositionData>(
              (e) => PositionData(lat: e.latitude, lon: e.longitude))
          .toList();
    } catch (error) {
      logger.severe(error);
      return [];
    }
  }

  @override
  Future<List<AddressData>> fromPosition(PositionData positionData) async {
    List<geocode.Placemark> places = await geocode.placemarkFromCoordinates(
        positionData.lat, positionData.lon);
    return places.map<AddressData>((e) => e.toData()).toList();
  }

  @override
  String get loggerName => 'DecodingNative';
}

extension PlacemarkExtension on geocode.Placemark {
  AddressData toData() {
    return AddressData()
      ..address1 = this.street
      ..country = this.country
      ..postalCode = this.postalCode;
  }
}
