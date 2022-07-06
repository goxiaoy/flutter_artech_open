import 'package:artech_core/core.dart';

part 'address_data.g.dart';

@JsonSerializable()
class AddressData extends ValueObject {
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? country;
  String? state;
  String? postalCode;

  AddressData();

  factory AddressData.fromJson(Map<String, dynamic>? json) =>
      json.toData(_$AddressDataFromJson);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);

  String toText() {
    final _address1 = '${address1!},';
    final _address2 =
        address2 != null || address2!.isNotEmpty ? '${address2!}\n' : '';
    final _city = '${city!},';
    final _postCode = '${state!} ${postalCode!}, ${country!}';
    return '$_address1$_address2$_city$_postCode';
  }
}
