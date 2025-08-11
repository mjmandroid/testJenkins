import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/base_list_entity.dart';

BaseListEntity $BaseListEntityFromJson(Map<String, dynamic> json) {
  final BaseListEntity baseListEntity = BaseListEntity();
  final dynamic list = json['list'];
  if (list != null) {
    baseListEntity.list = list;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    baseListEntity.total = total;
  }
  final BaseListEnum? fileEnum = jsonConvert.convert<BaseListEnum>(
      json['enum']);
  if (fileEnum != null) {
    baseListEntity.fileEnum = fileEnum;
  }
  return baseListEntity;
}

Map<String, dynamic> $BaseListEntityToJson(BaseListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list;
  data['total'] = entity.total;
  data['enum'] = entity.fileEnum?.toJson();
  return data;
}

extension BaseListEntityExtension on BaseListEntity {
  BaseListEntity copyWith({
    dynamic list,
    int? total,
    BaseListEnum? fileEnum,
  }) {
    return BaseListEntity()
      ..list = list ?? this.list
      ..total = total ?? this.total
      ..fileEnum = fileEnum ?? this.fileEnum;
  }
}

BaseListEnum $BaseListEnumFromJson(Map<String, dynamic> json) {
  final BaseListEnum baseListEnum = BaseListEnum();
  final dynamic typeList = json['typeList'];
  if (typeList != null) {
    baseListEnum.typeList = typeList;
  }
  return baseListEnum;
}

Map<String, dynamic> $BaseListEnumToJson(BaseListEnum entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['typeList'] = entity.typeList;
  return data;
}

extension BaseListEnumExtension on BaseListEnum {
  BaseListEnum copyWith({
    dynamic typeList,
  }) {
    return BaseListEnum()
      ..typeList = typeList ?? this.typeList;
  }
}

BaseListTypeEnum $BaseListTypeEnumFromJson(Map<String, dynamic> json) {
  final BaseListTypeEnum baseListTypeEnum = BaseListTypeEnum();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    baseListTypeEnum.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    baseListTypeEnum.value = value;
  }
  return baseListTypeEnum;
}

Map<String, dynamic> $BaseListTypeEnumToJson(BaseListTypeEnum entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  return data;
}

extension BaseListTypeEnumExtension on BaseListTypeEnum {
  BaseListTypeEnum copyWith({
    String? name,
    String? value,
  }) {
    return BaseListTypeEnum()
      ..name = name ?? this.name
      ..value = value ?? this.value;
  }
}