import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/disk_file_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/disk_file_entity.g.dart';

class MobileFileEntity {
	String path;
	DateTime time;
	bool selected = false;

	String get fileExtension{
		var last = path.split('/').lastOrNull ?? '';
		return last.split('.').lastOrNull ?? '';
	}

	String get name{
		return path.split('/').lastOrNull ?? '';
	}

	MobileFileEntity({required this.path,required this.time});
}