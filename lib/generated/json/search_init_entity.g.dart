import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/search_init_entity.dart';

SearchInitEntity $SearchInitEntityFromJson(Map<String, dynamic> json) {
  final SearchInitEntity searchInitEntity = SearchInitEntity();
  final List<String>? word = (json['word'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (word != null) {
    searchInitEntity.word = word;
  }
  final SearchInitEnum? fileEnum = jsonConvert.convert<SearchInitEnum>(
      json['enum']);
  if (fileEnum != null) {
    searchInitEntity.fileEnum = fileEnum;
  }
  return searchInitEntity;
}

Map<String, dynamic> $SearchInitEntityToJson(SearchInitEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['word'] = entity.word;
  data['enum'] = entity.fileEnum?.toJson();
  return data;
}

extension SearchInitEntityExtension on SearchInitEntity {
  SearchInitEntity copyWith({
    List<String>? word,
    SearchInitEnum? fileEnum,
  }) {
    return SearchInitEntity()
      ..word = word ?? this.word
      ..fileEnum = fileEnum ?? this.fileEnum;
  }
}

SearchInitEnum $SearchInitEnumFromJson(Map<String, dynamic> json) {
  final SearchInitEnum searchInitEnum = SearchInitEnum();
  final dynamic type = json['type'];
  if (type != null) {
    searchInitEnum.type = type;
  }
  return searchInitEnum;
}

Map<String, dynamic> $SearchInitEnumToJson(SearchInitEnum entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['type'] = entity.type;
  return data;
}

extension SearchInitEnumExtension on SearchInitEnum {
  SearchInitEnum copyWith({
    dynamic type,
  }) {
    return SearchInitEnum()
      ..type = type ?? this.type;
  }
}

SearchTypeEnum $SearchTypeEnumFromJson(Map<String, dynamic> json) {
  final SearchTypeEnum searchTypeEnum = SearchTypeEnum();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    searchTypeEnum.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    searchTypeEnum.value = value;
  }
  return searchTypeEnum;
}

Map<String, dynamic> $SearchTypeEnumToJson(SearchTypeEnum entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  return data;
}

extension SearchTypeEnumExtension on SearchTypeEnum {
  SearchTypeEnum copyWith({
    String? name,
    String? value,
  }) {
    return SearchTypeEnum()
      ..name = name ?? this.name
      ..value = value ?? this.value;
  }
}