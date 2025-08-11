import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/unzip_progress_entity.dart';

UnzipProgressEntity $UnzipProgressEntityFromJson(Map<String, dynamic> json) {
  final UnzipProgressEntity unzipProgressEntity = UnzipProgressEntity();
  final int? progress = jsonConvert.convert<int>(json['progress']);
  if (progress != null) {
    unzipProgressEntity.progress = progress;
  }
  return unzipProgressEntity;
}

Map<String, dynamic> $UnzipProgressEntityToJson(UnzipProgressEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['progress'] = entity.progress;
  return data;
}

extension UnzipProgressEntityExtension on UnzipProgressEntity {
  UnzipProgressEntity copyWith({
    int? progress,
  }) {
    return UnzipProgressEntity()
      ..progress = progress ?? this.progress;
  }
}