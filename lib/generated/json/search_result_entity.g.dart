import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/search_result_entity.dart';

SearchResultEntity $SearchResultEntityFromJson(Map<String, dynamic> json) {
  final SearchResultEntity searchResultEntity = SearchResultEntity();
  final List<SearchResultList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<SearchResultList>(e) as SearchResultList)
      .toList();
  if (list != null) {
    searchResultEntity.list = list;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    searchResultEntity.total = total;
  }
  final SearchResultEnum? fileEnum = jsonConvert.convert<SearchResultEnum>(
      json['enum']);
  if (fileEnum != null) {
    searchResultEntity.fileEnum = fileEnum;
  }
  return searchResultEntity;
}

Map<String, dynamic> $SearchResultEntityToJson(SearchResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['total'] = entity.total;
  data['enum'] = entity.fileEnum?.toJson();
  return data;
}

extension SearchResultEntityExtension on SearchResultEntity {
  SearchResultEntity copyWith({
    List<SearchResultList>? list,
    int? total,
    SearchResultEnum? fileEnum,
  }) {
    return SearchResultEntity()
      ..list = list ?? this.list
      ..total = total ?? this.total
      ..fileEnum = fileEnum ?? this.fileEnum;
  }
}

SearchResultList $SearchResultListFromJson(Map<String, dynamic> json) {
  final SearchResultList searchResultList = SearchResultList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    searchResultList.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    searchResultList.title = title;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    searchResultList.createtime = createtime;
  }
  final int? isDir = jsonConvert.convert<int>(json['is_dir']);
  if (isDir != null) {
    searchResultList.isDir = isDir;
  }
  final int? dataType = jsonConvert.convert<int>(json['data_type']);
  if (dataType != null) {
    searchResultList.dataType = dataType;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    searchResultList.size = size;
  }
  final int? fileCount = jsonConvert.convert<int>(json['file_count']);
  if (fileCount != null) {
    searchResultList.fileCount = fileCount;
  }
  return searchResultList;
}

Map<String, dynamic> $SearchResultListToJson(SearchResultList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['createtime'] = entity.createtime;
  data['is_dir'] = entity.isDir;
  data['data_type'] = entity.dataType;
  data['size'] = entity.size;
  data['file_count'] = entity.fileCount;
  return data;
}

extension SearchResultListExtension on SearchResultList {
  SearchResultList copyWith({
    int? id,
    String? title,
    String? createtime,
    int? isDir,
    int? dataType,
    int? size,
    int? fileCount,
  }) {
    return SearchResultList()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..createtime = createtime ?? this.createtime
      ..isDir = isDir ?? this.isDir
      ..dataType = dataType ?? this.dataType
      ..size = size ?? this.size
      ..fileCount = fileCount ?? this.fileCount;
  }
}

SearchResultEnum $SearchResultEnumFromJson(Map<String, dynamic> json) {
  final SearchResultEnum searchResultEnum = SearchResultEnum();
  final List<SearchResultEnumDataType>? dataType = (json['data_type'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<SearchResultEnumDataType>(
          e) as SearchResultEnumDataType).toList();
  if (dataType != null) {
    searchResultEnum.dataType = dataType;
  }
  return searchResultEnum;
}

Map<String, dynamic> $SearchResultEnumToJson(SearchResultEnum entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data_type'] = entity.dataType?.map((v) => v.toJson()).toList();
  return data;
}

extension SearchResultEnumExtension on SearchResultEnum {
  SearchResultEnum copyWith({
    List<SearchResultEnumDataType>? dataType,
  }) {
    return SearchResultEnum()
      ..dataType = dataType ?? this.dataType;
  }
}

SearchResultEnumDataType $SearchResultEnumDataTypeFromJson(
    Map<String, dynamic> json) {
  final SearchResultEnumDataType searchResultEnumDataType = SearchResultEnumDataType();
  final int? key = jsonConvert.convert<int>(json['key']);
  if (key != null) {
    searchResultEnumDataType.key = key;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    searchResultEnumDataType.value = value;
  }
  return searchResultEnumDataType;
}

Map<String, dynamic> $SearchResultEnumDataTypeToJson(
    SearchResultEnumDataType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['key'] = entity.key;
  data['value'] = entity.value;
  return data;
}

extension SearchResultEnumDataTypeExtension on SearchResultEnumDataType {
  SearchResultEnumDataType copyWith({
    int? key,
    String? value,
  }) {
    return SearchResultEnumDataType()
      ..key = key ?? this.key
      ..value = value ?? this.value;
  }
}