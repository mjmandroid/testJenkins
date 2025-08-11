import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/app_version_entity.dart';

AppVersionEntity $AppVersionEntityFromJson(Map<String, dynamic> json) {
  final AppVersionEntity appVersionEntity = AppVersionEntity();
  final String? newversion = jsonConvert.convert<String>(json['newversion']);
  if (newversion != null) {
    appVersionEntity.newversion = newversion;
  }
  final String? packagesize = jsonConvert.convert<String>(json['packagesize']);
  if (packagesize != null) {
    appVersionEntity.packagesize = packagesize;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    appVersionEntity.content = content;
  }
  final String? downloadurl = jsonConvert.convert<String>(json['downloadurl']);
  if (downloadurl != null) {
    appVersionEntity.downloadurl = downloadurl;
  }
  final int? enforce = jsonConvert.convert<int>(json['enforce']);
  if (enforce != null) {
    appVersionEntity.enforce = enforce;
  }
  final int? createtime = jsonConvert.convert<int>(json['createtime']);
  if (createtime != null) {
    appVersionEntity.createtime = createtime;
  }
  return appVersionEntity;
}

Map<String, dynamic> $AppVersionEntityToJson(AppVersionEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['newversion'] = entity.newversion;
  data['packagesize'] = entity.packagesize;
  data['content'] = entity.content;
  data['downloadurl'] = entity.downloadurl;
  data['enforce'] = entity.enforce;
  data['createtime'] = entity.createtime;
  return data;
}

extension AppVersionEntityExtension on AppVersionEntity {
  AppVersionEntity copyWith({
    String? newversion,
    String? packagesize,
    String? content,
    String? downloadurl,
    int? enforce,
    int? createtime,
  }) {
    return AppVersionEntity()
      ..newversion = newversion ?? this.newversion
      ..packagesize = packagesize ?? this.packagesize
      ..content = content ?? this.content
      ..downloadurl = downloadurl ?? this.downloadurl
      ..enforce = enforce ?? this.enforce
      ..createtime = createtime ?? this.createtime;
  }
}