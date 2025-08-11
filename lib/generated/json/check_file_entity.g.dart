import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/check_file_entity.dart';

CheckFileEntity $CheckFileEntityFromJson(Map<String, dynamic> json) {
  final CheckFileEntity checkFileEntity = CheckFileEntity();
  final bool? exist = jsonConvert.convert<bool>(json['exist']);
  if (exist != null) {
    checkFileEntity.exist = exist;
  }
  return checkFileEntity;
}

Map<String, dynamic> $CheckFileEntityToJson(CheckFileEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['exist'] = entity.exist;
  return data;
}

extension CheckFileEntityExtension on CheckFileEntity {
  CheckFileEntity copyWith({
    bool? exist,
  }) {
    return CheckFileEntity()
      ..exist = exist ?? this.exist;
  }
}