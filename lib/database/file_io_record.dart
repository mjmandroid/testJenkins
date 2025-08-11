import 'package:realm/realm.dart';
part 'file_io_record.g.dart';

@RealmModel()
class _FileIoDataRM {
  late String taskId;
  late int userId;
  late String bucketName;
  late int startTime;
  int? endTime;
  int? type; //0 上传 1 下载
  String? localPath;
  String? ossFileName;
  String? hashMd5;
  String? fileName;
  int? total;
  int? current;
  String? uploadRecordPath;
  String? downloadRecordFile;
  String? mime;
  int? dirId;
  int? speed;
  int status = 0; //0 创建 1 开始 2 暂停 3 完成 4 失败 5 并行暂停（限制并行下载上传数量，当有空闲时，会自动恢复）
  String? thumb;

  /// 是否有密码
  int? hasPasswd = 0;

  /// 文件类型
  int? fileType = 100;

  /// 文件ID
  int? fileId = 0;
}
