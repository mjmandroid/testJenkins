import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/disk_file_detail_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/disk_file_detail_entity.g.dart';

@JsonSerializable()
class DiskFileDetailEntity {
	int? id = 0;
	String? title = '';
	String? createtime = '';
	String? updatetime = '';
	@JSONField(name: "is_dir")
	int? isDir = 0;
	@JSONField(name: "data_type")
	int? dataType = 0;
	String? size = '';
	String? bucket = '';
	String? path = '';
	@JSONField(name: "oss_domain")
	String? ossDomain = '';
	@JSONField(name: "file_path")
	String? filePath = '';
	String? thumb = '';
	int? status = 0;
	@JSONField(name: "has_pwd")
	int? hasPwd = 0;
	@JSONField(name: "file_count")
	int? fileCount = 0;

	DiskFileDetailEntity();

	factory DiskFileDetailEntity.fromJson(Map<String, dynamic> json) => $DiskFileDetailEntityFromJson(json);

	Map<String, dynamic> toJson() => $DiskFileDetailEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}