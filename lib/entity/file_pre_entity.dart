import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/file_pre_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/file_pre_entity.g.dart';

@JsonSerializable()
class FilePreEntity {
	int? flag;
	int? quick;
	String? bucket;
	@JSONField(name: "oss_name")
	String? ossName;
	@JSONField(name: "log_id")
	String? logId;

	FilePreEntity();

	factory FilePreEntity.fromJson(Map<String, dynamic> json) => $FilePreEntityFromJson(json);

	Map<String, dynamic> toJson() => $FilePreEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}