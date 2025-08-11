import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/disk_dir_entity.dart';

DiskDirEntity $DiskDirEntityFromJson(Map<String, dynamic> json) {
  final DiskDirEntity diskDirEntity = DiskDirEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    diskDirEntity.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    diskDirEntity.title = title;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    diskDirEntity.createtime = createtime;
  }
  final List<DiskDirEntity>? subs = (json['subs'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DiskDirEntity>(e) as DiskDirEntity)
      .toList();
  if (subs != null) {
    diskDirEntity.subs = subs;
  }
  final bool? selected = jsonConvert.convert<bool>(json['selected']);
  if (selected != null) {
    diskDirEntity.selected = selected;
  }
  return diskDirEntity;
}

Map<String, dynamic> $DiskDirEntityToJson(DiskDirEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['createtime'] = entity.createtime;
  data['subs'] = entity.subs?.map((v) => v.toJson()).toList();
  data['selected'] = entity.selected;
  return data;
}

extension DiskDirEntityExtension on DiskDirEntity {
  DiskDirEntity copyWith({
    int? id,
    String? title,
    String? createtime,
    List<DiskDirEntity>? subs,
    bool? selected,
  }) {
    return DiskDirEntity()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..createtime = createtime ?? this.createtime
      ..subs = subs ?? this.subs
      ..selected = selected ?? this.selected;
  }
}