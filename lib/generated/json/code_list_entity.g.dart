import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/code_list_entity.dart';

CodeListEntity $CodeListEntityFromJson(Map<String, dynamic> json) {
  final CodeListEntity codeListEntity = CodeListEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    codeListEntity.id = id;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    codeListEntity.code = code;
  }
  return codeListEntity;
}

Map<String, dynamic> $CodeListEntityToJson(CodeListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['code'] = entity.code;
  return data;
}

extension CodeListEntityExtension on CodeListEntity {
  CodeListEntity copyWith({
    int? id,
    String? code,
  }) {
    return CodeListEntity()
      ..id = id ?? this.id
      ..code = code ?? this.code;
  }
}