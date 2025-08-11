import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/vip_powers_entity.dart';

VipPowersEntity $VipPowersEntityFromJson(Map<String, dynamic> json) {
  final VipPowersEntity vipPowersEntity = VipPowersEntity();
  final VipPowersMaxUploadSize? maxUploadSize = jsonConvert.convert<
      VipPowersMaxUploadSize>(json['max_upload_size']);
  if (maxUploadSize != null) {
    vipPowersEntity.maxUploadSize = maxUploadSize;
  }
  final VipPowersMaxDownloadSpeed? maxDownloadSpeed = jsonConvert.convert<
      VipPowersMaxDownloadSpeed>(json['max_download_speed']);
  if (maxDownloadSpeed != null) {
    vipPowersEntity.maxDownloadSpeed = maxDownloadSpeed;
  }
  final VipPowersMaxTaskDownload? maxTaskDownload = jsonConvert.convert<
      VipPowersMaxTaskDownload>(json['max_task_download']);
  if (maxTaskDownload != null) {
    vipPowersEntity.maxTaskDownload = maxTaskDownload;
  }
  final VipPowersMaxTaskUpload? maxTaskUpload = jsonConvert.convert<
      VipPowersMaxTaskUpload>(json['max_task_upload']);
  if (maxTaskUpload != null) {
    vipPowersEntity.maxTaskUpload = maxTaskUpload;
  }
  final VipPowersBoolPlayOnline? boolPlayOnline = jsonConvert.convert<
      VipPowersBoolPlayOnline>(json['bool_play_online']);
  if (boolPlayOnline != null) {
    vipPowersEntity.boolPlayOnline = boolPlayOnline;
  }
  final VipPowersBoolUnzip? boolUnzip = jsonConvert.convert<VipPowersBoolUnzip>(
      json['bool_unzip']);
  if (boolUnzip != null) {
    vipPowersEntity.boolUnzip = boolUnzip;
  }
  final VipPowersMaxDisk? maxDisk = jsonConvert.convert<VipPowersMaxDisk>(
      json['max_disk']);
  if (maxDisk != null) {
    vipPowersEntity.maxDisk = maxDisk;
  }
  final VipPowersRecycleExpiredDays? recycleExpiredDays = jsonConvert.convert<
      VipPowersRecycleExpiredDays>(json['recycle_expired_days']);
  if (recycleExpiredDays != null) {
    vipPowersEntity.recycleExpiredDays = recycleExpiredDays;
  }
  final VipPowersCodeMaxFiles? codeMaxFiles = jsonConvert.convert<
      VipPowersCodeMaxFiles>(json['code_max_files']);
  if (codeMaxFiles != null) {
    vipPowersEntity.codeMaxFiles = codeMaxFiles;
  }
  final VipPowersCodeLimitDays? codeLimitDays = jsonConvert.convert<
      VipPowersCodeLimitDays>(json['code_limit_days']);
  if (codeLimitDays != null) {
    vipPowersEntity.codeLimitDays = codeLimitDays;
  }
  return vipPowersEntity;
}

Map<String, dynamic> $VipPowersEntityToJson(VipPowersEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['max_upload_size'] = entity.maxUploadSize?.toJson();
  data['max_download_speed'] = entity.maxDownloadSpeed?.toJson();
  data['max_task_download'] = entity.maxTaskDownload?.toJson();
  data['max_task_upload'] = entity.maxTaskUpload?.toJson();
  data['bool_play_online'] = entity.boolPlayOnline?.toJson();
  data['bool_unzip'] = entity.boolUnzip?.toJson();
  data['max_disk'] = entity.maxDisk?.toJson();
  data['recycle_expired_days'] = entity.recycleExpiredDays?.toJson();
  data['code_max_files'] = entity.codeMaxFiles?.toJson();
  data['code_limit_days'] = entity.codeLimitDays?.toJson();
  return data;
}

extension VipPowersEntityExtension on VipPowersEntity {
  VipPowersEntity copyWith({
    VipPowersMaxUploadSize? maxUploadSize,
    VipPowersMaxDownloadSpeed? maxDownloadSpeed,
    VipPowersMaxTaskDownload? maxTaskDownload,
    VipPowersMaxTaskUpload? maxTaskUpload,
    VipPowersBoolPlayOnline? boolPlayOnline,
    VipPowersBoolUnzip? boolUnzip,
    VipPowersMaxDisk? maxDisk,
    VipPowersRecycleExpiredDays? recycleExpiredDays,
    VipPowersCodeMaxFiles? codeMaxFiles,
    VipPowersCodeLimitDays? codeLimitDays,
  }) {
    return VipPowersEntity()
      ..maxUploadSize = maxUploadSize ?? this.maxUploadSize
      ..maxDownloadSpeed = maxDownloadSpeed ?? this.maxDownloadSpeed
      ..maxTaskDownload = maxTaskDownload ?? this.maxTaskDownload
      ..maxTaskUpload = maxTaskUpload ?? this.maxTaskUpload
      ..boolPlayOnline = boolPlayOnline ?? this.boolPlayOnline
      ..boolUnzip = boolUnzip ?? this.boolUnzip
      ..maxDisk = maxDisk ?? this.maxDisk
      ..recycleExpiredDays = recycleExpiredDays ?? this.recycleExpiredDays
      ..codeMaxFiles = codeMaxFiles ?? this.codeMaxFiles
      ..codeLimitDays = codeLimitDays ?? this.codeLimitDays;
  }
}

VipPowersMaxUploadSize $VipPowersMaxUploadSizeFromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxUploadSize vipPowersMaxUploadSize = VipPowersMaxUploadSize();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersMaxUploadSize.name = name;
  }
  final VipPowersMaxUploadSizeVip0? vip0 = jsonConvert.convert<
      VipPowersMaxUploadSizeVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersMaxUploadSize.vip0 = vip0;
  }
  final VipPowersMaxUploadSizeVip1? vip1 = jsonConvert.convert<
      VipPowersMaxUploadSizeVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersMaxUploadSize.vip1 = vip1;
  }
  return vipPowersMaxUploadSize;
}

Map<String, dynamic> $VipPowersMaxUploadSizeToJson(
    VipPowersMaxUploadSize entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersMaxUploadSizeExtension on VipPowersMaxUploadSize {
  VipPowersMaxUploadSize copyWith({
    String? name,
    VipPowersMaxUploadSizeVip0? vip0,
    VipPowersMaxUploadSizeVip1? vip1,
  }) {
    return VipPowersMaxUploadSize()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersMaxUploadSizeVip0 $VipPowersMaxUploadSizeVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxUploadSizeVip0 vipPowersMaxUploadSizeVip0 = VipPowersMaxUploadSizeVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxUploadSizeVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxUploadSizeVip0.showValue = showValue;
  }
  return vipPowersMaxUploadSizeVip0;
}

Map<String, dynamic> $VipPowersMaxUploadSizeVip0ToJson(
    VipPowersMaxUploadSizeVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxUploadSizeVip0Extension on VipPowersMaxUploadSizeVip0 {
  VipPowersMaxUploadSizeVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxUploadSizeVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxUploadSizeVip1 $VipPowersMaxUploadSizeVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxUploadSizeVip1 vipPowersMaxUploadSizeVip1 = VipPowersMaxUploadSizeVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxUploadSizeVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxUploadSizeVip1.showValue = showValue;
  }
  return vipPowersMaxUploadSizeVip1;
}

Map<String, dynamic> $VipPowersMaxUploadSizeVip1ToJson(
    VipPowersMaxUploadSizeVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxUploadSizeVip1Extension on VipPowersMaxUploadSizeVip1 {
  VipPowersMaxUploadSizeVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxUploadSizeVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxDownloadSpeed $VipPowersMaxDownloadSpeedFromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxDownloadSpeed vipPowersMaxDownloadSpeed = VipPowersMaxDownloadSpeed();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersMaxDownloadSpeed.name = name;
  }
  final VipPowersMaxDownloadSpeedVip0? vip0 = jsonConvert.convert<
      VipPowersMaxDownloadSpeedVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersMaxDownloadSpeed.vip0 = vip0;
  }
  final VipPowersMaxDownloadSpeedVip1? vip1 = jsonConvert.convert<
      VipPowersMaxDownloadSpeedVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersMaxDownloadSpeed.vip1 = vip1;
  }
  return vipPowersMaxDownloadSpeed;
}

Map<String, dynamic> $VipPowersMaxDownloadSpeedToJson(
    VipPowersMaxDownloadSpeed entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersMaxDownloadSpeedExtension on VipPowersMaxDownloadSpeed {
  VipPowersMaxDownloadSpeed copyWith({
    String? name,
    VipPowersMaxDownloadSpeedVip0? vip0,
    VipPowersMaxDownloadSpeedVip1? vip1,
  }) {
    return VipPowersMaxDownloadSpeed()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersMaxDownloadSpeedVip0 $VipPowersMaxDownloadSpeedVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxDownloadSpeedVip0 vipPowersMaxDownloadSpeedVip0 = VipPowersMaxDownloadSpeedVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxDownloadSpeedVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxDownloadSpeedVip0.showValue = showValue;
  }
  return vipPowersMaxDownloadSpeedVip0;
}

Map<String, dynamic> $VipPowersMaxDownloadSpeedVip0ToJson(
    VipPowersMaxDownloadSpeedVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxDownloadSpeedVip0Extension on VipPowersMaxDownloadSpeedVip0 {
  VipPowersMaxDownloadSpeedVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxDownloadSpeedVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxDownloadSpeedVip1 $VipPowersMaxDownloadSpeedVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxDownloadSpeedVip1 vipPowersMaxDownloadSpeedVip1 = VipPowersMaxDownloadSpeedVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxDownloadSpeedVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxDownloadSpeedVip1.showValue = showValue;
  }
  return vipPowersMaxDownloadSpeedVip1;
}

Map<String, dynamic> $VipPowersMaxDownloadSpeedVip1ToJson(
    VipPowersMaxDownloadSpeedVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxDownloadSpeedVip1Extension on VipPowersMaxDownloadSpeedVip1 {
  VipPowersMaxDownloadSpeedVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxDownloadSpeedVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxTaskDownload $VipPowersMaxTaskDownloadFromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxTaskDownload vipPowersMaxTaskDownload = VipPowersMaxTaskDownload();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersMaxTaskDownload.name = name;
  }
  final VipPowersMaxTaskDownloadVip0? vip0 = jsonConvert.convert<
      VipPowersMaxTaskDownloadVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersMaxTaskDownload.vip0 = vip0;
  }
  final VipPowersMaxTaskDownloadVip1? vip1 = jsonConvert.convert<
      VipPowersMaxTaskDownloadVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersMaxTaskDownload.vip1 = vip1;
  }
  return vipPowersMaxTaskDownload;
}

Map<String, dynamic> $VipPowersMaxTaskDownloadToJson(
    VipPowersMaxTaskDownload entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersMaxTaskDownloadExtension on VipPowersMaxTaskDownload {
  VipPowersMaxTaskDownload copyWith({
    String? name,
    VipPowersMaxTaskDownloadVip0? vip0,
    VipPowersMaxTaskDownloadVip1? vip1,
  }) {
    return VipPowersMaxTaskDownload()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersMaxTaskDownloadVip0 $VipPowersMaxTaskDownloadVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxTaskDownloadVip0 vipPowersMaxTaskDownloadVip0 = VipPowersMaxTaskDownloadVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxTaskDownloadVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxTaskDownloadVip0.showValue = showValue;
  }
  return vipPowersMaxTaskDownloadVip0;
}

Map<String, dynamic> $VipPowersMaxTaskDownloadVip0ToJson(
    VipPowersMaxTaskDownloadVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxTaskDownloadVip0Extension on VipPowersMaxTaskDownloadVip0 {
  VipPowersMaxTaskDownloadVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxTaskDownloadVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxTaskDownloadVip1 $VipPowersMaxTaskDownloadVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxTaskDownloadVip1 vipPowersMaxTaskDownloadVip1 = VipPowersMaxTaskDownloadVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxTaskDownloadVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxTaskDownloadVip1.showValue = showValue;
  }
  return vipPowersMaxTaskDownloadVip1;
}

Map<String, dynamic> $VipPowersMaxTaskDownloadVip1ToJson(
    VipPowersMaxTaskDownloadVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxTaskDownloadVip1Extension on VipPowersMaxTaskDownloadVip1 {
  VipPowersMaxTaskDownloadVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxTaskDownloadVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxTaskUpload $VipPowersMaxTaskUploadFromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxTaskUpload vipPowersMaxTaskUpload = VipPowersMaxTaskUpload();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersMaxTaskUpload.name = name;
  }
  final VipPowersMaxTaskUploadVip0? vip0 = jsonConvert.convert<
      VipPowersMaxTaskUploadVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersMaxTaskUpload.vip0 = vip0;
  }
  final VipPowersMaxTaskUploadVip1? vip1 = jsonConvert.convert<
      VipPowersMaxTaskUploadVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersMaxTaskUpload.vip1 = vip1;
  }
  return vipPowersMaxTaskUpload;
}

Map<String, dynamic> $VipPowersMaxTaskUploadToJson(
    VipPowersMaxTaskUpload entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersMaxTaskUploadExtension on VipPowersMaxTaskUpload {
  VipPowersMaxTaskUpload copyWith({
    String? name,
    VipPowersMaxTaskUploadVip0? vip0,
    VipPowersMaxTaskUploadVip1? vip1,
  }) {
    return VipPowersMaxTaskUpload()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersMaxTaskUploadVip0 $VipPowersMaxTaskUploadVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxTaskUploadVip0 vipPowersMaxTaskUploadVip0 = VipPowersMaxTaskUploadVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxTaskUploadVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxTaskUploadVip0.showValue = showValue;
  }
  return vipPowersMaxTaskUploadVip0;
}

Map<String, dynamic> $VipPowersMaxTaskUploadVip0ToJson(
    VipPowersMaxTaskUploadVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxTaskUploadVip0Extension on VipPowersMaxTaskUploadVip0 {
  VipPowersMaxTaskUploadVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxTaskUploadVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxTaskUploadVip1 $VipPowersMaxTaskUploadVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersMaxTaskUploadVip1 vipPowersMaxTaskUploadVip1 = VipPowersMaxTaskUploadVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxTaskUploadVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxTaskUploadVip1.showValue = showValue;
  }
  return vipPowersMaxTaskUploadVip1;
}

Map<String, dynamic> $VipPowersMaxTaskUploadVip1ToJson(
    VipPowersMaxTaskUploadVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxTaskUploadVip1Extension on VipPowersMaxTaskUploadVip1 {
  VipPowersMaxTaskUploadVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxTaskUploadVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersBoolPlayOnline $VipPowersBoolPlayOnlineFromJson(
    Map<String, dynamic> json) {
  final VipPowersBoolPlayOnline vipPowersBoolPlayOnline = VipPowersBoolPlayOnline();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersBoolPlayOnline.name = name;
  }
  final VipPowersBoolPlayOnlineVip0? vip0 = jsonConvert.convert<
      VipPowersBoolPlayOnlineVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersBoolPlayOnline.vip0 = vip0;
  }
  final VipPowersBoolPlayOnlineVip1? vip1 = jsonConvert.convert<
      VipPowersBoolPlayOnlineVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersBoolPlayOnline.vip1 = vip1;
  }
  return vipPowersBoolPlayOnline;
}

Map<String, dynamic> $VipPowersBoolPlayOnlineToJson(
    VipPowersBoolPlayOnline entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersBoolPlayOnlineExtension on VipPowersBoolPlayOnline {
  VipPowersBoolPlayOnline copyWith({
    String? name,
    VipPowersBoolPlayOnlineVip0? vip0,
    VipPowersBoolPlayOnlineVip1? vip1,
  }) {
    return VipPowersBoolPlayOnline()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersBoolPlayOnlineVip0 $VipPowersBoolPlayOnlineVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersBoolPlayOnlineVip0 vipPowersBoolPlayOnlineVip0 = VipPowersBoolPlayOnlineVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersBoolPlayOnlineVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersBoolPlayOnlineVip0.showValue = showValue;
  }
  return vipPowersBoolPlayOnlineVip0;
}

Map<String, dynamic> $VipPowersBoolPlayOnlineVip0ToJson(
    VipPowersBoolPlayOnlineVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersBoolPlayOnlineVip0Extension on VipPowersBoolPlayOnlineVip0 {
  VipPowersBoolPlayOnlineVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersBoolPlayOnlineVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersBoolPlayOnlineVip1 $VipPowersBoolPlayOnlineVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersBoolPlayOnlineVip1 vipPowersBoolPlayOnlineVip1 = VipPowersBoolPlayOnlineVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersBoolPlayOnlineVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersBoolPlayOnlineVip1.showValue = showValue;
  }
  return vipPowersBoolPlayOnlineVip1;
}

Map<String, dynamic> $VipPowersBoolPlayOnlineVip1ToJson(
    VipPowersBoolPlayOnlineVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersBoolPlayOnlineVip1Extension on VipPowersBoolPlayOnlineVip1 {
  VipPowersBoolPlayOnlineVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersBoolPlayOnlineVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersBoolUnzip $VipPowersBoolUnzipFromJson(Map<String, dynamic> json) {
  final VipPowersBoolUnzip vipPowersBoolUnzip = VipPowersBoolUnzip();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersBoolUnzip.name = name;
  }
  final VipPowersBoolUnzipVip0? vip0 = jsonConvert.convert<
      VipPowersBoolUnzipVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersBoolUnzip.vip0 = vip0;
  }
  final VipPowersBoolUnzipVip1? vip1 = jsonConvert.convert<
      VipPowersBoolUnzipVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersBoolUnzip.vip1 = vip1;
  }
  return vipPowersBoolUnzip;
}

Map<String, dynamic> $VipPowersBoolUnzipToJson(VipPowersBoolUnzip entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersBoolUnzipExtension on VipPowersBoolUnzip {
  VipPowersBoolUnzip copyWith({
    String? name,
    VipPowersBoolUnzipVip0? vip0,
    VipPowersBoolUnzipVip1? vip1,
  }) {
    return VipPowersBoolUnzip()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersBoolUnzipVip0 $VipPowersBoolUnzipVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersBoolUnzipVip0 vipPowersBoolUnzipVip0 = VipPowersBoolUnzipVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersBoolUnzipVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersBoolUnzipVip0.showValue = showValue;
  }
  return vipPowersBoolUnzipVip0;
}

Map<String, dynamic> $VipPowersBoolUnzipVip0ToJson(
    VipPowersBoolUnzipVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersBoolUnzipVip0Extension on VipPowersBoolUnzipVip0 {
  VipPowersBoolUnzipVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersBoolUnzipVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersBoolUnzipVip1 $VipPowersBoolUnzipVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersBoolUnzipVip1 vipPowersBoolUnzipVip1 = VipPowersBoolUnzipVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersBoolUnzipVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersBoolUnzipVip1.showValue = showValue;
  }
  return vipPowersBoolUnzipVip1;
}

Map<String, dynamic> $VipPowersBoolUnzipVip1ToJson(
    VipPowersBoolUnzipVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersBoolUnzipVip1Extension on VipPowersBoolUnzipVip1 {
  VipPowersBoolUnzipVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersBoolUnzipVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxDisk $VipPowersMaxDiskFromJson(Map<String, dynamic> json) {
  final VipPowersMaxDisk vipPowersMaxDisk = VipPowersMaxDisk();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersMaxDisk.name = name;
  }
  final VipPowersMaxDiskVip0? vip0 = jsonConvert.convert<VipPowersMaxDiskVip0>(
      json['vip_0']);
  if (vip0 != null) {
    vipPowersMaxDisk.vip0 = vip0;
  }
  final VipPowersMaxDiskVip1? vip1 = jsonConvert.convert<VipPowersMaxDiskVip1>(
      json['vip_1']);
  if (vip1 != null) {
    vipPowersMaxDisk.vip1 = vip1;
  }
  return vipPowersMaxDisk;
}

Map<String, dynamic> $VipPowersMaxDiskToJson(VipPowersMaxDisk entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersMaxDiskExtension on VipPowersMaxDisk {
  VipPowersMaxDisk copyWith({
    String? name,
    VipPowersMaxDiskVip0? vip0,
    VipPowersMaxDiskVip1? vip1,
  }) {
    return VipPowersMaxDisk()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersMaxDiskVip0 $VipPowersMaxDiskVip0FromJson(Map<String, dynamic> json) {
  final VipPowersMaxDiskVip0 vipPowersMaxDiskVip0 = VipPowersMaxDiskVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxDiskVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxDiskVip0.showValue = showValue;
  }
  return vipPowersMaxDiskVip0;
}

Map<String, dynamic> $VipPowersMaxDiskVip0ToJson(VipPowersMaxDiskVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxDiskVip0Extension on VipPowersMaxDiskVip0 {
  VipPowersMaxDiskVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxDiskVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersMaxDiskVip1 $VipPowersMaxDiskVip1FromJson(Map<String, dynamic> json) {
  final VipPowersMaxDiskVip1 vipPowersMaxDiskVip1 = VipPowersMaxDiskVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersMaxDiskVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersMaxDiskVip1.showValue = showValue;
  }
  return vipPowersMaxDiskVip1;
}

Map<String, dynamic> $VipPowersMaxDiskVip1ToJson(VipPowersMaxDiskVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersMaxDiskVip1Extension on VipPowersMaxDiskVip1 {
  VipPowersMaxDiskVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersMaxDiskVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersRecycleExpiredDays $VipPowersRecycleExpiredDaysFromJson(
    Map<String, dynamic> json) {
  final VipPowersRecycleExpiredDays vipPowersRecycleExpiredDays = VipPowersRecycleExpiredDays();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersRecycleExpiredDays.name = name;
  }
  final VipPowersRecycleExpiredDaysVip0? vip0 = jsonConvert.convert<
      VipPowersRecycleExpiredDaysVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersRecycleExpiredDays.vip0 = vip0;
  }
  final VipPowersRecycleExpiredDaysVip1? vip1 = jsonConvert.convert<
      VipPowersRecycleExpiredDaysVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersRecycleExpiredDays.vip1 = vip1;
  }
  return vipPowersRecycleExpiredDays;
}

Map<String, dynamic> $VipPowersRecycleExpiredDaysToJson(
    VipPowersRecycleExpiredDays entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersRecycleExpiredDaysExtension on VipPowersRecycleExpiredDays {
  VipPowersRecycleExpiredDays copyWith({
    String? name,
    VipPowersRecycleExpiredDaysVip0? vip0,
    VipPowersRecycleExpiredDaysVip1? vip1,
  }) {
    return VipPowersRecycleExpiredDays()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersRecycleExpiredDaysVip0 $VipPowersRecycleExpiredDaysVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersRecycleExpiredDaysVip0 vipPowersRecycleExpiredDaysVip0 = VipPowersRecycleExpiredDaysVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersRecycleExpiredDaysVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersRecycleExpiredDaysVip0.showValue = showValue;
  }
  return vipPowersRecycleExpiredDaysVip0;
}

Map<String, dynamic> $VipPowersRecycleExpiredDaysVip0ToJson(
    VipPowersRecycleExpiredDaysVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersRecycleExpiredDaysVip0Extension on VipPowersRecycleExpiredDaysVip0 {
  VipPowersRecycleExpiredDaysVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersRecycleExpiredDaysVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersRecycleExpiredDaysVip1 $VipPowersRecycleExpiredDaysVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersRecycleExpiredDaysVip1 vipPowersRecycleExpiredDaysVip1 = VipPowersRecycleExpiredDaysVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersRecycleExpiredDaysVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersRecycleExpiredDaysVip1.showValue = showValue;
  }
  return vipPowersRecycleExpiredDaysVip1;
}

Map<String, dynamic> $VipPowersRecycleExpiredDaysVip1ToJson(
    VipPowersRecycleExpiredDaysVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersRecycleExpiredDaysVip1Extension on VipPowersRecycleExpiredDaysVip1 {
  VipPowersRecycleExpiredDaysVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersRecycleExpiredDaysVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersCodeMaxFiles $VipPowersCodeMaxFilesFromJson(
    Map<String, dynamic> json) {
  final VipPowersCodeMaxFiles vipPowersCodeMaxFiles = VipPowersCodeMaxFiles();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersCodeMaxFiles.name = name;
  }
  final VipPowersCodeMaxFilesVip0? vip0 = jsonConvert.convert<
      VipPowersCodeMaxFilesVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersCodeMaxFiles.vip0 = vip0;
  }
  final VipPowersCodeMaxFilesVip1? vip1 = jsonConvert.convert<
      VipPowersCodeMaxFilesVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersCodeMaxFiles.vip1 = vip1;
  }
  return vipPowersCodeMaxFiles;
}

Map<String, dynamic> $VipPowersCodeMaxFilesToJson(
    VipPowersCodeMaxFiles entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersCodeMaxFilesExtension on VipPowersCodeMaxFiles {
  VipPowersCodeMaxFiles copyWith({
    String? name,
    VipPowersCodeMaxFilesVip0? vip0,
    VipPowersCodeMaxFilesVip1? vip1,
  }) {
    return VipPowersCodeMaxFiles()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersCodeMaxFilesVip0 $VipPowersCodeMaxFilesVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersCodeMaxFilesVip0 vipPowersCodeMaxFilesVip0 = VipPowersCodeMaxFilesVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersCodeMaxFilesVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersCodeMaxFilesVip0.showValue = showValue;
  }
  return vipPowersCodeMaxFilesVip0;
}

Map<String, dynamic> $VipPowersCodeMaxFilesVip0ToJson(
    VipPowersCodeMaxFilesVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersCodeMaxFilesVip0Extension on VipPowersCodeMaxFilesVip0 {
  VipPowersCodeMaxFilesVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersCodeMaxFilesVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersCodeMaxFilesVip1 $VipPowersCodeMaxFilesVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersCodeMaxFilesVip1 vipPowersCodeMaxFilesVip1 = VipPowersCodeMaxFilesVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersCodeMaxFilesVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersCodeMaxFilesVip1.showValue = showValue;
  }
  return vipPowersCodeMaxFilesVip1;
}

Map<String, dynamic> $VipPowersCodeMaxFilesVip1ToJson(
    VipPowersCodeMaxFilesVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersCodeMaxFilesVip1Extension on VipPowersCodeMaxFilesVip1 {
  VipPowersCodeMaxFilesVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersCodeMaxFilesVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersCodeLimitDays $VipPowersCodeLimitDaysFromJson(
    Map<String, dynamic> json) {
  final VipPowersCodeLimitDays vipPowersCodeLimitDays = VipPowersCodeLimitDays();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    vipPowersCodeLimitDays.name = name;
  }
  final VipPowersCodeLimitDaysVip0? vip0 = jsonConvert.convert<
      VipPowersCodeLimitDaysVip0>(json['vip_0']);
  if (vip0 != null) {
    vipPowersCodeLimitDays.vip0 = vip0;
  }
  final VipPowersCodeLimitDaysVip1? vip1 = jsonConvert.convert<
      VipPowersCodeLimitDaysVip1>(json['vip_1']);
  if (vip1 != null) {
    vipPowersCodeLimitDays.vip1 = vip1;
  }
  return vipPowersCodeLimitDays;
}

Map<String, dynamic> $VipPowersCodeLimitDaysToJson(
    VipPowersCodeLimitDays entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['vip_0'] = entity.vip0?.toJson();
  data['vip_1'] = entity.vip1?.toJson();
  return data;
}

extension VipPowersCodeLimitDaysExtension on VipPowersCodeLimitDays {
  VipPowersCodeLimitDays copyWith({
    String? name,
    VipPowersCodeLimitDaysVip0? vip0,
    VipPowersCodeLimitDaysVip1? vip1,
  }) {
    return VipPowersCodeLimitDays()
      ..name = name ?? this.name
      ..vip0 = vip0 ?? this.vip0
      ..vip1 = vip1 ?? this.vip1;
  }
}

VipPowersCodeLimitDaysVip0 $VipPowersCodeLimitDaysVip0FromJson(
    Map<String, dynamic> json) {
  final VipPowersCodeLimitDaysVip0 vipPowersCodeLimitDaysVip0 = VipPowersCodeLimitDaysVip0();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersCodeLimitDaysVip0.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersCodeLimitDaysVip0.showValue = showValue;
  }
  return vipPowersCodeLimitDaysVip0;
}

Map<String, dynamic> $VipPowersCodeLimitDaysVip0ToJson(
    VipPowersCodeLimitDaysVip0 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersCodeLimitDaysVip0Extension on VipPowersCodeLimitDaysVip0 {
  VipPowersCodeLimitDaysVip0 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersCodeLimitDaysVip0()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}

VipPowersCodeLimitDaysVip1 $VipPowersCodeLimitDaysVip1FromJson(
    Map<String, dynamic> json) {
  final VipPowersCodeLimitDaysVip1 vipPowersCodeLimitDaysVip1 = VipPowersCodeLimitDaysVip1();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    vipPowersCodeLimitDaysVip1.value = value;
  }
  final String? showValue = jsonConvert.convert<String>(json['show_value']);
  if (showValue != null) {
    vipPowersCodeLimitDaysVip1.showValue = showValue;
  }
  return vipPowersCodeLimitDaysVip1;
}

Map<String, dynamic> $VipPowersCodeLimitDaysVip1ToJson(
    VipPowersCodeLimitDaysVip1 entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['show_value'] = entity.showValue;
  return data;
}

extension VipPowersCodeLimitDaysVip1Extension on VipPowersCodeLimitDaysVip1 {
  VipPowersCodeLimitDaysVip1 copyWith({
    String? value,
    String? showValue,
  }) {
    return VipPowersCodeLimitDaysVip1()
      ..value = value ?? this.value
      ..showValue = showValue ?? this.showValue;
  }
}