import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/sts_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/sts_entity.g.dart';

@JsonSerializable()
class StsEntity {
	@JSONField(name: "AccessKeyId")
	String? accessKeyId;
	@JSONField(name: "AccessKeySecret")
	String? accessKeySecret;
	@JSONField(name: "Expiration")
	String? expiration;
	@JSONField(name: "SecurityToken")
	String? securityToken;
	String? endpoint;
	String? bucket;

	StsEntity();

	factory StsEntity.fromJson(Map<String, dynamic> json) => $StsEntityFromJson(json);

	Map<String, dynamic> toJson() => $StsEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}