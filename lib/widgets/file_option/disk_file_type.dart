import 'package:desk_cloud/entity/disk_file_entity.dart';

enum DiskFileType{
  //文件类型:0=文件夹,1=图片,2=视频,3=音频,4=txt文件,5=word文件,6=pdf,7=excel,8=压缩包,100=其他
  dir(0),
  image(1,'图片'),
  video(2,'视频'),
  audio(3),
  txt(4),
  word(5),
  pdf(6),
  excel(7),
  zip(8,'压缩包'),
  document(99,'文档'),
  unknown(100)
  ;
  const DiskFileType(this.type,[this.name]);
  final int type;
  final String? name;
}

extension IntOnDiskFileType on int {
  DiskFileType get fileType {
    for (var element in DiskFileType.values) {
      if (element.type == this){
        return element;
      }
    }
    return DiskFileType.unknown;
  }
}

enum FileOptionMode {
  cloud(5),
  local(4),
  recycle(2);
  const FileOptionMode(this.count);
  final int count;
}

enum FileOptionType {
  delete(icon: 'assets/option_delete.png', name: '删除'),
  detail(icon: 'assets/option_detail.png', name: '详情'),
  download(icon: 'assets/option_download.png', name: '下载'),
  move(icon: 'assets/option_move.png', name: '移动'),
  rename(icon: 'assets/option_rename.png', name: '重命名'),
  save(icon: 'assets/option_save.png', name: '保存到本机'),
  share(icon: 'assets/option_share.png', name: '分享'),
  unzip(icon: 'assets/option_unzip.png', name: '解压缩'),
  restore(icon: 'assets/option_restore.png', name: '还原'),
  other(icon: 'assets/option_other.png', name: '其他应用打开'),
  ;
  const FileOptionType({required this.icon, required this.name});

  final String icon;
  final String name;
}

extension CheckDiskFileType on Iterable<DiskFileEntity>{
  bool canOption(FileOptionType option){
    if (length > 1){
      switch(option){
        case FileOptionType.detail:
        case FileOptionType.rename:
        case FileOptionType.save:
        case FileOptionType.unzip:
          return false;
        default:
          return true;
      }
    }else if (isEmpty){
      return false;
    }else{
      final filetype = first.fileType?.fileType ?? DiskFileType.unknown;
      switch(option){
        case FileOptionType.delete:
        case FileOptionType.detail:
        case FileOptionType.download:
        case FileOptionType.move:
        case FileOptionType.rename:
        case FileOptionType.share:
        case FileOptionType.restore:
          return true;
        case FileOptionType.save:
          if ([DiskFileType.image,DiskFileType.audio,DiskFileType.video].contains(filetype)){
            return true;
          }
          return false;
        case FileOptionType.unzip:
          return filetype == DiskFileType.zip;
        default:
          return false;
      }
    }
  }
}