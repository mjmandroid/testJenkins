import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/unzip_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/unzip_entity.g.dart';

@JsonSerializable()
class UnzipEntity {
	@JSONField(name: "task_id")
	String? taskId;
	@JSONField(name: "event_id")
	String? eventId;
	@JSONField(name: "request_id")
	String? requestId;
	@JSONField(name: "log_id")
	String? logId;
	@JSONField(name: "project_name")
	String? projectName;
	@JSONField(name: "bucket_domain")
	String? bucketDomain;
	@JSONField(name: "bucket_name")
	String? bucketName;

	UnzipEntity();

	factory UnzipEntity.fromJson(Map<String, dynamic> json) => $UnzipEntityFromJson(json);

	Map<String, dynamic> toJson() => $UnzipEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}