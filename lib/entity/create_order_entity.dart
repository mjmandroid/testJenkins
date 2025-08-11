import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/create_order_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/create_order_entity.g.dart';

@JsonSerializable()
class CreateOrderEntity {
	@JSONField(name: "order_sn")
	String? orderSn = '';
	int? gateway = 0;
	@JSONField(name: "pay_sn")
	String? paySn = '';
	@JSONField(name: "pay_token")
	String? payToken = '';
	@JSONField(name: "pay_array")
	CreateOrderPayArray? payArray;
	@JSONField(name: "pay_wechat")
	CreateOrderPayWechat? payWechat;

	CreateOrderEntity();

	factory CreateOrderEntity.fromJson(Map<String, dynamic> json) => $CreateOrderEntityFromJson(json);

	Map<String, dynamic> toJson() => $CreateOrderEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CreateOrderPayArray {
	String? appid = '';
	String? partnerid = '';
	String? prepayid = '';
	String? package = '';
	String? noncestr = '';
	String? timestamp = '';
	String? sign = '';

	CreateOrderPayArray();

	factory CreateOrderPayArray.fromJson(Map<String, dynamic> json) => $CreateOrderPayArrayFromJson(json);

	Map<String, dynamic> toJson() => $CreateOrderPayArrayToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CreateOrderPayWechat {
	String? appid = '';
	int? partnerid = 0;
	@JSONField(name: "pre_entrustweb_id")
	String? preEntrustwebId = '';
	String? noncestr = '';
	int? timestamp = 0;

	CreateOrderPayWechat();

	factory CreateOrderPayWechat.fromJson(Map<String, dynamic> json) => $CreateOrderPayWechatFromJson(json);

	Map<String, dynamic> toJson() => $CreateOrderPayWechatToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}