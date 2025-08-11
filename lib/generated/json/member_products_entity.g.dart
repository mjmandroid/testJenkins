import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/member_products_entity.dart';

MemberProductsEntity $MemberProductsEntityFromJson(Map<String, dynamic> json) {
  final MemberProductsEntity memberProductsEntity = MemberProductsEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    memberProductsEntity.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    memberProductsEntity.title = title;
  }
  final String? showPrice = jsonConvert.convert<String>(json['show_price']);
  if (showPrice != null) {
    memberProductsEntity.showPrice = showPrice;
  }
  final String? sellPrice = jsonConvert.convert<String>(json['sell_price']);
  if (sellPrice != null) {
    memberProductsEntity.sellPrice = sellPrice;
  }
  final String? firstPrice = jsonConvert.convert<String>(json['first_price']);
  if (firstPrice != null) {
    memberProductsEntity.firstPrice = firstPrice;
  }
  final String? dayPrices = jsonConvert.convert<String>(json['day_prices']);
  if (dayPrices != null) {
    memberProductsEntity.dayPrices = dayPrices;
  }

  final String? describeTitle = jsonConvert.convert<String>(json['describe_title']);
  if (dayPrices != null) {
    memberProductsEntity.describeTitle = describeTitle;
  }

  final String? giftTitle = jsonConvert.convert<String>(json['gift_title']);
  if (giftTitle != null) {
    memberProductsEntity.giftTitle = giftTitle;
  }

  final String? giftDesc = jsonConvert.convert<String>(json['gift_desc']);
  if (giftDesc != null) {
    memberProductsEntity.giftDesc = giftDesc;
  }

  final String? describe = jsonConvert.convert<String>(json['describe']);
  if (dayPrices != null) {
    memberProductsEntity.describe = describe;
  }
  final String? days = jsonConvert.convert<String>(json['days']);
  if (days != null) {
    memberProductsEntity.days = days;
  }
  final String? label = jsonConvert.convert<String>(json['label']);
  if (label != null) {
    memberProductsEntity.label = label;
  }
  final int? labelId = jsonConvert.convert<int>(json['label_id']);
  if (labelId != null) {
    memberProductsEntity.labelId = labelId;
  }
  final int? isOpen = jsonConvert.convert<int>(json['is_open']);
  if (isOpen != null) {
    memberProductsEntity.isOpen = isOpen;
  }
  final int? autoRenew = jsonConvert.convert<int>(json['auto_renew']);
  if (autoRenew != null) {
    memberProductsEntity.autoRenew = autoRenew;
  }
  final String? relationCode = jsonConvert.convert<String>(
      json['relation_code']);
  if (relationCode != null) {
    memberProductsEntity.relationCode = relationCode;
  }
  final String? paysGateway = jsonConvert.convert<String>(json['pays_gateway']);
  if (paysGateway != null) {
    memberProductsEntity.paysGateway = paysGateway;
  }
  final MemberProductsCoupon? coupon = jsonConvert.convert<
      MemberProductsCoupon>(json['coupon']);
  if (coupon != null) {
    memberProductsEntity.coupon = coupon;
  }
  final String? unitPrice = jsonConvert.convert<String>(json['unit_price']);
  if (unitPrice != null) {
    memberProductsEntity.unitPrice = unitPrice;
  }
  final String? unitPrice2 = jsonConvert.convert<String>(json['unit_price2']);
  if (unitPrice2 != null) {
    memberProductsEntity.unitPrice2 = unitPrice2;
  }
  final List<String>? paysGatewayList = (json['pays_gateway_list'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (paysGatewayList != null) {
    memberProductsEntity.paysGatewayList = paysGatewayList;
  }
  return memberProductsEntity;
}

Map<String, dynamic> $MemberProductsEntityToJson(MemberProductsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['show_price'] = entity.showPrice;
  data['sell_price'] = entity.sellPrice;
  data['first_price'] = entity.firstPrice;
  data['describe_title'] = entity.describeTitle;
  data['gift_title'] = entity.giftTitle;
  data['gift_desc'] = entity.giftDesc;
  String? giftDesc = '';
  data['days'] = entity.days;
  data['label'] = entity.label;
  data['label_id'] = entity.labelId;
  data['auto_renew'] = entity.autoRenew;
  data['relation_code'] = entity.relationCode;
  data['pays_gateway'] = entity.paysGateway;
  data['coupon'] = entity.coupon?.toJson();
  data['unit_price'] = entity.unitPrice;
  data['unit_price2'] = entity.unitPrice2;
  data['pays_gateway_list'] = entity.paysGatewayList;
  return data;
}

extension MemberProductsEntityExtension on MemberProductsEntity {
  MemberProductsEntity copyWith({
    int? id,
    String? title,
    String? showPrice,
    String? sellPrice,
    String? firstPrice,
    String? describeTitle,
    String? days,
    String? label,
    int? labelId,
    int? autoRenew,
    String? relationCode,
    String? paysGateway,
    MemberProductsCoupon? coupon,
    String? unitPrice,
    String? unitPrice2,
    List<String>? paysGatewayList,
  }) {
    return MemberProductsEntity()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..showPrice = showPrice ?? this.showPrice
      ..sellPrice = sellPrice ?? this.sellPrice
      ..firstPrice = firstPrice ?? this.firstPrice
      ..describeTitle = describeTitle ?? this.describeTitle
      ..describe = describe ?? this.describe
      ..days = days ?? this.days
      ..label = label ?? this.label
      ..labelId = labelId ?? this.labelId
      ..autoRenew = autoRenew ?? this.autoRenew
      ..relationCode = relationCode ?? this.relationCode
      ..paysGateway = paysGateway ?? this.paysGateway
      ..coupon = coupon ?? this.coupon
      ..unitPrice = unitPrice ?? this.unitPrice
      ..unitPrice2 = unitPrice2 ?? this.unitPrice2
      ..paysGatewayList = paysGatewayList ?? this.paysGatewayList;
  }
}

MemberProductsCoupon $MemberProductsCouponFromJson(Map<String, dynamic> json) {
  final MemberProductsCoupon memberProductsCoupon = MemberProductsCoupon();
  final String? price = jsonConvert.convert<String>(json['price']);
  if (price != null) {
    memberProductsCoupon.price = price;
  }
  final int? days = jsonConvert.convert<int>(json['days']);
  if (days != null) {
    memberProductsCoupon.days = days;
  }
  return memberProductsCoupon;
}

Map<String, dynamic> $MemberProductsCouponToJson(MemberProductsCoupon entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['days'] = entity.days;
  return data;
}

extension MemberProductsCouponExtension on MemberProductsCoupon {
  MemberProductsCoupon copyWith({
    String? price,
    int? days,
  }) {
    return MemberProductsCoupon()
      ..price = price ?? this.price
      ..days = days ?? this.days;
  }
}