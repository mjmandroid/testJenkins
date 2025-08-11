import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/member_equity_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/member_equity_entity.g.dart';

@JsonSerializable()
class MemberEquityEntity {
	int? id = 0;
	String? username = '';
	String? nickname = '';
	String? avatar = '';
	String? mobile = '';
	@JSONField(name: "vip_status")
	int? vipStatus = 0;
	@JSONField(name: "vip_lvl")
	int? vipLvl = 0;
	@JSONField(name: "role_type")
	int? roleType = 0;
	int? index = 0;
	int? logintime = 0;
	@JSONField(name: "renew_plan")
	MemberEquityRenewPlan? renewPlan;
	@JSONField(name: "vip_info")
	MemberEquityVipInfo? vipInfo;
	@JSONField(name: "config_info")
	MemberEquityConfigInfo? configInfo;

	MemberEquityEntity();

	factory MemberEquityEntity.fromJson(Map<String, dynamic> json) => $MemberEquityEntityFromJson(json);

	Map<String, dynamic> toJson() => $MemberEquityEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberEquityRenewPlan {
	@JSONField(name: "product_title")
	String? productTitle = '';
	@JSONField(name: "show_money")
	String? showMoney = '';
	@JSONField(name: "sell_money")
	String? sellMoney = '';
	@JSONField(name: "pay_type")
	String? payType = '';
	@JSONField(name: "pay_time")
	String? payTime = '';

	MemberEquityRenewPlan();

	factory MemberEquityRenewPlan.fromJson(Map<String, dynamic> json) => $MemberEquityRenewPlanFromJson(json);

	Map<String, dynamic> toJson() => $MemberEquityRenewPlanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberEquityVipInfo {
	@JSONField(name: "time_begin")
	String? timeBegin = '';
	@JSONField(name: "time_end")
	String? timeEnd = '';
	@JSONField(name: "code_nums")
	int? codeNums = 0;
	@JSONField(name: "max_space")
	String? maxSpace = '';
	@JSONField(name: "max_space_unit")
	String? maxSpaceUnit = '';
	@JSONField(name: "use_space")
	double? useSpace;
	@JSONField(name: "use_space_unit")
	String? useSpaceUnit = '';
	@JSONField(name: "used_rate")
	String? usedRate = '';
	@JSONField(name: "used_rate2")
	String? usedRate2 = '';

	MemberEquityVipInfo();

	factory MemberEquityVipInfo.fromJson(Map<String, dynamic> json) => $MemberEquityVipInfoFromJson(json);

	Map<String, dynamic> toJson() => $MemberEquityVipInfoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberEquityConfigInfo {
	@JSONField(name: "max_upload_size")
	String? maxUploadSize = '';
	@JSONField(name: "max_download_speed")
	String? maxDownloadSpeed = '';
	@JSONField(name: "max_task_download")
	String? maxTaskDownload = '';
	@JSONField(name: "max_task_upload")
	String? maxTaskUpload = '';
	@JSONField(name: "bool_play_online")
	String? boolPlayOnline = '';
	@JSONField(name: "bool_unzip")
	String? boolUnzip = '';
	@JSONField(name: "save_file_days")
	String? saveFileDays = '';
	@JSONField(name: "max_disk")
	String? maxDisk = '';
	@JSONField(name: "recycle_expired_days")
	List<String>? recycleExpiredDays = [];
	@JSONField(name: "code_max_files")
	String? codeMaxFiles = '';
	@JSONField(name: "code_limit_days")
	String? codeLimitDays = '';
	@JSONField(name: "bool_upload_video")
	String? boolUploadVideo = '';
	@JSONField(name: "max_view_video")
	String? maxViewVideo = '';
	@JSONField(name: "share_link_expired_days")
	List<int>? shareLinkExpiredDays = [];
	@JSONField(name: "code_used_days")
	int? codeUsedDays = 0;

	MemberEquityConfigInfo();

	factory MemberEquityConfigInfo.fromJson(Map<String, dynamic> json) => $MemberEquityConfigInfoFromJson(json);

	Map<String, dynamic> toJson() => $MemberEquityConfigInfoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}