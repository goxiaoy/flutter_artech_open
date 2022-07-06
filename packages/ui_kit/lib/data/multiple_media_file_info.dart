import 'package:artech_core/core.dart';
import 'media_file_info.dart';

part 'multiple_media_file_info.g.dart';

@JsonSerializable()
class MultipleMediaFileInfo {
  MultipleMediaFileInfo();
  //TODO update name
  @JsonKey(name: 'directus_files_id')
  MediaFileInfo? file;

  factory MultipleMediaFileInfo.fromJson(Map<String, dynamic> json) =>
      json.toData(_$MultipleMediaFileInfoFromJson);

  Map<String, dynamic> toJson() => _$MultipleMediaFileInfoToJson(this);
}
