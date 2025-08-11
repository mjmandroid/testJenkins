import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/create_order_entity.dart';

CreateOrderEntity $CreateOrderEntityFromJson(Map<String, dynamic> json) {
  final CreateOrderEntity createOrderEntity = CreateOrderEntity();
  final String? orderSn = jsonConvert.convert<String>(json['order_sn']);
  if (orderSn != null) {
    createOrderEntity.orderSn = orderSn;
  }
  final int? gateway = jsonConvert.convert<int>(json['gateway']);
  if (gateway != null) {
    createOrderEntity.gateway = gateway;
  }
  final String? paySn = jsonConvert.convert<String>(json['pay_sn']);
  if (paySn != null) {
    createOrderEntity.paySn = paySn;
  }
  final String? payToken = jsonConvert.convert<String>(json['pay_token']);
  if (payToken != null) {
    createOrderEntity.payToken = payToken;
  }
  final CreateOrderPayArray? payArray = jsonConvert.convert<
      CreateOrderPayArray>(json['pay_array']);
  if (payArray != null) {
    createOrderEntity.payArray = payArray;
  }
  final CreateOrderPayWechat? payWechat = jsonConvert.convert<
      CreateOrderPayWechat>(json['pay_wechat']);
  if (payWechat != null) {
    createOrderEntity.payWechat = payWechat;
  }
  return createOrderEntity;
}

Map<String, dynamic> $CreateOrderEntityToJson(CreateOrderEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['order_sn'] = entity.orderSn;
  data['gateway'] = entity.gateway;
  data['pay_sn'] = entity.paySn;
  data['pay_token'] = entity.payToken;
  data['pay_array'] = entity.payArray?.toJson();
  data['pay_wechat'] = entity.payWechat?.toJson();
  return data;
}

extension CreateOrderEntityExtension on CreateOrderEntity {
  CreateOrderEntity copyWith({
    String? orderSn,
    int? gateway,
    String? paySn,
    String? payToken,
    CreateOrderPayArray? payArray,
    CreateOrderPayWechat? payWechat,
  }) {
    return CreateOrderEntity()
      ..orderSn = orderSn ?? this.orderSn
      ..gateway = gateway ?? this.gateway
      ..paySn = paySn ?? this.paySn
      ..payToken = payToken ?? this.payToken
      ..payArray = payArray ?? this.payArray
      ..payWechat = payWechat ?? this.payWechat;
  }
}

CreateOrderPayArray $CreateOrderPayArrayFromJson(Map<String, dynamic> json) {
  final CreateOrderPayArray createOrderPayArray = CreateOrderPayArray();
  final String? appid = jsonConvert.convert<String>(json['appid']);
  if (appid != null) {
    createOrderPayArray.appid = appid;
  }
  final String? partnerid = jsonConvert.convert<String>(json['partnerid']);
  if (partnerid != null) {
    createOrderPayArray.partnerid = partnerid;
  }
  final String? prepayid = jsonConvert.convert<String>(json['prepayid']);
  if (prepayid != null) {
    createOrderPayArray.prepayid = prepayid;
  }
  final String? package = jsonConvert.convert<String>(json['package']);
  if (package != null) {
    createOrderPayArray.package = package;
  }
  final String? noncestr = jsonConvert.convert<String>(json['noncestr']);
  if (noncestr != null) {
    createOrderPayArray.noncestr = noncestr;
  }
  final String? timestamp = jsonConvert.convert<String>(json['timestamp']);
  if (timestamp != null) {
    createOrderPayArray.timestamp = timestamp;
  }
  final String? sign = jsonConvert.convert<String>(json['sign']);
  if (sign != null) {
    createOrderPayArray.sign = sign;
  }
  return createOrderPayArray;
}

Map<String, dynamic> $CreateOrderPayArrayToJson(CreateOrderPayArray entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['appid'] = entity.appid;
  data['partnerid'] = entity.partnerid;
  data['prepayid'] = entity.prepayid;
  data['package'] = entity.package;
  data['noncestr'] = entity.noncestr;
  data['timestamp'] = entity.timestamp;
  data['sign'] = entity.sign;
  return data;
}

extension CreateOrderPayArrayExtension on CreateOrderPayArray {
  CreateOrderPayArray copyWith({
    String? appid,
    String? partnerid,
    String? prepayid,
    String? package,
    String? noncestr,
    String? timestamp,
    String? sign,
  }) {
    return CreateOrderPayArray()
      ..appid = appid ?? this.appid
      ..partnerid = partnerid ?? this.partnerid
      ..prepayid = prepayid ?? this.prepayid
      ..package = package ?? this.package
      ..noncestr = noncestr ?? this.noncestr
      ..timestamp = timestamp ?? this.timestamp
      ..sign = sign ?? this.sign;
  }
}

CreateOrderPayWechat $CreateOrderPayWechatFromJson(Map<String, dynamic> json) {
  final CreateOrderPayWechat createOrderPayWechat = CreateOrderPayWechat();
  final String? appid = jsonConvert.convert<String>(json['appid']);
  if (appid != null) {
    createOrderPayWechat.appid = appid;
  }
  final int? partnerid = jsonConvert.convert<int>(json['partnerid']);
  if (partnerid != null) {
    createOrderPayWechat.partnerid = partnerid;
  }
  final String? preEntrustwebId = jsonConvert.convert<String>(
      json['pre_entrustweb_id']);
  if (preEntrustwebId != null) {
    createOrderPayWechat.preEntrustwebId = preEntrustwebId;
  }
  final String? noncestr = jsonConvert.convert<String>(json['noncestr']);
  if (noncestr != null) {
    createOrderPayWechat.noncestr = noncestr;
  }
  final int? timestamp = jsonConvert.convert<int>(json['timestamp']);
  if (timestamp != null) {
    createOrderPayWechat.timestamp = timestamp;
  }
  return createOrderPayWechat;
}

Map<String, dynamic> $CreateOrderPayWechatToJson(CreateOrderPayWechat entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['appid'] = entity.appid;
  data['partnerid'] = entity.partnerid;
  data['pre_entrustweb_id'] = entity.preEntrustwebId;
  data['noncestr'] = entity.noncestr;
  data['timestamp'] = entity.timestamp;
  return data;
}

extension CreateOrderPayWechatExtension on CreateOrderPayWechat {
  CreateOrderPayWechat copyWith({
    String? appid,
    int? partnerid,
    String? preEntrustwebId,
    String? noncestr,
    int? timestamp,
  }) {
    return CreateOrderPayWechat()
      ..appid = appid ?? this.appid
      ..partnerid = partnerid ?? this.partnerid
      ..preEntrustwebId = preEntrustwebId ?? this.preEntrustwebId
      ..noncestr = noncestr ?? this.noncestr
      ..timestamp = timestamp ?? this.timestamp;
  }
}