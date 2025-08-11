import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/upload_file_entity.dart';

UploadFileEntity $UploadFileEntityFromJson(Map<String, dynamic> json) {
  final UploadFileEntity uploadFileEntity = UploadFileEntity();
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    uploadFileEntity.url = url;
  }
  final String? fullurl = jsonConvert.convert<String>(json['fullurl']);
  if (fullurl != null) {
    uploadFileEntity.fullurl = fullurl;
  }
  return uploadFileEntity;
}

Map<String, dynamic> $UploadFileEntityToJson(UploadFileEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['url'] = entity.url;
  data['fullurl'] = entity.fullurl;
  return data;
}

extension UploadFileEntityExtension on UploadFileEntity {
  UploadFileEntity copyWith({
    String? url,
    String? fullurl,
  }) {
    return UploadFileEntity()
      ..url = url ?? this.url
      ..fullurl = fullurl ?? this.fullurl;
  }
}