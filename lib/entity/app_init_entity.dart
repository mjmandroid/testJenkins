import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/app_init_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/app_init_entity.g.dart';

@JsonSerializable()
class AppInitEntity {
	AppInitAgreement? agreement;
	@JSONField(name: "adv_img")
	List<String>? advImg = [];
	AppInitAbout? about;
	@JSONField(name: "share_params")
	AppInitShareParams? shareParams;
	List<String>? version = [];
	@JSONField(name: "oss_domain")
	String? ossDomain = '';
	AppInitWebview? webview;

	AppInitEntity();

	factory AppInitEntity.fromJson(Map<String, dynamic> json) => $AppInitEntityFromJson(json);

	Map<String, dynamic> toJson() => $AppInitEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AppInitAgreement {
	String? privacy = '';
	String? reg = '';
	String? renew = '';
	String? cancel = '';
	String? service = '';

	AppInitAgreement();

	factory AppInitAgreement.fromJson(Map<String, dynamic> json) => $AppInitAgreementFromJson(json);

	Map<String, dynamic> toJson() => $AppInitAgreementToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AppInitAbout {
	String? beian = '';
	@JSONField(name: "beian_link")
	String? beianLink = '';
	@JSONField(name: "service_phone")
	String? servicePhone = '';
	@JSONField(name: "service_email")
	String? serviceEmail = '';

	AppInitAbout();

	factory AppInitAbout.fromJson(Map<String, dynamic> json) => $AppInitAboutFromJson(json);

	Map<String, dynamic> toJson() => $AppInitAboutToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AppInitShareParams {
	String? desc = '';
	String? logo = '';

	AppInitShareParams();

	factory AppInitShareParams.fromJson(Map<String, dynamic> json) => $AppInitShareParamsFromJson(json);

	Map<String, dynamic> toJson() => $AppInitShareParamsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AppInitWebview {
	String? faq = '';
	AppInitWebviewService? service;

	AppInitWebview();

	factory AppInitWebview.fromJson(Map<String, dynamic> json) => $AppInitWebviewFromJson(json);

	Map<String, dynamic> toJson() => $AppInitWebviewToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AppInitWebviewService {
	int? type = 0;
	String? url = '';
	String? cid = '';

	AppInitWebviewService();

	factory AppInitWebviewService.fromJson(Map<String, dynamic> json) => $AppInitWebviewServiceFromJson(json);

	Map<String, dynamic> toJson() => $AppInitWebviewServiceToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}