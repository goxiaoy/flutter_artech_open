// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_media_file_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleMediaFileInfo _$MultipleMediaFileInfoFromJson(
        Map<String, dynamic> json) =>
    MultipleMediaFileInfo()
      ..file = json['directus_files_id'] == null
          ? null
          : MediaFileInfo.fromJson(
              json['directus_files_id'] as Map<String, dynamic>?);

Map<String, dynamic> _$MultipleMediaFileInfoToJson(
        MultipleMediaFileInfo instance) =>
    <String, dynamic>{
      'directus_files_id': instance.file,
    };
