import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';

DiskFileEntity $DiskFileEntityFromJson(Map<String, dynamic> json) {
  final DiskFileEntity diskFileEntity = DiskFileEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    diskFileEntity.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    diskFileEntity.title = title;
  }
  final int? fileType = jsonConvert.convert<int>(json['file_type']);
  if (fileType != null) {
    diskFileEntity.fileType = fileType;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    diskFileEntity.createtime = createtime;
  }
  final String? size = jsonConvert.convert<String>(json['size']);
  if (size != null) {
    diskFileEntity.size = size;
  }
  final int? dirPid = jsonConvert.convert<int>(json['dir_pid']);
  if (dirPid != null) {
    diskFileEntity.dirPid = dirPid;
  }
  final int? sizeBt = jsonConvert.convert<int>(json['size_bt']);
  if (sizeBt != null) {
    diskFileEntity.sizeBt = sizeBt;
  }
  final int? isDir = jsonConvert.convert<int>(json['is_dir']);
  if (isDir != null) {
    diskFileEntity.isDir = isDir;
  }
  final String? thumb = jsonConvert.convert<String>(json['thumb']);
  if (thumb != null) {
    diskFileEntity.thumb = thumb;
  }
  final int? fileCount = jsonConvert.convert<int>(json['file_count']);
  if (fileCount != null) {
    diskFileEntity.fileCount = fileCount;
  }
  final int? dataType = jsonConvert.convert<int>(json['data_type']);
  if (dataType != null) {
    diskFileEntity.dataType = dataType;
  }
  final List<DiskFileEntity>? subs = (json['subs'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DiskFileEntity>(e) as DiskFileEntity)
      .toList();
  if (subs != null) {
    diskFileEntity.subs = subs;
  }
  final String? bucket = jsonConvert.convert<String>(json['bucket']);
  if (bucket != null) {
    diskFileEntity.bucket = bucket;
  }
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    diskFileEntity.path = path;
  }
  final int? hasPwd = jsonConvert.convert<int>(json['has_pwd']);
  if (hasPwd != null) {
    diskFileEntity.hasPwd = hasPwd;
  }
  final int? relationDirId = jsonConvert.convert<int>(json['relation_dir_id']);
  if (relationDirId != null) {
    diskFileEntity.relationDirId = relationDirId;
  }
  return diskFileEntity;
}

Map<String, dynamic> $DiskFileEntityToJson(DiskFileEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['file_type'] = entity.fileType;
  data['createtime'] = entity.createtime;
  data['size'] = entity.size;
  data['dir_pid'] = entity.dirPid;
  data['is_dir'] = entity.isDir;
  data['thumb'] = entity.thumb;
  data['file_count'] = entity.fileCount;
  data['data_type'] = entity.dataType;
  data['subs'] = entity.subs?.map((v) => v.toJson()).toList();
  data['bucket'] = entity.bucket;
  data['path'] = entity.path;
  data['has_pwd'] = entity.hasPwd;
  data['relation_dir_id'] = entity.relationDirId;
  return data;
}

extension DiskFileEntityExtension on DiskFileEntity {
  DiskFileEntity copyWith({
    int? id,
    String? title,
    int? fileType,
    String? createtime,
    String? size,
    int? dirPid,
    int? isDir,
    String? thumb,
    int? fileCount,
    int? dataType,
    List<DiskFileEntity>? subs,
    String? bucket,
    String? path,
    int? hasPwd,
    int? relationDirId,
    int? sizeBt,
  }) {
    return DiskFileEntity()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..fileType = fileType ?? this.fileType
      ..createtime = createtime ?? this.createtime
      ..size = size ?? this.size
      ..dirPid = dirPid ?? this.dirPid
      ..isDir = isDir ?? this.isDir
      ..thumb = thumb ?? this.thumb
      ..fileCount = fileCount ?? this.fileCount
      ..dataType = dataType ?? this.dataType
      ..subs = subs ?? this.subs
      ..bucket = bucket ?? this.bucket
      ..path = path ?? this.path
      ..hasPwd = hasPwd ?? this.hasPwd
      ..sizeBt = sizeBt ?? this.sizeBt
      ..relationDirId = relationDirId ?? this.relationDirId;
  }
}