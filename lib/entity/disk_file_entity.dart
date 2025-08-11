import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/disk_file_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/disk_file_entity.g.dart';

@JsonSerializable()
class DiskFileEntity {
	int? id;
	String? title;
	@JSONField(name: "file_type")
	int? fileType;
	String? createtime;
	String? size;
  @JSONField(name: "size_bt")
  int? sizeBt;
	@JSONField(name: "dir_pid")
	int? dirPid;
	@JSONField(name: "is_dir")
	int? isDir;
	String? thumb;
	@JSONField(name: "file_count")
	int? fileCount;
	@JSONField(name: "data_type")
	int? dataType;
	List<DiskFileEntity>? subs;
	@JSONField(serialize: false,deserialize: false)
	bool? _selected;
	String? bucket;
	String? path;
  @JSONField(name: "has_pwd")
	int? hasPwd;
  @JSONField(name: "relation_dir_id")
	int? relationDirId;

	bool? get selected => _selected;
	set selected(bool? value) {
		if (dataType != 3){
			_selected = value;
		}
	}

	bool get subsExistSelected => subs?.where((element) => element.selected == true).isNotEmpty == true;
	//系统文件无法被选中操作
	bool get subsTotalSelected => subs?.where((element) => element.selected != true && element.dataType != 3).isEmpty == true;

	DiskFileEntity();

	factory DiskFileEntity.fromJson(Map<String, dynamic> json) => $DiskFileEntityFromJson(json);

	Map<String, dynamic> toJson() => $DiskFileEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}