import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/unzip_progress_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/unzip_progress_entity.g.dart';

@JsonSerializable()
class UnzipProgressEntity {
	int? progress;

	UnzipProgressEntity();

	factory UnzipProgressEntity.fromJson(Map<String, dynamic> json) => $UnzipProgressEntityFromJson(json);

	Map<String, dynamic> toJson() => $UnzipProgressEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}