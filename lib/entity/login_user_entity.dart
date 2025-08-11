import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/login_user_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/login_user_entity.g.dart';

@JsonSerializable()
class LoginUserEntity {
	int? id;
	String? username;
	String? nickname;
	String? avatar;
	String? mobile;
	int? prevtime;
	@JSONField(name: "vip_lvl")
	int? vipLvl;
	@JSONField(name: "vip_status")
	int? vipStatus;
	@JSONField(name: "role_type")
	int? roleType;
	int? index;
	int? logintime;
	String? token;

	LoginUserEntity();

	factory LoginUserEntity.fromJson(Map<String, dynamic> json) => $LoginUserEntityFromJson(json);

	Map<String, dynamic> toJson() => $LoginUserEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}