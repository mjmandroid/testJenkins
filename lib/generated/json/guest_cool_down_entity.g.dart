import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/guest_cool_down_entity.dart';

GuestCoolDownEntity $GuestCoolDownEntityFromJson(Map<String, dynamic> json) {
  final GuestCoolDownEntity payEntity = GuestCoolDownEntity();
  final String? status = jsonConvert.convert<String>(json['guest_cooldown_time']);
  if (status != null) {
    payEntity.guest_cooldown_time = status;
  }
  return payEntity;
}

Map<String, dynamic> $GuestCoolDownEntityToJson(GuestCoolDownEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['guest_cooldown_time'] = entity.guest_cooldown_time;
  return data;
}

extension GuestCoolDownEntityExtension on GuestCoolDownEntity {
  GuestCoolDownEntity copyWith({
    String? status,
  }) {
    return GuestCoolDownEntity()
      ..guest_cooldown_time = status ?? this.guest_cooldown_time;
  }
}