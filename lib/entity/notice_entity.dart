import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/notice_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/notice_entity.g.dart';

@JsonSerializable()
class NoticeEntity {
	int? id;
	String? title = '';
	String? content = '';
	@JSONField(name: "show_date")
	String? showDate = '';

	NoticeEntity();

	factory NoticeEntity.fromJson(Map<String, dynamic> json) => $NoticeEntityFromJson(json);

	Map<String, dynamic> toJson() => $NoticeEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}