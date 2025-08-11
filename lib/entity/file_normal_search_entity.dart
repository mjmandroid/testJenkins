import 'package:desk_cloud/entity/disk_file_entity.dart';

class FileNormalSearchEntity{
  DiskFileEntity diskFile;
  Map<String,dynamic>? searchMap;
  FileNormalSearchEntity(this.diskFile,{this.searchMap});
}