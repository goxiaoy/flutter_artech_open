// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressData _$AddressDataFromJson(Map<String, dynamic> json) => AddressData()
  ..address1 = json['address1'] as String?
  ..address2 = json['address2'] as String?
  ..address3 = json['address3'] as String?
  ..city = json['city'] as String?
  ..country = json['country'] as String?
  ..state = json['state'] as String?
  ..postalCode = json['postalCode'] as String?;

Map<String, dynamic> _$AddressDataToJson(AddressData instance) =>
    <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'city': instance.city,
      'country': instance.country,
      'state': instance.state,
      'postalCode': instance.postalCode,
    };
