import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/cupertino.dart';

class IoParentLogic extends BaseLogic{
  ///type 0下载 1上传 2解压
  final int type;
  IoParentLogic(this.type);

  var uncompressIsEmpty = false.obs;

  final options = [
    OptionEntity()
      ..title = '全部'
      ..value = 0
      ..action = (){

      },
    OptionEntity()
      ..title = '已完成·'
      ..count = 0
      ..value = 2
      ..action = (){

      },
    OptionEntity()
      ..title = '进行中·'
      ..count = 0
      ..value = 1
      ..action = (){

      },
    OptionEntity()
      ..title = '失败任务·'
      ..count = 0
      ..value = 3
      ..action = (){

      },
  ].obs;
  final currentIndex = 0.obs;
  final pageC = PageController();

}