import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/share_data_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/share_data_entity.g.dart';

@JsonSerializable()
class ShareDataEntity {
	String? code;
	String? link;
	String? title;
	String? txt;

	ShareDataEntity();

	factory ShareDataEntity.fromJson(Map<String, dynamic> json) => $ShareDataEntityFromJson(json);

	Map<String, dynamic> toJson() => $ShareDataEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}