import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'dart:ui';


OptionEntity $OptionEntityFromJson(Map<String, dynamic> json) {
  final OptionEntity optionEntity = OptionEntity();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    optionEntity.title = title;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    optionEntity.icon = icon;
  }
  final String? activeIcon = jsonConvert.convert<String>(json['activeIcon']);
  if (activeIcon != null) {
    optionEntity.activeIcon = activeIcon;
  }
  final dynamic extra = json['extra'];
  if (extra != null) {
    optionEntity.extra = extra;
  }
  final int? count = jsonConvert.convert<int>(json['count']);
  if (count != null) {
    optionEntity.count = count;
  }
  final String? subTitle = jsonConvert.convert<String>(json['subTitle']);
  if (subTitle != null) {
    optionEntity.subTitle = subTitle;
  }
  final dynamic value = json['value'];
  if (value != null) {
    optionEntity.value = value;
  }
  final dynamic action = json['action'];
  if (action != null) {
    optionEntity.action = action;
  }
  return optionEntity;
}

Map<String, dynamic> $OptionEntityToJson(OptionEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['icon'] = entity.icon;
  data['activeIcon'] = entity.activeIcon;
  data['extra'] = entity.extra;
  data['count'] = entity.count;
  data['subTitle'] = entity.subTitle;
  data['value'] = entity.value;
  data['action'] = entity.action;
  return data;
}

extension OptionEntityExtension on OptionEntity {
  OptionEntity copyWith({
    String? title,
    String? icon,
    String? activeIcon,
    Color? color,
    Color? activeColor,
    dynamic extra,
    int? count,
    String? subTitle,
    dynamic value,
    dynamic action,
  }) {
    return OptionEntity()
      ..title = title ?? this.title
      ..icon = icon ?? this.icon
      ..activeIcon = activeIcon ?? this.activeIcon
      ..color = color ?? this.color
      ..activeColor = activeColor ?? this.activeColor
      ..extra = extra ?? this.extra
      ..count = count ?? this.count
      ..subTitle = subTitle ?? this.subTitle
      ..value = value ?? this.value
      ..action = action ?? this.action;
  }
}