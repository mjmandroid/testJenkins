import 'package:desk_cloud/alert/file_sort_type_sheet.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/cupertino.dart';

class TabFileLogic extends BaseLogic{
  final pageC = PageController();
  final sortType = FileSortType.normal.obs;
  final subSortType = FileSortSubType.desc.obs;
  final tabs = [
    OptionEntity()
      ..title = '全部'
      ..value = '',
    OptionEntity()
      ..title = '我提取的'
      ..value = 2,
    OptionEntity()
      ..title = '我上传的'
      ..value = 1,
  ];
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageC.addListener(() {
      if (currentIndex.value != (pageC.page ?? .0).round()) {
        currentIndex.value = (pageC.page ?? .0).round();
        find<TabParentLogic>()?.optionC?.hidden();
      }
    });
  }

  refreshAllSubLogic()async{
    tabParentLogic.refreshFileHome();
  }
}

TabFileLogic get fileLogic {
  if (Get.isRegistered<TabFileLogic>()){
    return Get.find<TabFileLogic>();
  }
  return Get.put(TabFileLogic());
}