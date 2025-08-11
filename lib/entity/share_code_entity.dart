import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/share_code_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/share_code_entity.g.dart';

@JsonSerializable()
class ShareCodeEntity {
	String? code;
	@JSONField(name: "page_type")
	int? pageType;

	ShareCodeEntity();

	factory ShareCodeEntity.fromJson(Map<String, dynamic> json) => $ShareCodeEntityFromJson(json);

	Map<String, dynamic> toJson() => $ShareCodeEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}