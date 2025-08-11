import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/pay_entity.dart';

PayEntity $PayEntityFromJson(Map<String, dynamic> json) {
  final PayEntity payEntity = PayEntity();
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    payEntity.status = status;
  }
  return payEntity;
}

Map<String, dynamic> $PayEntityToJson(PayEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  return data;
}

extension PayEntityExtension on PayEntity {
  PayEntity copyWith({
    int? status,
  }) {
    return PayEntity()
      ..status = status ?? this.status;
  }
}