import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/socket_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/socket_entity.g.dart';

@JsonSerializable()
class SocketEntity {
	String? token = '';
	String? server = '';

	SocketEntity();

	factory SocketEntity.fromJson(Map<String, dynamic> json) => $SocketEntityFromJson(json);

	Map<String, dynamic> toJson() => $SocketEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}