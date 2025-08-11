import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/check_file_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/check_file_entity.g.dart';

@JsonSerializable()
class CheckFileEntity {
	bool? exist;

	CheckFileEntity();

	factory CheckFileEntity.fromJson(Map<String, dynamic> json) => $CheckFileEntityFromJson(json);

	Map<String, dynamic> toJson() => $CheckFileEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}