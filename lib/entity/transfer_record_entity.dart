import 'package:desk_cloud/generated/json/base/json_field.dart';
import 'package:desk_cloud/generated/json/transfer_record_entity.g.dart';
import 'dart:convert';
export 'package:desk_cloud/generated/json/transfer_record_entity.g.dart';

@JsonSerializable()
class TransferRecordEntity {
	List<TransferRecordList>? list;
	int? total;
	TransferRecordReport? report;

	TransferRecordEntity();

	factory TransferRecordEntity.fromJson(Map<String, dynamic> json) => $TransferRecordEntityFromJson(json);

	Map<String, dynamic> toJson() => $TransferRecordEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class TransferRecordList {
	String? title;
	int? id;
	@JSONField(name: "status_local")
	int? statusLocal;
	String? createtime;
	@JSONField(name: "is_dir")
	int? isDir;
	@JSONField(name: "file_type")
	int? fileType;
	@JSONField(name: "data_type")
	int? dataType;

	TransferRecordList();

	factory TransferRecordList.fromJson(Map<String, dynamic> json) => $TransferRecordListFromJson(json);

	Map<String, dynamic> toJson() => $TransferRecordListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class TransferRecordReport {
	@JSONField(name: "total_1")
	int? total1;
	@JSONField(name: "total_2")
	int? total2;
	@JSONField(name: "total_3")
	int? total3;

	TransferRecordReport();

	factory TransferRecordReport.fromJson(Map<String, dynamic> json) => $TransferRecordReportFromJson(json);

	Map<String, dynamic> toJson() => $TransferRecordReportToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}