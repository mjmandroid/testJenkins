import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/prelogin_entity.g.dart';
import 'dart:convert';

enum PreloginType{
  mobileLogin,oneKeyLogin,toMobile,toOneKey,cancel
}

@JsonSerializable()
class PreloginEntity {
  @JSONField(serialize: false,deserialize: false)
  PreloginType type = PreloginType.oneKeyLogin;
  String? mobile;
  String? code;
  String? loginToken;
  
  PreloginEntity();

  factory PreloginEntity.fromJson(Map<String, dynamic> json) => $PreloginEntityFromJson(json);

  Map<String, dynamic> toJson() => $PreloginEntityToJson(this);

  PreloginEntity copyWith({required PreloginType resultType,String? mobile,String? code,String? loginToken}) {
      return PreloginEntity()
        ..code = code ?? this.code
        ..mobile = mobile ?? this.mobile
        ..type = resultType
        ..loginToken = loginToken ?? this.loginToken;
  }
    
  @override
  String toString() {
    return jsonEncode(this);
  }
}