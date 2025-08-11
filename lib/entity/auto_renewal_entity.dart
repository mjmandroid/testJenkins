import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/auto_renewal_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/auto_renewal_entity.g.dart';

@JsonSerializable()
class AutoRenewalEntity {
	int? status;
	String? createtime;
	String? mobile;

	AutoRenewalEntity();

	factory AutoRenewalEntity.fromJson(Map<String, dynamic> json) => $AutoRenewalEntityFromJson(json);

	Map<String, dynamic> toJson() => $AutoRenewalEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}