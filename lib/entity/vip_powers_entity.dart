import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/vip_powers_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/vip_powers_entity.g.dart';

@JsonSerializable()
class VipPowersEntity {
	@JSONField(name: "max_upload_size")
	VipPowersMaxUploadSize? maxUploadSize;
	@JSONField(name: "max_download_speed")
	VipPowersMaxDownloadSpeed? maxDownloadSpeed;
	@JSONField(name: "max_task_download")
	VipPowersMaxTaskDownload? maxTaskDownload;
	@JSONField(name: "max_task_upload")
	VipPowersMaxTaskUpload? maxTaskUpload;
	@JSONField(name: "bool_play_online")
	VipPowersBoolPlayOnline? boolPlayOnline;
	@JSONField(name: "bool_unzip")
	VipPowersBoolUnzip? boolUnzip;
	@JSONField(name: "max_disk")
	VipPowersMaxDisk? maxDisk;
	@JSONField(name: "recycle_expired_days")
	VipPowersRecycleExpiredDays? recycleExpiredDays;
	@JSONField(name: "code_max_files")
	VipPowersCodeMaxFiles? codeMaxFiles;
	@JSONField(name: "code_limit_days")
	VipPowersCodeLimitDays? codeLimitDays;

	VipPowersEntity();

	factory VipPowersEntity.fromJson(Map<String, dynamic> json) => $VipPowersEntityFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxUploadSize {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersMaxUploadSizeVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersMaxUploadSizeVip1? vip1;

	VipPowersMaxUploadSize();

	factory VipPowersMaxUploadSize.fromJson(Map<String, dynamic> json) => $VipPowersMaxUploadSizeFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxUploadSizeToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxUploadSizeVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxUploadSizeVip0();

	factory VipPowersMaxUploadSizeVip0.fromJson(Map<String, dynamic> json) => $VipPowersMaxUploadSizeVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxUploadSizeVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxUploadSizeVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxUploadSizeVip1();

	factory VipPowersMaxUploadSizeVip1.fromJson(Map<String, dynamic> json) => $VipPowersMaxUploadSizeVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxUploadSizeVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxDownloadSpeed {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersMaxDownloadSpeedVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersMaxDownloadSpeedVip1? vip1;

	VipPowersMaxDownloadSpeed();

	factory VipPowersMaxDownloadSpeed.fromJson(Map<String, dynamic> json) => $VipPowersMaxDownloadSpeedFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxDownloadSpeedToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxDownloadSpeedVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxDownloadSpeedVip0();

	factory VipPowersMaxDownloadSpeedVip0.fromJson(Map<String, dynamic> json) => $VipPowersMaxDownloadSpeedVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxDownloadSpeedVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxDownloadSpeedVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxDownloadSpeedVip1();

	factory VipPowersMaxDownloadSpeedVip1.fromJson(Map<String, dynamic> json) => $VipPowersMaxDownloadSpeedVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxDownloadSpeedVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxTaskDownload {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersMaxTaskDownloadVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersMaxTaskDownloadVip1? vip1;

	VipPowersMaxTaskDownload();

	factory VipPowersMaxTaskDownload.fromJson(Map<String, dynamic> json) => $VipPowersMaxTaskDownloadFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxTaskDownloadToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxTaskDownloadVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxTaskDownloadVip0();

	factory VipPowersMaxTaskDownloadVip0.fromJson(Map<String, dynamic> json) => $VipPowersMaxTaskDownloadVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxTaskDownloadVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxTaskDownloadVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxTaskDownloadVip1();

	factory VipPowersMaxTaskDownloadVip1.fromJson(Map<String, dynamic> json) => $VipPowersMaxTaskDownloadVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxTaskDownloadVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxTaskUpload {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersMaxTaskUploadVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersMaxTaskUploadVip1? vip1;

	VipPowersMaxTaskUpload();

	factory VipPowersMaxTaskUpload.fromJson(Map<String, dynamic> json) => $VipPowersMaxTaskUploadFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxTaskUploadToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxTaskUploadVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxTaskUploadVip0();

	factory VipPowersMaxTaskUploadVip0.fromJson(Map<String, dynamic> json) => $VipPowersMaxTaskUploadVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxTaskUploadVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxTaskUploadVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxTaskUploadVip1();

	factory VipPowersMaxTaskUploadVip1.fromJson(Map<String, dynamic> json) => $VipPowersMaxTaskUploadVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxTaskUploadVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersBoolPlayOnline {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersBoolPlayOnlineVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersBoolPlayOnlineVip1? vip1;

	VipPowersBoolPlayOnline();

	factory VipPowersBoolPlayOnline.fromJson(Map<String, dynamic> json) => $VipPowersBoolPlayOnlineFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersBoolPlayOnlineToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersBoolPlayOnlineVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersBoolPlayOnlineVip0();

	factory VipPowersBoolPlayOnlineVip0.fromJson(Map<String, dynamic> json) => $VipPowersBoolPlayOnlineVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersBoolPlayOnlineVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersBoolPlayOnlineVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersBoolPlayOnlineVip1();

	factory VipPowersBoolPlayOnlineVip1.fromJson(Map<String, dynamic> json) => $VipPowersBoolPlayOnlineVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersBoolPlayOnlineVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersBoolUnzip {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersBoolUnzipVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersBoolUnzipVip1? vip1;

	VipPowersBoolUnzip();

	factory VipPowersBoolUnzip.fromJson(Map<String, dynamic> json) => $VipPowersBoolUnzipFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersBoolUnzipToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersBoolUnzipVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersBoolUnzipVip0();

	factory VipPowersBoolUnzipVip0.fromJson(Map<String, dynamic> json) => $VipPowersBoolUnzipVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersBoolUnzipVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersBoolUnzipVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersBoolUnzipVip1();

	factory VipPowersBoolUnzipVip1.fromJson(Map<String, dynamic> json) => $VipPowersBoolUnzipVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersBoolUnzipVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxDisk {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersMaxDiskVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersMaxDiskVip1? vip1;

	VipPowersMaxDisk();

	factory VipPowersMaxDisk.fromJson(Map<String, dynamic> json) => $VipPowersMaxDiskFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxDiskToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxDiskVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxDiskVip0();

	factory VipPowersMaxDiskVip0.fromJson(Map<String, dynamic> json) => $VipPowersMaxDiskVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxDiskVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersMaxDiskVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersMaxDiskVip1();

	factory VipPowersMaxDiskVip1.fromJson(Map<String, dynamic> json) => $VipPowersMaxDiskVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersMaxDiskVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersRecycleExpiredDays {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersRecycleExpiredDaysVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersRecycleExpiredDaysVip1? vip1;

	VipPowersRecycleExpiredDays();

	factory VipPowersRecycleExpiredDays.fromJson(Map<String, dynamic> json) => $VipPowersRecycleExpiredDaysFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersRecycleExpiredDaysToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersRecycleExpiredDaysVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersRecycleExpiredDaysVip0();

	factory VipPowersRecycleExpiredDaysVip0.fromJson(Map<String, dynamic> json) => $VipPowersRecycleExpiredDaysVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersRecycleExpiredDaysVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersRecycleExpiredDaysVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersRecycleExpiredDaysVip1();

	factory VipPowersRecycleExpiredDaysVip1.fromJson(Map<String, dynamic> json) => $VipPowersRecycleExpiredDaysVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersRecycleExpiredDaysVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersCodeMaxFiles {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersCodeMaxFilesVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersCodeMaxFilesVip1? vip1;

	VipPowersCodeMaxFiles();

	factory VipPowersCodeMaxFiles.fromJson(Map<String, dynamic> json) => $VipPowersCodeMaxFilesFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersCodeMaxFilesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersCodeMaxFilesVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersCodeMaxFilesVip0();

	factory VipPowersCodeMaxFilesVip0.fromJson(Map<String, dynamic> json) => $VipPowersCodeMaxFilesVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersCodeMaxFilesVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersCodeMaxFilesVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersCodeMaxFilesVip1();

	factory VipPowersCodeMaxFilesVip1.fromJson(Map<String, dynamic> json) => $VipPowersCodeMaxFilesVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersCodeMaxFilesVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersCodeLimitDays {
	String? name;
	@JSONField(name: "vip_0")
	VipPowersCodeLimitDaysVip0? vip0;
	@JSONField(name: "vip_1")
	VipPowersCodeLimitDaysVip1? vip1;

	VipPowersCodeLimitDays();

	factory VipPowersCodeLimitDays.fromJson(Map<String, dynamic> json) => $VipPowersCodeLimitDaysFromJson(json);

	Map<String, dynamic> toJson() => $VipPowersCodeLimitDaysToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersCodeLimitDaysVip0 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersCodeLimitDaysVip0();

	factory VipPowersCodeLimitDaysVip0.fromJson(Map<String, dynamic> json) => $VipPowersCodeLimitDaysVip0FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersCodeLimitDaysVip0ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VipPowersCodeLimitDaysVip1 {
	String? value;
	@JSONField(name: "show_value")
	String? showValue;

	VipPowersCodeLimitDaysVip1();

	factory VipPowersCodeLimitDaysVip1.fromJson(Map<String, dynamic> json) => $VipPowersCodeLimitDaysVip1FromJson(json);

	Map<String, dynamic> toJson() => $VipPowersCodeLimitDaysVip1ToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}