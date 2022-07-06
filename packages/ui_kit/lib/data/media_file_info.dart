import 'package:artech_core/core.dart';

part 'media_file_info.g.dart';

abstract class MediaFileUrlNormalizer {
  void normalize(MediaFileInfo mediaFileInfo);

  void transform(MediaFileInfo mediaFileInfo,
      {int? width,
      int? height,
      int quality = 75,
      bool download = false,
      Map<String, dynamic> extra = const <String, dynamic>{}});
}

class EmptyMediaFileUrlNormalizer implements MediaFileUrlNormalizer {
  @override
  void normalize(MediaFileInfo mediaFileInfo) {}

  @override
  void transform(MediaFileInfo mediaFileInfo,
      {int? width,
      int? height,
      int quality = 75,
      bool download = false,
      Map<String, dynamic> extra = const <String, dynamic>{}}) {}
}

@JsonSerializable()
class MediaFileInfo extends BaseStringEntity {
  @override
  String id;
  String? url;

  //MIME type
  String? type;
  String? name;
  String? caption;
  int? width;
  int? height;
  String? ext;
  double? size;
  Object? formats;
  String? title;
  String? description;
  String? embed;
  Object? metadata;

  Map<String, dynamic>? extra;

  MediaFileInfo(
      {required this.id,
      this.url,
      this.name,
      this.height,
      this.size,
      this.width,
      this.caption,
      this.ext,
      this.formats});

  MediaFileType get mediaFileType {
    if (type != null) {
      if (type!.startsWith('image')) {
        return MediaFileType.image_;
      }
      if (type!.startsWith('audio')) {
        return MediaFileType.song_;
      }
      if (type!.startsWith('video')) {
        return MediaFileType.video_;
      }
    }
    String _ext =
        (ext != null && ext!.isNotEmpty) ? ext! : '.${url!.split('.').last}';
    var t = parseExt(_ext);
    if (t == MediaFileType.unknown_) {
      String nameExt = '.${url!.split('.').last}';
      t = parseExt(nameExt);
    }
    return t;
  }

  bool get isPortrait =>
      width != null && height != null ? width! < height! : false;

  void useToken(bool use) {
    extra = extra ?? <String, dynamic>{};
    extra!['useToken'] = use;
  }

  static MediaFileType parseExt(String ext) {
    if (ext.contains('.png') ||
        ext.contains('.jpg') ||
        ext.contains('.jpeg')) // TODO:
      return MediaFileType.image_;
    else if (ext.contains('.mp3')) {
      return MediaFileType.song_;
    } else if (ext.contains('.mp4')) {
      // TODO:
      return MediaFileType.video_;
    }
    return MediaFileType.unknown_;
  }

  factory MediaFileInfo.fromJson(Map<String, dynamic>? json,
      {bool useToken = true}) {
    final ret = json.toData(_$MediaFileInfoFromJson)..useToken(useToken);
    //normalize url
    if (ret.url == null) {
      serviceLocator.get<MediaFileUrlNormalizer>().normalize(ret);
    }
    return ret;
  }

  Map<String, dynamic> toJson() => _$MediaFileInfoToJson(this);
}

MediaFileInfo? mediaFileInfoFromJsonWithoutToken(Map<String, dynamic>? json) =>
    json != null ? MediaFileInfo.fromJson(json, useToken: false) : null;

enum MediaFileType { video_, image_, song_, unknown_ }
