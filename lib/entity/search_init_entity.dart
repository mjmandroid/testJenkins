import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/search_init_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/search_init_entity.g.dart';

@JsonSerializable()
class SearchInitEntity {
	List<String>? word;
	@JSONField(name: 'enum')
	SearchInitEnum? fileEnum;

	SearchInitEntity();

	factory SearchInitEntity.fromJson(Map<String, dynamic> json) => $SearchInitEntityFromJson(json);

	Map<String, dynamic> toJson() => $SearchInitEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchInitEnum {
	dynamic type;
	@JSONField(serialize: false,deserialize: false)
	List<SearchTypeEnum>? _typeList;

	List<SearchTypeEnum> get typeList{
		if (_typeList != null){
			return _typeList!;
		}
		_typeList ??= <SearchTypeEnum>[];
		var map = Map.from(type ?? {});
		map.forEach((key, value) {
			_typeList!.add(
					SearchTypeEnum()
							..value = key
							..name = value
			);
		});
		_typeList!.sort((a,b){
			return (int.tryParse(a.value ?? '0') ?? 0) > (int.tryParse(b.value ?? '0') ?? 0) ? 1 : -1;
		});
		_typeList!.insert(0,SearchTypeEnum()
			..value = ''
			..name = '全部');
		return _typeList!;
	}

	SearchInitEnum();

	factory SearchInitEnum.fromJson(Map<String, dynamic> json) => $SearchInitEnumFromJson(json);

	Map<String, dynamic> toJson() => $SearchInitEnumToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchTypeEnum {
	String? name;
	String? value;

	SearchTypeEnum();

	factory SearchTypeEnum.fromJson(Map<String, dynamic> json) => $SearchTypeEnumFromJson(json);

	Map<String, dynamic> toJson() => $SearchTypeEnumToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}