// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaFileInfo _$MediaFileInfoFromJson(Map<String, dynamic> json) =>
    MediaFileInfo(
      id: json['id'] as String,
      url: json['url'] as String?,
      name: json['name'] as String?,
      height: json['height'] as int?,
      size: (json['size'] as num?)?.toDouble(),
      width: json['width'] as int?,
      caption: json['caption'] as String?,
      ext: json['ext'] as String?,
      formats: json['formats'],
    )
      ..type = json['type'] as String?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..embed = json['embed'] as String?
      ..metadata = json['metadata']
      ..extra = json['extra'] as Map<String, dynamic>?;

Map<String, dynamic> _$MediaFileInfoToJson(MediaFileInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': instance.type,
      'name': instance.name,
      'caption': instance.caption,
      'width': instance.width,
      'height': instance.height,
      'ext': instance.ext,
      'size': instance.size,
      'formats': instance.formats,
      'title': instance.title,
      'description': instance.description,
      'embed': instance.embed,
      'metadata': instance.metadata,
      'extra': instance.extra,
    };
