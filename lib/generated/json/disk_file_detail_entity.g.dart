import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/disk_file_detail_entity.dart';

DiskFileDetailEntity $DiskFileDetailEntityFromJson(Map<String, dynamic> json) {
  final DiskFileDetailEntity diskFileDetailEntity = DiskFileDetailEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    diskFileDetailEntity.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    diskFileDetailEntity.title = title;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    diskFileDetailEntity.createtime = createtime;
  }
  final String? updatetime = jsonConvert.convert<String>(json['updatetime']);
  if (updatetime != null) {
    diskFileDetailEntity.updatetime = updatetime;
  }
  final int? isDir = jsonConvert.convert<int>(json['is_dir']);
  if (isDir != null) {
    diskFileDetailEntity.isDir = isDir;
  }
  final int? dataType = jsonConvert.convert<int>(json['data_type']);
  if (dataType != null) {
    diskFileDetailEntity.dataType = dataType;
  }
  final String? size = jsonConvert.convert<String>(json['size']);
  if (size != null) {
    diskFileDetailEntity.size = size;
  }
  final String? bucket = jsonConvert.convert<String>(json['bucket']);
  if (bucket != null) {
    diskFileDetailEntity.bucket = bucket;
  }
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    diskFileDetailEntity.path = path;
  }
  final String? ossDomain = jsonConvert.convert<String>(json['oss_domain']);
  if (ossDomain != null) {
    diskFileDetailEntity.ossDomain = ossDomain;
  }
  final String? filePath = jsonConvert.convert<String>(json['file_path']);
  if (filePath != null) {
    diskFileDetailEntity.filePath = filePath;
  }
  final String? thumb = jsonConvert.convert<String>(json['thumb']);
  if (thumb != null) {
    diskFileDetailEntity.thumb = thumb;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    diskFileDetailEntity.status = status;
  }
  final int? hasPwd = jsonConvert.convert<int>(json['has_pwd']);
  if (hasPwd != null) {
    diskFileDetailEntity.hasPwd = hasPwd;
  }
  final int? fileCount = jsonConvert.convert<int>(json['file_count']);
  if (fileCount != null) {
    diskFileDetailEntity.fileCount = fileCount;
  }
  return diskFileDetailEntity;
}

Map<String, dynamic> $DiskFileDetailEntityToJson(DiskFileDetailEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['createtime'] = entity.createtime;
  data['updatetime'] = entity.updatetime;
  data['is_dir'] = entity.isDir;
  data['data_type'] = entity.dataType;
  data['size'] = entity.size;
  data['bucket'] = entity.bucket;
  data['path'] = entity.path;
  data['oss_domain'] = entity.ossDomain;
  data['file_path'] = entity.filePath;
  data['thumb'] = entity.thumb;
  data['status'] = entity.status;
  data['has_pwd'] = entity.hasPwd;
  data['file_count'] = entity.fileCount;
  return data;
}

extension DiskFileDetailEntityExtension on DiskFileDetailEntity {
  DiskFileDetailEntity copyWith({
    int? id,
    String? title,
    String? createtime,
    String? updatetime,
    int? isDir,
    int? dataType,
    String? size,
    String? bucket,
    String? path,
    String? ossDomain,
    String? filePath,
    String? thumb,
    int? status,
    int? hasPwd,
    int? fileCount,
  }) {
    return DiskFileDetailEntity()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..createtime = createtime ?? this.createtime
      ..updatetime = updatetime ?? this.updatetime
      ..isDir = isDir ?? this.isDir
      ..dataType = dataType ?? this.dataType
      ..size = size ?? this.size
      ..bucket = bucket ?? this.bucket
      ..path = path ?? this.path
      ..ossDomain = ossDomain ?? this.ossDomain
      ..filePath = filePath ?? this.filePath
      ..thumb = thumb ?? this.thumb
      ..status = status ?? this.status
      ..hasPwd = hasPwd ?? this.hasPwd
      ..fileCount = fileCount ?? this.fileCount;
  }
}