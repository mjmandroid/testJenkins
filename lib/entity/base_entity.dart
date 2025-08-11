import 'package:desk_cloud/generated/json/base/json_convert_content.dart';

class BaseEntity<T> {
	int? code;
	String? msg;
	int? timestamp;
	T? data;

	BaseEntity();

	BaseEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null && json['data'] != 'null'){
			if (json['data'] is T){
				data = json['data'];
			}else {
				data = JsonConvert.fromJsonAsT<T>(json['data']);
			}
		}
		code = json['code'];
		msg = json['msg'];
		timestamp = json['timestamp'];
	}
}