import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/search_result_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/search_result_entity.g.dart';

@JsonSerializable()
class SearchResultEntity {
	List<SearchResultList>? list;
	int? total;
  @JSONField(name: 'enum')
	SearchResultEnum? fileEnum;

	SearchResultEntity();

	factory SearchResultEntity.fromJson(Map<String, dynamic> json) => $SearchResultEntityFromJson(json);

	Map<String, dynamic> toJson() => $SearchResultEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchResultList {
	int? id;
	String? title;
	String? createtime;
	@JSONField(name: "is_dir")
	int? isDir;
	@JSONField(name: "data_type")
	int? dataType;
	int? size;
	@JSONField(name: "file_count")
	int? fileCount;

	SearchResultList();

	factory SearchResultList.fromJson(Map<String, dynamic> json) => $SearchResultListFromJson(json);

	Map<String, dynamic> toJson() => $SearchResultListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchResultEnum {
	@JSONField(name: "data_type")
	List<SearchResultEnumDataType>? dataType;

	SearchResultEnum();

	factory SearchResultEnum.fromJson(Map<String, dynamic> json) => $SearchResultEnumFromJson(json);

	Map<String, dynamic> toJson() => $SearchResultEnumToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchResultEnumDataType {
	int? key;
	String? value;

	SearchResultEnumDataType();

	factory SearchResultEnumDataType.fromJson(Map<String, dynamic> json) => $SearchResultEnumDataTypeFromJson(json);

	Map<String, dynamic> toJson() => $SearchResultEnumDataTypeToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}