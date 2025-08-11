// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_io_record.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class FileIoDataRM extends _FileIoDataRM
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  FileIoDataRM(
    String taskId,
    int userId,
    String bucketName,
    int startTime, {
    int? endTime,
    int? type,
    String? localPath,
    String? ossFileName,
    String? hashMd5,
    String? fileName,
    int? total,
    int? current,
    String? uploadRecordPath,
    String? downloadRecordFile,
    String? mime,
    int? dirId,
    int? speed,
    int status = 0,
    String? thumb,
    int? hasPasswd = 0,
    int? fileType = 100,
    int? fileId = 0,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<FileIoDataRM>({
        'status': 0,
        'hasPasswd': 0,
        'fileType': 100,
        'fileId': 0,
      });
    }
    RealmObjectBase.set(this, 'taskId', taskId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'bucketName', bucketName);
    RealmObjectBase.set(this, 'startTime', startTime);
    RealmObjectBase.set(this, 'endTime', endTime);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'localPath', localPath);
    RealmObjectBase.set(this, 'ossFileName', ossFileName);
    RealmObjectBase.set(this, 'hashMd5', hashMd5);
    RealmObjectBase.set(this, 'fileName', fileName);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'current', current);
    RealmObjectBase.set(this, 'uploadRecordPath', uploadRecordPath);
    RealmObjectBase.set(this, 'downloadRecordFile', downloadRecordFile);
    RealmObjectBase.set(this, 'mime', mime);
    RealmObjectBase.set(this, 'dirId', dirId);
    RealmObjectBase.set(this, 'speed', speed);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'thumb', thumb);
    RealmObjectBase.set(this, 'hasPasswd', hasPasswd);
    RealmObjectBase.set(this, 'fileType', fileType);
    RealmObjectBase.set(this, 'fileId', fileId);
  }

  FileIoDataRM._();

  @override
  String get taskId => RealmObjectBase.get<String>(this, 'taskId') as String;
  @override
  set taskId(String value) => RealmObjectBase.set(this, 'taskId', value);

  @override
  int get userId => RealmObjectBase.get<int>(this, 'userId') as int;
  @override
  set userId(int value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get bucketName =>
      RealmObjectBase.get<String>(this, 'bucketName') as String;
  @override
  set bucketName(String value) =>
      RealmObjectBase.set(this, 'bucketName', value);

  @override
  int get startTime => RealmObjectBase.get<int>(this, 'startTime') as int;
  @override
  set startTime(int value) => RealmObjectBase.set(this, 'startTime', value);

  @override
  int? get endTime => RealmObjectBase.get<int>(this, 'endTime') as int?;
  @override
  set endTime(int? value) => RealmObjectBase.set(this, 'endTime', value);

  @override
  int? get type => RealmObjectBase.get<int>(this, 'type') as int?;
  @override
  set type(int? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get localPath =>
      RealmObjectBase.get<String>(this, 'localPath') as String?;
  @override
  set localPath(String? value) => RealmObjectBase.set(this, 'localPath', value);

  @override
  String? get ossFileName =>
      RealmObjectBase.get<String>(this, 'ossFileName') as String?;
  @override
  set ossFileName(String? value) =>
      RealmObjectBase.set(this, 'ossFileName', value);

  @override
  String? get hashMd5 =>
      RealmObjectBase.get<String>(this, 'hashMd5') as String?;
  @override
  set hashMd5(String? value) => RealmObjectBase.set(this, 'hashMd5', value);

  @override
  String? get fileName =>
      RealmObjectBase.get<String>(this, 'fileName') as String?;
  @override
  set fileName(String? value) => RealmObjectBase.set(this, 'fileName', value);

  @override
  int? get total => RealmObjectBase.get<int>(this, 'total') as int?;
  @override
  set total(int? value) => RealmObjectBase.set(this, 'total', value);

  @override
  int? get current => RealmObjectBase.get<int>(this, 'current') as int?;
  @override
  set current(int? value) => RealmObjectBase.set(this, 'current', value);

  @override
  String? get uploadRecordPath =>
      RealmObjectBase.get<String>(this, 'uploadRecordPath') as String?;
  @override
  set uploadRecordPath(String? value) =>
      RealmObjectBase.set(this, 'uploadRecordPath', value);

  @override
  String? get downloadRecordFile =>
      RealmObjectBase.get<String>(this, 'downloadRecordFile') as String?;
  @override
  set downloadRecordFile(String? value) =>
      RealmObjectBase.set(this, 'downloadRecordFile', value);

  @override
  String? get mime => RealmObjectBase.get<String>(this, 'mime') as String?;
  @override
  set mime(String? value) => RealmObjectBase.set(this, 'mime', value);

  @override
  int? get dirId => RealmObjectBase.get<int>(this, 'dirId') as int?;
  @override
  set dirId(int? value) => RealmObjectBase.set(this, 'dirId', value);

  @override
  int? get speed => RealmObjectBase.get<int>(this, 'speed') as int?;
  @override
  set speed(int? value) => RealmObjectBase.set(this, 'speed', value);

  @override
  int get status => RealmObjectBase.get<int>(this, 'status') as int;
  @override
  set status(int value) => RealmObjectBase.set(this, 'status', value);

  @override
  String? get thumb => RealmObjectBase.get<String>(this, 'thumb') as String?;
  @override
  set thumb(String? value) => RealmObjectBase.set(this, 'thumb', value);

  @override
  int? get hasPasswd => RealmObjectBase.get<int>(this, 'hasPasswd') as int?;
  @override
  set hasPasswd(int? value) => RealmObjectBase.set(this, 'hasPasswd', value);

  @override
  int? get fileType => RealmObjectBase.get<int>(this, 'fileType') as int?;
  @override
  set fileType(int? value) => RealmObjectBase.set(this, 'fileType', value);

  @override
  int? get fileId => RealmObjectBase.get<int>(this, 'fileId') as int?;
  @override
  set fileId(int? value) => RealmObjectBase.set(this, 'fileId', value);

  @override
  Stream<RealmObjectChanges<FileIoDataRM>> get changes =>
      RealmObjectBase.getChanges<FileIoDataRM>(this);

  @override
  FileIoDataRM freeze() => RealmObjectBase.freezeObject<FileIoDataRM>(this);

  @override
  String toString() {
    return '''
FileIoDataRM(
    taskId: $taskId,
    userId: $userId,
    bucketName: $bucketName,
    startTime: $startTime,
    endTime: $endTime,
    type: $type,
    localPath: $localPath,
    ossFileName: $ossFileName,
    hashMd5: $hashMd5,
    fileName: $fileName,
    total: $total,
    current: $current,
    uploadRecordPath: $uploadRecordPath,
    downloadRecordFile: $downloadRecordFile,
    mime: $mime,
    dirId: $dirId,
    speed: $speed,
    status: $status,
    thumb: $thumb,
    hasPasswd: $hasPasswd,
    fileType: $fileType,
    fileId: $fileId,
)''';
  }

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(FileIoDataRM._);
    return SchemaObject(ObjectType.realmObject, FileIoDataRM, 'FileIoDataRM', [
      SchemaProperty('taskId', RealmPropertyType.string),
      SchemaProperty('userId', RealmPropertyType.int),
      SchemaProperty('bucketName', RealmPropertyType.string),
      SchemaProperty('startTime', RealmPropertyType.int),
      SchemaProperty('endTime', RealmPropertyType.int, optional: true),
      SchemaProperty('type', RealmPropertyType.int, optional: true),
      SchemaProperty('localPath', RealmPropertyType.string, optional: true),
      SchemaProperty('ossFileName', RealmPropertyType.string, optional: true),
      SchemaProperty('hashMd5', RealmPropertyType.string, optional: true),
      SchemaProperty('fileName', RealmPropertyType.string, optional: true),
      SchemaProperty('total', RealmPropertyType.int, optional: true),
      SchemaProperty('current', RealmPropertyType.int, optional: true),
      SchemaProperty('uploadRecordPath', RealmPropertyType.string,
          optional: true),
      SchemaProperty('downloadRecordFile', RealmPropertyType.string,
          optional: true),
      SchemaProperty('mime', RealmPropertyType.string, optional: true),
      SchemaProperty('dirId', RealmPropertyType.int, optional: true),
      SchemaProperty('speed', RealmPropertyType.int, optional: true),
      SchemaProperty('status', RealmPropertyType.int),
      SchemaProperty('thumb', RealmPropertyType.string, optional: true),
      SchemaProperty('hasPasswd', RealmPropertyType.int, optional: true),
      SchemaProperty('fileType', RealmPropertyType.int, optional: true),
      SchemaProperty('fileId', RealmPropertyType.int, optional: true),
    ]);
  }
}
