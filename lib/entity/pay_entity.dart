import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/pay_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/pay_entity.g.dart';

@JsonSerializable()
class PayEntity {
	int? status;

	PayEntity();

	factory PayEntity.fromJson(Map<String, dynamic> json) => $PayEntityFromJson(json);

	Map<String, dynamic> toJson() => $PayEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}