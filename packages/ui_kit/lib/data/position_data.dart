import 'package:json_annotation/json_annotation.dart';
part 'position_data.g.dart';

@JsonSerializable()
class PositionData {
  double lat;
  double lon;
  DateTime? timestamp;
  double? altitude;
  double? heading;
  double? speed;

  PositionData({required this.lat, required this.lon});

  factory PositionData.fromJson(Map<String, dynamic> json) =>
      _$PositionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PositionDataToJson(this);
}
