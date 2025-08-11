import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/share_data_entity.dart';

ShareDataEntity $ShareDataEntityFromJson(Map<String, dynamic> json) {
  final ShareDataEntity shareDataEntity = ShareDataEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    shareDataEntity.code = code;
  }
  final String? link = jsonConvert.convert<String>(json['link']);
  if (link != null) {
    shareDataEntity.link = link;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    shareDataEntity.title = title;
  }
  final String? txt = jsonConvert.convert<String>(json['txt']);
  if (txt != null) {
    shareDataEntity.txt = txt;
  }
  return shareDataEntity;
}

Map<String, dynamic> $ShareDataEntityToJson(ShareDataEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['link'] = entity.link;
  data['title'] = entity.title;
  data['txt'] = entity.txt;
  return data;
}

extension ShareDataEntityExtension on ShareDataEntity {
  ShareDataEntity copyWith({
    String? code,
    String? link,
    String? title,
    String? txt,
  }) {
    return ShareDataEntity()
      ..code = code ?? this.code
      ..link = link ?? this.link
      ..title = title ?? this.title
      ..txt = txt ?? this.txt;
  }
}