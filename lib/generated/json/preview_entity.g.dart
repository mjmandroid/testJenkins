import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/preview_entity.dart';

PreviewEntity $PreviewEntityFromJson(Map<String, dynamic> json) {
  final PreviewEntity previewEntity = PreviewEntity();
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    previewEntity.url = url;
  }
  return previewEntity;
}

Map<String, dynamic> $PreviewEntityToJson(PreviewEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['url'] = entity.url;
  return data;
}

extension PreviewEntityExtension on PreviewEntity {
  PreviewEntity copyWith({
    String? url,
  }) {
    return PreviewEntity()
      ..url = url ?? this.url;
  }
}