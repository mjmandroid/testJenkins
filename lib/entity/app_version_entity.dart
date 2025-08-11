import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/app_version_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/app_version_entity.g.dart';

@JsonSerializable()
class AppVersionEntity {
	String? newversion;
	String? packagesize;
	String? content;
	String? downloadurl;
	int? enforce;
	int? createtime;

	AppVersionEntity();

	factory AppVersionEntity.fromJson(Map<String, dynamic> json) => $AppVersionEntityFromJson(json);

	Map<String, dynamic> toJson() => $AppVersionEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}