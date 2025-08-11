import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/login_user_entity.dart';

LoginUserEntity $LoginUserEntityFromJson(Map<String, dynamic> json) {
  final LoginUserEntity loginUserEntity = LoginUserEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    loginUserEntity.id = id;
  }
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    loginUserEntity.username = username;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    loginUserEntity.nickname = nickname;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    loginUserEntity.avatar = avatar;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    loginUserEntity.mobile = mobile;
  }
  final int? prevtime = jsonConvert.convert<int>(json['prevtime']);
  if (prevtime != null) {
    loginUserEntity.prevtime = prevtime;
  }
  final int? vipLvl = jsonConvert.convert<int>(json['vip_lvl']);
  if (vipLvl != null) {
    loginUserEntity.vipLvl = vipLvl;
  }
  final int? vipStatus = jsonConvert.convert<int>(json['vip_status']);
  if (vipStatus != null) {
    loginUserEntity.vipStatus = vipStatus;
  }
  final int? roleType = jsonConvert.convert<int>(json['role_type']);
  if (roleType != null) {
    loginUserEntity.roleType = roleType;
  }
  final int? index = jsonConvert.convert<int>(json['index']);
  if (index != null) {
    loginUserEntity.index = index;
  }
  final int? logintime = jsonConvert.convert<int>(json['logintime']);
  if (logintime != null) {
    loginUserEntity.logintime = logintime;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    loginUserEntity.token = token;
  }
  return loginUserEntity;
}

Map<String, dynamic> $LoginUserEntityToJson(LoginUserEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['username'] = entity.username;
  data['nickname'] = entity.nickname;
  data['avatar'] = entity.avatar;
  data['mobile'] = entity.mobile;
  data['prevtime'] = entity.prevtime;
  data['vip_lvl'] = entity.vipLvl;
  data['vip_status'] = entity.vipStatus;
  data['role_type'] = entity.roleType;
  data['index'] = entity.index;
  data['logintime'] = entity.logintime;
  data['token'] = entity.token;
  return data;
}

extension LoginUserEntityExtension on LoginUserEntity {
  LoginUserEntity copyWith({
    int? id,
    String? username,
    String? nickname,
    String? avatar,
    String? mobile,
    int? prevtime,
    int? vipLvl,
    int? vipStatus,
    int? roleType,
    int? index,
    int? logintime,
    String? token,
  }) {
    return LoginUserEntity()
      ..id = id ?? this.id
      ..username = username ?? this.username
      ..nickname = nickname ?? this.nickname
      ..avatar = avatar ?? this.avatar
      ..mobile = mobile ?? this.mobile
      ..prevtime = prevtime ?? this.prevtime
      ..vipLvl = vipLvl ?? this.vipLvl
      ..vipStatus = vipStatus ?? this.vipStatus
      ..roleType = roleType ?? this.roleType
      ..index = index ?? this.index
      ..logintime = logintime ?? this.logintime
      ..token = token ?? this.token;
  }
}