import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/sts_entity.dart';

StsEntity $StsEntityFromJson(Map<String, dynamic> json) {
  final StsEntity stsEntity = StsEntity();
  final String? accessKeyId = jsonConvert.convert<String>(json['AccessKeyId']);
  if (accessKeyId != null) {
    stsEntity.accessKeyId = accessKeyId;
  }
  final String? accessKeySecret = jsonConvert.convert<String>(
      json['AccessKeySecret']);
  if (accessKeySecret != null) {
    stsEntity.accessKeySecret = accessKeySecret;
  }
  final String? expiration = jsonConvert.convert<String>(json['Expiration']);
  if (expiration != null) {
    stsEntity.expiration = expiration;
  }
  final String? securityToken = jsonConvert.convert<String>(
      json['SecurityToken']);
  if (securityToken != null) {
    stsEntity.securityToken = securityToken;
  }
  final String? endpoint = jsonConvert.convert<String>(json['endpoint']);
  if (endpoint != null) {
    stsEntity.endpoint = endpoint;
  }
  final String? bucket = jsonConvert.convert<String>(json['bucket']);
  if (bucket != null) {
    stsEntity.bucket = bucket;
  }
  return stsEntity;
}

Map<String, dynamic> $StsEntityToJson(StsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['AccessKeyId'] = entity.accessKeyId;
  data['AccessKeySecret'] = entity.accessKeySecret;
  data['Expiration'] = entity.expiration;
  data['SecurityToken'] = entity.securityToken;
  data['endpoint'] = entity.endpoint;
  data['bucket'] = entity.bucket;
  return data;
}

extension StsEntityExtension on StsEntity {
  StsEntity copyWith({
    String? accessKeyId,
    String? accessKeySecret,
    String? expiration,
    String? securityToken,
    String? endpoint,
    String? bucket,
  }) {
    return StsEntity()
      ..accessKeyId = accessKeyId ?? this.accessKeyId
      ..accessKeySecret = accessKeySecret ?? this.accessKeySecret
      ..expiration = expiration ?? this.expiration
      ..securityToken = securityToken ?? this.securityToken
      ..endpoint = endpoint ?? this.endpoint
      ..bucket = bucket ?? this.bucket;
  }
}