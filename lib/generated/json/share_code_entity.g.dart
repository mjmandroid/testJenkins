import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/share_code_entity.dart';

ShareCodeEntity $ShareCodeEntityFromJson(Map<String, dynamic> json) {
  final ShareCodeEntity shareCodeEntity = ShareCodeEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    shareCodeEntity.code = code;
  }
  final int? pageType = jsonConvert.convert<int>(json['page_type']);
  if (pageType != null) {
    shareCodeEntity.pageType = pageType;
  }
  return shareCodeEntity;
}

Map<String, dynamic> $ShareCodeEntityToJson(ShareCodeEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['page_type'] = entity.pageType;
  return data;
}

extension ShareCodeEntityExtension on ShareCodeEntity {
  ShareCodeEntity copyWith({
    String? code,
    int? pageType,
  }) {
    return ShareCodeEntity()
      ..code = code ?? this.code
      ..pageType = pageType ?? this.pageType;
  }
}