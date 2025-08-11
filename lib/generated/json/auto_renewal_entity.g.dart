import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/auto_renewal_entity.dart';

AutoRenewalEntity $AutoRenewalEntityFromJson(Map<String, dynamic> json) {
  final AutoRenewalEntity autoRenewalEntity = AutoRenewalEntity();
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    autoRenewalEntity.status = status;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    autoRenewalEntity.createtime = createtime;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    autoRenewalEntity.mobile = mobile;
  }
  return autoRenewalEntity;
}

Map<String, dynamic> $AutoRenewalEntityToJson(AutoRenewalEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  data['createtime'] = entity.createtime;
  data['mobile'] = entity.mobile;
  return data;
}

extension AutoRenewalEntityExtension on AutoRenewalEntity {
  AutoRenewalEntity copyWith({
    int? status,
    String? createtime,
    String? mobile,
  }) {
    return AutoRenewalEntity()
      ..status = status ?? this.status
      ..createtime = createtime ?? this.createtime
      ..mobile = mobile ?? this.mobile;
  }
}