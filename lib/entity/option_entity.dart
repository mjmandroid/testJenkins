import 'dart:ui';

import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/option_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/option_entity.g.dart';

@JsonSerializable()
class OptionEntity {
	String? title;
	String? icon;
	String? activeIcon;
	@JSONField(serialize: false,deserialize: false)
	Color? color;
	@JSONField(serialize: false,deserialize: false)
	Color? activeColor;
	dynamic extra;
	int? count;
	String? subTitle;
	dynamic value;
	dynamic action;

	OptionEntity();

	factory OptionEntity.fromJson(Map<String, dynamic> json) => $OptionEntityFromJson(json);

	Map<String, dynamic> toJson() => $OptionEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}