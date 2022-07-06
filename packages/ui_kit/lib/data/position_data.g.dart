// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionData _$PositionDataFromJson(Map<String, dynamic> json) => PositionData(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    )
      ..timestamp = json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String)
      ..altitude = (json['altitude'] as num?)?.toDouble()
      ..heading = (json['heading'] as num?)?.toDouble()
      ..speed = (json['speed'] as num?)?.toDouble();

Map<String, dynamic> _$PositionDataToJson(PositionData instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'timestamp': instance.timestamp?.toIso8601String(),
      'altitude': instance.altitude,
      'heading': instance.heading,
      'speed': instance.speed,
    };
