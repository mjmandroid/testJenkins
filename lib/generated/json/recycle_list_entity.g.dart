import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/recycle_list_entity.dart';

RecycleListEntity $RecycleListEntityFromJson(Map<String, dynamic> json) {
  final RecycleListEntity recycleListEntity = RecycleListEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    recycleListEntity.id = id;
  }
  final int? relationId = jsonConvert.convert<int>(json['relation_id']);
  if (relationId != null) {
    recycleListEntity.relationId = relationId;
  }
  final int? dataType = jsonConvert.convert<int>(json['data_type']);
  if (dataType != null) {
    recycleListEntity.dataType = dataType;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    recycleListEntity.createtime = createtime;
  }
  final String? expiredtime = jsonConvert.convert<String>(json['expiredtime']);
  if (expiredtime != null) {
    recycleListEntity.expiredtime = expiredtime;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    recycleListEntity.name = name;
  }
  final int? fileType = jsonConvert.convert<int>(json['file_type']);
  if (fileType != null) {
    recycleListEntity.fileType = fileType;
  }
  final int? fileCount = jsonConvert.convert<int>(json['file_count']);
  if (fileCount != null) {
    recycleListEntity.fileCount = fileCount;
  }
  final String? fileSize = jsonConvert.convert<String>(json['file_size']);
  if (fileSize != null) {
    recycleListEntity.fileSize = fileSize;
  }
  final int? expireddays = jsonConvert.convert<int>(json['expireddays']);
  if (expireddays != null) {
    recycleListEntity.expireddays = expireddays;
  }
  final String? thumb = jsonConvert.convert<String>(json['thumb']);
  if (thumb != null) {
    recycleListEntity.thumb = thumb;
  }
  return recycleListEntity;
}

Map<String, dynamic> $RecycleListEntityToJson(RecycleListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['relation_id'] = entity.relationId;
  data['data_type'] = entity.dataType;
  data['createtime'] = entity.createtime;
  data['expiredtime'] = entity.expiredtime;
  data['name'] = entity.name;
  data['file_type'] = entity.fileType;
  data['file_count'] = entity.fileCount;
  data['file_size'] = entity.fileSize;
  data['expireddays'] = entity.expireddays;
  data['thumb'] = entity.thumb;
  return data;
}

extension RecycleListEntityExtension on RecycleListEntity {
  RecycleListEntity copyWith({
    int? id,
    int? relationId,
    int? dataType,
    String? createtime,
    String? expiredtime,
    String? name,
    int? fileType,
    int? fileCount,
    String? fileSize,
    int? expireddays,
    String? thumb,
    bool? selected,
  }) {
    return RecycleListEntity()
      ..id = id ?? this.id
      ..relationId = relationId ?? this.relationId
      ..dataType = dataType ?? this.dataType
      ..createtime = createtime ?? this.createtime
      ..expiredtime = expiredtime ?? this.expiredtime
      ..name = name ?? this.name
      ..fileType = fileType ?? this.fileType
      ..fileCount = fileCount ?? this.fileCount
      ..fileSize = fileSize ?? this.fileSize
      ..expireddays = expireddays ?? this.expireddays
      ..thumb = thumb ?? this.thumb
      ..selected = selected ?? this.selected;
  }
}