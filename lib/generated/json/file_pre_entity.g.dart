import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/file_pre_entity.dart';

FilePreEntity $FilePreEntityFromJson(Map<String, dynamic> json) {
  final FilePreEntity filePreEntity = FilePreEntity();
  final int? flag = jsonConvert.convert<int>(json['flag']);
  if (flag != null) {
    filePreEntity.flag = flag;
  }
  final int? quick = jsonConvert.convert<int>(json['quick']);
  if (quick != null) {
    filePreEntity.quick = quick;
  }
  final String? bucket = jsonConvert.convert<String>(json['bucket']);
  if (bucket != null) {
    filePreEntity.bucket = bucket;
  }
  final String? ossName = jsonConvert.convert<String>(json['oss_name']);
  if (ossName != null) {
    filePreEntity.ossName = ossName;
  }
  final String? logId = jsonConvert.convert<String>(json['log_id']);
  if (logId != null) {
    filePreEntity.logId = logId;
  }
  return filePreEntity;
}

Map<String, dynamic> $FilePreEntityToJson(FilePreEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['flag'] = entity.flag;
  data['quick'] = entity.quick;
  data['bucket'] = entity.bucket;
  data['oss_name'] = entity.ossName;
  data['log_id'] = entity.logId;
  return data;
}

extension FilePreEntityExtension on FilePreEntity {
  FilePreEntity copyWith({
    int? flag,
    int? quick,
    String? bucket,
    String? ossName,
    String? logId,
  }) {
    return FilePreEntity()
      ..flag = flag ?? this.flag
      ..quick = quick ?? this.quick
      ..bucket = bucket ?? this.bucket
      ..ossName = ossName ?? this.ossName
      ..logId = logId ?? this.logId;
  }
}