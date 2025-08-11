import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/recycle_list_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/recycle_list_entity.g.dart';

@JsonSerializable()
class RecycleListEntity {
	int? id;
	@JSONField(name: "relation_id")
	int? relationId;
	@JSONField(name: "data_type")
	int? dataType;
	String? createtime;
	String? expiredtime;
	String? name;
	@JSONField(name: "file_type")
	int? fileType;
	@JSONField(name: "file_count")
	int? fileCount;
	@JSONField(name: "file_size")
	String? fileSize;
	int? expireddays;
  String? thumb;
  @JSONField(serialize: false,deserialize: false)
	bool? selected = false;

	RecycleListEntity();

	factory RecycleListEntity.fromJson(Map<String, dynamic> json) => $RecycleListEntityFromJson(json);

	Map<String, dynamic> toJson() => $RecycleListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}