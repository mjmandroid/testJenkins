
import 'dart:convert';
import 'package:desk_cloud/generated/json/guest_cool_down_entity.g.dart';
export 'package:desk_cloud/generated/json/guest_cool_down_entity.g.dart';
import 'package:desk_cloud/generated/json/base/json_field.dart';

@JsonSerializable()
class GuestCoolDownEntity{
  @JSONField(name: "guest_cooldown_time")
  String? guest_cooldown_time = "";

  GuestCoolDownEntity();

  factory GuestCoolDownEntity.fromJson(Map<String, dynamic> json) => $GuestCoolDownEntityFromJson(json);

  Map<String, dynamic> toJson() => $GuestCoolDownEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}