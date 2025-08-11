import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/base_list_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/base_list_entity.g.dart';

@JsonSerializable()
class BaseListEntity {
	dynamic list;
	int? total;
  @JSONField(name: 'enum')
	BaseListEnum? fileEnum;

	BaseListEntity();

	factory BaseListEntity.fromJson(Map<String, dynamic> json) => $BaseListEntityFromJson(json);

	Map<String, dynamic> toJson() => $BaseListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class BaseListEnum {
	dynamic typeList;
	@JSONField(serialize: false,deserialize: false)
	List<BaseListTypeEnum>? _typeList;

	List<BaseListTypeEnum> get fileTypeList{
		if (_typeList != null){
			return _typeList!;
		}
		_typeList ??= <BaseListTypeEnum>[];
		var map = Map.from(typeList ?? {});
		map.forEach((key, value) {
			_typeList!.add(
					BaseListTypeEnum()
							..value = key
							..name = value
			);
		});
		_typeList!.sort((a,b){
			return (int.tryParse(a.value ?? '0') ?? 0) > (int.tryParse(b.value ?? '0') ?? 0) ? 1 : -1;
		});
		_typeList!.insert(0,BaseListTypeEnum()
			..value = ''
			..name = '全部');
		return _typeList!;
	}

	BaseListEnum();

	factory BaseListEnum.fromJson(Map<String, dynamic> json) => $BaseListEnumFromJson(json);

	Map<String, dynamic> toJson() => $BaseListEnumToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class BaseListTypeEnum {
	String? name;
	String? value;

	BaseListTypeEnum();

	factory BaseListTypeEnum.fromJson(Map<String, dynamic> json) => $BaseListTypeEnumFromJson(json);

	Map<String, dynamic> toJson() => $BaseListTypeEnumToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}