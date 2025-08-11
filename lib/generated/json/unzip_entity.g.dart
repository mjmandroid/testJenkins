import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/unzip_entity.dart';

UnzipEntity $UnzipEntityFromJson(Map<String, dynamic> json) {
  final UnzipEntity unzipEntity = UnzipEntity();
  final String? taskId = jsonConvert.convert<String>(json['task_id']);
  if (taskId != null) {
    unzipEntity.taskId = taskId;
  }
  final String? eventId = jsonConvert.convert<String>(json['event_id']);
  if (eventId != null) {
    unzipEntity.eventId = eventId;
  }
  final String? requestId = jsonConvert.convert<String>(json['request_id']);
  if (requestId != null) {
    unzipEntity.requestId = requestId;
  }
  final String? logId = jsonConvert.convert<String>(json['log_id']);
  if (logId != null) {
    unzipEntity.logId = logId;
  }
  final String? projectName = jsonConvert.convert<String>(json['project_name']);
  if (projectName != null) {
    unzipEntity.projectName = projectName;
  }
  final String? bucketDomain = jsonConvert.convert<String>(
      json['bucket_domain']);
  if (bucketDomain != null) {
    unzipEntity.bucketDomain = bucketDomain;
  }
  final String? bucketName = jsonConvert.convert<String>(json['bucket_name']);
  if (bucketName != null) {
    unzipEntity.bucketName = bucketName;
  }
  return unzipEntity;
}

Map<String, dynamic> $UnzipEntityToJson(UnzipEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['task_id'] = entity.taskId;
  data['event_id'] = entity.eventId;
  data['request_id'] = entity.requestId;
  data['log_id'] = entity.logId;
  data['project_name'] = entity.projectName;
  data['bucket_domain'] = entity.bucketDomain;
  data['bucket_name'] = entity.bucketName;
  return data;
}

extension UnzipEntityExtension on UnzipEntity {
  UnzipEntity copyWith({
    String? taskId,
    String? eventId,
    String? requestId,
    String? logId,
    String? projectName,
    String? bucketDomain,
    String? bucketName,
  }) {
    return UnzipEntity()
      ..taskId = taskId ?? this.taskId
      ..eventId = eventId ?? this.eventId
      ..requestId = requestId ?? this.requestId
      ..logId = logId ?? this.logId
      ..projectName = projectName ?? this.projectName
      ..bucketDomain = bucketDomain ?? this.bucketDomain
      ..bucketName = bucketName ?? this.bucketName;
  }
}