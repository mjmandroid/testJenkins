import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/upload_file_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/upload_file_entity.g.dart';

@JsonSerializable()
class UploadFileEntity {
	String? url;
	String? fullurl;

	UploadFileEntity();

	factory UploadFileEntity.fromJson(Map<String, dynamic> json) => $UploadFileEntityFromJson(json);

	Map<String, dynamic> toJson() => $UploadFileEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}