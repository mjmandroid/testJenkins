import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/prelogin_entity.dart';

PreloginEntity $PreloginEntityFromJson(Map<String, dynamic> json) {
  final PreloginEntity preloginEntity = PreloginEntity();
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    preloginEntity.mobile = mobile;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    preloginEntity.code = code;
  }
  final String? loginToken = jsonConvert.convert<String>(json['loginToken']);
  if (loginToken != null) {
    preloginEntity.loginToken = loginToken;
  }
  return preloginEntity;
}

Map<String, dynamic> $PreloginEntityToJson(PreloginEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['mobile'] = entity.mobile;
  data['code'] = entity.code;
  data['loginToken'] = entity.loginToken;
  return data;
}

extension PreloginEntityExtension on PreloginEntity {
  PreloginEntity copyWith({
    PreloginType? type,
    String? mobile,
    String? code,
    String? loginToken,
  }) {
    return PreloginEntity()
      ..type = type ?? this.type
      ..mobile = mobile ?? this.mobile
      ..code = code ?? this.code
      ..loginToken = loginToken ?? this.loginToken;
  }
}