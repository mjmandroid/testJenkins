import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/notice_entity.dart';

NoticeEntity $NoticeEntityFromJson(Map<String, dynamic> json) {
  final NoticeEntity noticeEntity = NoticeEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    noticeEntity.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    noticeEntity.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    noticeEntity.content = content;
  }
  final String? showDate = jsonConvert.convert<String>(json['show_date']);
  if (showDate != null) {
    noticeEntity.showDate = showDate;
  }
  return noticeEntity;
}

Map<String, dynamic> $NoticeEntityToJson(NoticeEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['show_date'] = entity.showDate;
  return data;
}

extension NoticeEntityExtension on NoticeEntity {
  NoticeEntity copyWith({
    int? id,
    String? title,
    String? content,
    String? showDate,
  }) {
    return NoticeEntity()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..showDate = showDate ?? this.showDate;
  }
}