import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/disk_dir_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/disk_dir_entity.g.dart';

@JsonSerializable()
class DiskDirEntity {
	int? id;
	String? title;
	String? createtime;
	List<DiskDirEntity>? subs;
	bool? selected;

	DiskDirEntity();

	factory DiskDirEntity.fromJson(Map<String, dynamic> json) => $DiskDirEntityFromJson(json);

	Map<String, dynamic> toJson() => $DiskDirEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}