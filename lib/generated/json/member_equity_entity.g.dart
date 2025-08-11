import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/member_equity_entity.dart';

MemberEquityEntity $MemberEquityEntityFromJson(Map<String, dynamic> json) {
  final MemberEquityEntity memberEquityEntity = MemberEquityEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    memberEquityEntity.id = id;
  }
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    memberEquityEntity.username = username;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    memberEquityEntity.nickname = nickname;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    memberEquityEntity.avatar = avatar;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    memberEquityEntity.mobile = mobile;
  }
  final int? vipStatus = jsonConvert.convert<int>(json['vip_status']);
  if (vipStatus != null) {
    memberEquityEntity.vipStatus = vipStatus;
  }
  final int? vipLvl = jsonConvert.convert<int>(json['vip_lvl']);
  if (vipLvl != null) {
    memberEquityEntity.vipLvl = vipLvl;
  }
  final int? roleType = jsonConvert.convert<int>(json['role_type']);
  if (roleType != null) {
    memberEquityEntity.roleType = roleType;
  }
  final int? index = jsonConvert.convert<int>(json['index']);
  if (index != null) {
    memberEquityEntity.index = index;
  }
  final int? logintime = jsonConvert.convert<int>(json['logintime']);
  if (logintime != null) {
    memberEquityEntity.logintime = logintime;
  }
  final MemberEquityRenewPlan? renewPlan = jsonConvert.convert<
      MemberEquityRenewPlan>(json['renew_plan']);
  if (renewPlan != null) {
    memberEquityEntity.renewPlan = renewPlan;
  }
  final MemberEquityVipInfo? vipInfo = jsonConvert.convert<MemberEquityVipInfo>(
      json['vip_info']);
  if (vipInfo != null) {
    memberEquityEntity.vipInfo = vipInfo;
  }
  final MemberEquityConfigInfo? configInfo = jsonConvert.convert<
      MemberEquityConfigInfo>(json['config_info']);
  if (configInfo != null) {
    memberEquityEntity.configInfo = configInfo;
  }
  return memberEquityEntity;
}

Map<String, dynamic> $MemberEquityEntityToJson(MemberEquityEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['username'] = entity.username;
  data['nickname'] = entity.nickname;
  data['avatar'] = entity.avatar;
  data['mobile'] = entity.mobile;
  data['vip_status'] = entity.vipStatus;
  data['vip_lvl'] = entity.vipLvl;
  data['role_type'] = entity.roleType;
  data['index'] = entity.index;
  data['logintime'] = entity.logintime;
  data['renew_plan'] = entity.renewPlan?.toJson();
  data['vip_info'] = entity.vipInfo?.toJson();
  data['config_info'] = entity.configInfo?.toJson();
  return data;
}

extension MemberEquityEntityExtension on MemberEquityEntity {
  MemberEquityEntity copyWith({
    int? id,
    String? username,
    String? nickname,
    String? avatar,
    String? mobile,
    int? vipStatus,
    int? vipLvl,
    int? roleType,
    int? index,
    int? logintime,
    MemberEquityRenewPlan? renewPlan,
    MemberEquityVipInfo? vipInfo,
    MemberEquityConfigInfo? configInfo,
  }) {
    return MemberEquityEntity()
      ..id = id ?? this.id
      ..username = username ?? this.username
      ..nickname = nickname ?? this.nickname
      ..avatar = avatar ?? this.avatar
      ..mobile = mobile ?? this.mobile
      ..vipStatus = vipStatus ?? this.vipStatus
      ..vipLvl = vipLvl ?? this.vipLvl
      ..roleType = roleType ?? this.roleType
      ..index = index ?? this.index
      ..logintime = logintime ?? this.logintime
      ..renewPlan = renewPlan ?? this.renewPlan
      ..vipInfo = vipInfo ?? this.vipInfo
      ..configInfo = configInfo ?? this.configInfo;
  }
}

MemberEquityRenewPlan $MemberEquityRenewPlanFromJson(
    Map<String, dynamic> json) {
  final MemberEquityRenewPlan memberEquityRenewPlan = MemberEquityRenewPlan();
  final String? productTitle = jsonConvert.convert<String>(
      json['product_title']);
  if (productTitle != null) {
    memberEquityRenewPlan.productTitle = productTitle;
  }
  final String? showMoney = jsonConvert.convert<String>(json['show_money']);
  if (showMoney != null) {
    memberEquityRenewPlan.showMoney = showMoney;
  }
  final String? sellMoney = jsonConvert.convert<String>(json['sell_money']);
  if (sellMoney != null) {
    memberEquityRenewPlan.sellMoney = sellMoney;
  }
  final String? payType = jsonConvert.convert<String>(json['pay_type']);
  if (payType != null) {
    memberEquityRenewPlan.payType = payType;
  }
  final String? payTime = jsonConvert.convert<String>(json['pay_time']);
  if (payTime != null) {
    memberEquityRenewPlan.payTime = payTime;
  }
  return memberEquityRenewPlan;
}

Map<String, dynamic> $MemberEquityRenewPlanToJson(
    MemberEquityRenewPlan entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['product_title'] = entity.productTitle;
  data['show_money'] = entity.showMoney;
  data['sell_money'] = entity.sellMoney;
  data['pay_type'] = entity.payType;
  data['pay_time'] = entity.payTime;
  return data;
}

extension MemberEquityRenewPlanExtension on MemberEquityRenewPlan {
  MemberEquityRenewPlan copyWith({
    String? productTitle,
    String? showMoney,
    String? sellMoney,
    String? payType,
    String? payTime,
  }) {
    return MemberEquityRenewPlan()
      ..productTitle = productTitle ?? this.productTitle
      ..showMoney = showMoney ?? this.showMoney
      ..sellMoney = sellMoney ?? this.sellMoney
      ..payType = payType ?? this.payType
      ..payTime = payTime ?? this.payTime;
  }
}

MemberEquityVipInfo $MemberEquityVipInfoFromJson(Map<String, dynamic> json) {
  final MemberEquityVipInfo memberEquityVipInfo = MemberEquityVipInfo();
  final String? timeBegin = jsonConvert.convert<String>(json['time_begin']);
  if (timeBegin != null) {
    memberEquityVipInfo.timeBegin = timeBegin;
  }
  final String? timeEnd = jsonConvert.convert<String>(json['time_end']);
  if (timeEnd != null) {
    memberEquityVipInfo.timeEnd = timeEnd;
  }
  final int? codeNums = jsonConvert.convert<int>(json['code_nums']);
  if (codeNums != null) {
    memberEquityVipInfo.codeNums = codeNums;
  }
  final String? maxSpace = jsonConvert.convert<String>(json['max_space']);
  if (maxSpace != null) {
    memberEquityVipInfo.maxSpace = maxSpace;
  }
  final String? maxSpaceUnit = jsonConvert.convert<String>(
      json['max_space_unit']);
  if (maxSpaceUnit != null) {
    memberEquityVipInfo.maxSpaceUnit = maxSpaceUnit;
  }
  final double? useSpace = jsonConvert.convert<double>(json['use_space']);
  if (useSpace != null) {
    memberEquityVipInfo.useSpace = useSpace;
  }
  final String? useSpaceUnit = jsonConvert.convert<String>(
      json['use_space_unit']);
  if (useSpaceUnit != null) {
    memberEquityVipInfo.useSpaceUnit = useSpaceUnit;
  }
  final String? usedRate = jsonConvert.convert<String>(json['used_rate']);
  if (usedRate != null) {
    memberEquityVipInfo.usedRate = usedRate;
  }
  final String? usedRate2 = jsonConvert.convert<String>(json['used_rate2']);
  if (usedRate2 != null) {
    memberEquityVipInfo.usedRate2 = usedRate2;
  }
  return memberEquityVipInfo;
}

Map<String, dynamic> $MemberEquityVipInfoToJson(MemberEquityVipInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['time_begin'] = entity.timeBegin;
  data['time_end'] = entity.timeEnd;
  data['code_nums'] = entity.codeNums;
  data['max_space'] = entity.maxSpace;
  data['max_space_unit'] = entity.maxSpaceUnit;
  data['use_space'] = entity.useSpace;
  data['use_space_unit'] = entity.useSpaceUnit;
  data['used_rate'] = entity.usedRate;
  data['used_rate2'] = entity.usedRate2;
  return data;
}

extension MemberEquityVipInfoExtension on MemberEquityVipInfo {
  MemberEquityVipInfo copyWith({
    String? timeBegin,
    String? timeEnd,
    int? codeNums,
    String? maxSpace,
    String? maxSpaceUnit,
    double? useSpace,
    String? useSpaceUnit,
    String? usedRate,
    String? usedRate2,
  }) {
    return MemberEquityVipInfo()
      ..timeBegin = timeBegin ?? this.timeBegin
      ..timeEnd = timeEnd ?? this.timeEnd
      ..codeNums = codeNums ?? this.codeNums
      ..maxSpace = maxSpace ?? this.maxSpace
      ..maxSpaceUnit = maxSpaceUnit ?? this.maxSpaceUnit
      ..useSpace = useSpace ?? this.useSpace
      ..useSpaceUnit = useSpaceUnit ?? this.useSpaceUnit
      ..usedRate = usedRate ?? this.usedRate
      ..usedRate2 = usedRate2 ?? this.usedRate2;
  }
}

MemberEquityConfigInfo $MemberEquityConfigInfoFromJson(
    Map<String, dynamic> json) {
  final MemberEquityConfigInfo memberEquityConfigInfo = MemberEquityConfigInfo();
  final String? maxUploadSize = jsonConvert.convert<String>(
      json['max_upload_size']);
  if (maxUploadSize != null) {
    memberEquityConfigInfo.maxUploadSize = maxUploadSize;
  }
  final String? maxDownloadSpeed = jsonConvert.convert<String>(
      json['max_download_speed']);
  if (maxDownloadSpeed != null) {
    memberEquityConfigInfo.maxDownloadSpeed = maxDownloadSpeed;
  }
  final String? maxTaskDownload = jsonConvert.convert<String>(
      json['max_task_download']);
  if (maxTaskDownload != null) {
    memberEquityConfigInfo.maxTaskDownload = maxTaskDownload;
  }
  final String? maxTaskUpload = jsonConvert.convert<String>(
      json['max_task_upload']);
  if (maxTaskUpload != null) {
    memberEquityConfigInfo.maxTaskUpload = maxTaskUpload;
  }
  final String? boolPlayOnline = jsonConvert.convert<String>(
      json['bool_play_online']);
  if (boolPlayOnline != null) {
    memberEquityConfigInfo.boolPlayOnline = boolPlayOnline;
  }
  final String? boolUnzip = jsonConvert.convert<String>(json['bool_unzip']);
  if (boolUnzip != null) {
    memberEquityConfigInfo.boolUnzip = boolUnzip;
  }
  final String? saveFileDays = jsonConvert.convert<String>(
      json['save_file_days']);
  if (saveFileDays != null) {
    memberEquityConfigInfo.saveFileDays = saveFileDays;
  }
  final String? maxDisk = jsonConvert.convert<String>(json['max_disk']);
  if (maxDisk != null) {
    memberEquityConfigInfo.maxDisk = maxDisk;
  }
  final List<
      String>? recycleExpiredDays = (json['recycle_expired_days'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (recycleExpiredDays != null) {
    memberEquityConfigInfo.recycleExpiredDays = recycleExpiredDays;
  }
  final String? codeMaxFiles = jsonConvert.convert<String>(
      json['code_max_files']);
  if (codeMaxFiles != null) {
    memberEquityConfigInfo.codeMaxFiles = codeMaxFiles;
  }
  final String? codeLimitDays = jsonConvert.convert<String>(
      json['code_limit_days']);
  if (codeLimitDays != null) {
    memberEquityConfigInfo.codeLimitDays = codeLimitDays;
  }
  final String? boolUploadVideo = jsonConvert.convert<String>(
      json['bool_upload_video']);
  if (boolUploadVideo != null) {
    memberEquityConfigInfo.boolUploadVideo = boolUploadVideo;
  }
  final String? maxViewVideo = jsonConvert.convert<String>(
      json['max_view_video']);
  if (maxViewVideo != null) {
    memberEquityConfigInfo.maxViewVideo = maxViewVideo;
  }
  final List<
      int>? shareLinkExpiredDays = (json['share_link_expired_days'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<int>(e) as int).toList();
  if (shareLinkExpiredDays != null) {
    memberEquityConfigInfo.shareLinkExpiredDays = shareLinkExpiredDays;
  }
  final int? codeUsedDays = jsonConvert.convert<int>(json['code_used_days']);
  if (codeUsedDays != null) {
    memberEquityConfigInfo.codeUsedDays = codeUsedDays;
  }
  return memberEquityConfigInfo;
}

Map<String, dynamic> $MemberEquityConfigInfoToJson(
    MemberEquityConfigInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['max_upload_size'] = entity.maxUploadSize;
  data['max_download_speed'] = entity.maxDownloadSpeed;
  data['max_task_download'] = entity.maxTaskDownload;
  data['max_task_upload'] = entity.maxTaskUpload;
  data['bool_play_online'] = entity.boolPlayOnline;
  data['bool_unzip'] = entity.boolUnzip;
  data['save_file_days'] = entity.saveFileDays;
  data['max_disk'] = entity.maxDisk;
  data['recycle_expired_days'] = entity.recycleExpiredDays;
  data['code_max_files'] = entity.codeMaxFiles;
  data['code_limit_days'] = entity.codeLimitDays;
  data['bool_upload_video'] = entity.boolUploadVideo;
  data['max_view_video'] = entity.maxViewVideo;
  data['share_link_expired_days'] = entity.shareLinkExpiredDays;
  data['code_used_days'] = entity.codeUsedDays;
  return data;
}

extension MemberEquityConfigInfoExtension on MemberEquityConfigInfo {
  MemberEquityConfigInfo copyWith({
    String? maxUploadSize,
    String? maxDownloadSpeed,
    String? maxTaskDownload,
    String? maxTaskUpload,
    String? boolPlayOnline,
    String? boolUnzip,
    String? saveFileDays,
    String? maxDisk,
    List<String>? recycleExpiredDays,
    String? codeMaxFiles,
    String? codeLimitDays,
    String? boolUploadVideo,
    String? maxViewVideo,
    List<int>? shareLinkExpiredDays,
    int? codeUsedDays,
  }) {
    return MemberEquityConfigInfo()
      ..maxUploadSize = maxUploadSize ?? this.maxUploadSize
      ..maxDownloadSpeed = maxDownloadSpeed ?? this.maxDownloadSpeed
      ..maxTaskDownload = maxTaskDownload ?? this.maxTaskDownload
      ..maxTaskUpload = maxTaskUpload ?? this.maxTaskUpload
      ..boolPlayOnline = boolPlayOnline ?? this.boolPlayOnline
      ..boolUnzip = boolUnzip ?? this.boolUnzip
      ..saveFileDays = saveFileDays ?? this.saveFileDays
      ..maxDisk = maxDisk ?? this.maxDisk
      ..recycleExpiredDays = recycleExpiredDays ?? this.recycleExpiredDays
      ..codeMaxFiles = codeMaxFiles ?? this.codeMaxFiles
      ..codeLimitDays = codeLimitDays ?? this.codeLimitDays
      ..boolUploadVideo = boolUploadVideo ?? this.boolUploadVideo
      ..maxViewVideo = maxViewVideo ?? this.maxViewVideo
      ..shareLinkExpiredDays = shareLinkExpiredDays ?? this.shareLinkExpiredDays
      ..codeUsedDays = codeUsedDays ?? this.codeUsedDays;
  }
}