import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/preview_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/preview_entity.g.dart';

@JsonSerializable()
class PreviewEntity {
	String? url;

	PreviewEntity();

	factory PreviewEntity.fromJson(Map<String, dynamic> json) => $PreviewEntityFromJson(json);

	Map<String, dynamic> toJson() => $PreviewEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}