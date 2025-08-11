import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/member_products_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/member_products_entity.g.dart';

@JsonSerializable()
class MemberProductsEntity {
	int? id;
	String? title = '';
	@JSONField(name: "show_price")
	String? showPrice = '';
	@JSONField(name: "sell_price")
	String? sellPrice = '';
	@JSONField(name: "first_price")
	String? firstPrice = '';
	@JSONField(name: "day_prices")
	String? dayPrices = '';
	String? days = '';
	String? label = '';
	@JSONField(name: "label_id")
	int? labelId;
	@JSONField(name: "is_open")
	int? isOpen;
	@JSONField(name: "auto_renew")
	int? autoRenew;
	@JSONField(name: "relation_code")
	String? relationCode = '';
	@JSONField(name: "pays_gateway")
	String? paysGateway = '';
	MemberProductsCoupon? coupon;
	@JSONField(name: "unit_price")
	String? unitPrice = '';
	@JSONField(name: "describe_title")
	String? describeTitle = '';
	@JSONField(name: "describe")
	String? describe = '';
	@JSONField(name: "gift_title")
	String? giftTitle = '';
	@JSONField(name: "gift_desc")
	String? giftDesc = '';
	@JSONField(name: "unit_price2")
	String? unitPrice2 = '';
	@JSONField(name: "pays_gateway_list")
	List<String>? paysGatewayList = [];

	MemberProductsEntity();

	factory MemberProductsEntity.fromJson(Map<String, dynamic> json) => $MemberProductsEntityFromJson(json);

	Map<String, dynamic> toJson() => $MemberProductsEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberProductsCoupon {
	String? price = '';
	int? days;

	MemberProductsCoupon();

	factory MemberProductsCoupon.fromJson(Map<String, dynamic> json) => $MemberProductsCouponFromJson(json);

	Map<String, dynamic> toJson() => $MemberProductsCouponToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}