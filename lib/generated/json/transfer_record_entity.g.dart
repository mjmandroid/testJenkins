import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/transfer_record_entity.dart';

TransferRecordEntity $TransferRecordEntityFromJson(Map<String, dynamic> json) {
  final TransferRecordEntity transferRecordEntity = TransferRecordEntity();
  final List<TransferRecordList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<TransferRecordList>(e) as TransferRecordList)
      .toList();
  if (list != null) {
    transferRecordEntity.list = list;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    transferRecordEntity.total = total;
  }
  final TransferRecordReport? report = jsonConvert.convert<
      TransferRecordReport>(json['report']);
  if (report != null) {
    transferRecordEntity.report = report;
  }
  return transferRecordEntity;
}

Map<String, dynamic> $TransferRecordEntityToJson(TransferRecordEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['total'] = entity.total;
  data['report'] = entity.report?.toJson();
  return data;
}

extension TransferRecordEntityExtension on TransferRecordEntity {
  TransferRecordEntity copyWith({
    List<TransferRecordList>? list,
    int? total,
    TransferRecordReport? report,
  }) {
    return TransferRecordEntity()
      ..list = list ?? this.list
      ..total = total ?? this.total
      ..report = report ?? this.report;
  }
}

TransferRecordList $TransferRecordListFromJson(Map<String, dynamic> json) {
  final TransferRecordList transferRecordList = TransferRecordList();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    transferRecordList.title = title;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    transferRecordList.id = id;
  }
  final int? statusLocal = jsonConvert.convert<int>(json['status_local']);
  if (statusLocal != null) {
    transferRecordList.statusLocal = statusLocal;
  }
  final String? createtime = jsonConvert.convert<String>(json['createtime']);
  if (createtime != null) {
    transferRecordList.createtime = createtime;
  }
  final int? isDir = jsonConvert.convert<int>(json['is_dir']);
  if (isDir != null) {
    transferRecordList.isDir = isDir;
  }
  final int? fileType = jsonConvert.convert<int>(json['file_type']);
  if (fileType != null) {
    transferRecordList.fileType = fileType;
  }
  final int? dataType = jsonConvert.convert<int>(json['data_type']);
  if (dataType != null) {
    transferRecordList.dataType = dataType;
  }
  return transferRecordList;
}

Map<String, dynamic> $TransferRecordListToJson(TransferRecordList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['id'] = entity.id;
  data['status_local'] = entity.statusLocal;
  data['createtime'] = entity.createtime;
  data['is_dir'] = entity.isDir;
  data['file_type'] = entity.fileType;
  data['data_type'] = entity.dataType;
  return data;
}

extension TransferRecordListExtension on TransferRecordList {
  TransferRecordList copyWith({
    String? title,
    int? id,
    int? statusLocal,
    String? createtime,
    int? isDir,
    int? fileType,
    int? dataType,
  }) {
    return TransferRecordList()
      ..title = title ?? this.title
      ..id = id ?? this.id
      ..statusLocal = statusLocal ?? this.statusLocal
      ..createtime = createtime ?? this.createtime
      ..isDir = isDir ?? this.isDir
      ..fileType = fileType ?? this.fileType
      ..dataType = dataType ?? this.dataType;
  }
}

TransferRecordReport $TransferRecordReportFromJson(Map<String, dynamic> json) {
  final TransferRecordReport transferRecordReport = TransferRecordReport();
  final int? total1 = jsonConvert.convert<int>(json['total_1']);
  if (total1 != null) {
    transferRecordReport.total1 = total1;
  }
  final int? total2 = jsonConvert.convert<int>(json['total_2']);
  if (total2 != null) {
    transferRecordReport.total2 = total2;
  }
  final int? total3 = jsonConvert.convert<int>(json['total_3']);
  if (total3 != null) {
    transferRecordReport.total3 = total3;
  }
  return transferRecordReport;
}

Map<String, dynamic> $TransferRecordReportToJson(TransferRecordReport entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total_1'] = entity.total1;
  data['total_2'] = entity.total2;
  data['total_3'] = entity.total3;
  return data;
}

extension TransferRecordReportExtension on TransferRecordReport {
  TransferRecordReport copyWith({
    int? total1,
    int? total2,
    int? total3,
  }) {
    return TransferRecordReport()
      ..total1 = total1 ?? this.total1
      ..total2 = total2 ?? this.total2
      ..total3 = total3 ?? this.total3;
  }
}