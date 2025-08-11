import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/code_list_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/code_list_entity.g.dart';

@JsonSerializable()
class CodeListEntity {
	int? id;
	String? code;

	CodeListEntity();

	factory CodeListEntity.fromJson(Map<String, dynamic> json) => $CodeListEntityFromJson(json);

	Map<String, dynamic> toJson() => $CodeListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}