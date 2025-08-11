import 'package:desk_cloud/entity/base_list_entity.dart';
import 'package:desk_cloud/entity/recycle_list_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:flutter/material.dart';

import '../../generated/json/base/json_convert_content.dart';

class RecycleBinLogic extends BaseLogic with RefreshHelper {
  
  final sort = 'desc'.obs;
  final recycleList = <RecycleListEntity>[].obs;
  final colun = 0.obs;
  var tabs = <BaseListTypeEnum>[].obs;
  final tabsIndex = 0.obs;
  var showBottonAction = false.obs;

  @override
  onInit() {
    super.onInit();
    onRefresh();
  }

  getRecycleList({bool isShowLoading = false}) async {
    try {
      if (isShowLoading) {
        showLoading();
      }
      var base = await ApiNet.request<BaseListEntity>(Api.getRecycleList, data: {
        'page': page,
        'pageSize': pageSize,
        'type': tabs.isEmpty ? '' : tabs[tabsIndex.value].value,
        'orderby': sort.value
      });
      if (isShowLoading) {
        dismissLoading();
      }
      if (page == 1) {
        recycleList.value = [];
      }
      List<RecycleListEntity> resList = jsonConvert.convertListNotNull<RecycleListEntity>(base.data!.list ?? []) ?? [];
      tabs.value = base.data?.fileEnum?.fileTypeList ?? [];
      recycleList.addAll(resList);
      controller.refreshCompleted();
      if (recycleList.length >= (base.data?.total ?? 0)){
        controller.loadNoData();
      }else{
        controller.loadComplete();
      }
    } catch (e) {
      if (isShowLoading) {
        dismissLoading();
      }
      showShortToast(e.toString());
      controller.refreshFailed();
      controller.loadFailed();
    }
  }

  changeRecycleItemSelected(var item, AnimationController? animationController) {
    item.selected = !item.selected!;
    recycleList.refresh();
    showBottonAction.value = false;
    for (var recycleItem in recycleList) {
      if (recycleItem.selected ?? false) {
        showBottonAction.value = true;
        break;
      } else {
        showBottonAction.value = false;
      }
    }
    if (showBottonAction.value) {
      animationController?.forward();
    } else {
      animationController?.reverse();
    }
  }

  recycle(AnimationController? animationController) async {
    showLoading();
    var ids = '';
    var emptyDirs = [];
    for (var i = 0; i < recycleList.length; i++) {
      var item = recycleList[i];
      if (item.selected ?? false) {
        if (item.fileType == 0 && item.fileCount == 0) {
          emptyDirs.add(item.name);
        } else {
          if (i > 0) {
            ids += ',';
          }
          ids += '${recycleList[i].id}';
        }
      }
    }
    if (ids.isEmpty) {
      dismissLoading();
      if (emptyDirs.isNotEmpty) {
        String tips = emptyDirs.join(',');
        showShortToast('$tips 此文件夹内无子文件，请新建文件夹');
      }
      return;
    }
    try {
      await ApiNet.request(Api.recycleReduction, method: 'post', data: {
          'ids': ids
      });
      if (emptyDirs.isNotEmpty) {
        String tips = emptyDirs.join(',');
        showShortToast('$tips 此文件夹内无子文件，请新建文件夹');
      } else {
        showShortToast('还原成功');
      }
      onRefresh();
      dismissLoading();
      animationController?.reverse();
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
  }

  recycleDel(AnimationController? animationController, {bool delAll = false}) async {
    showLoading();
    var ids = '';
    if (!delAll) {
      for (var i = 0; i < recycleList.length; i++) {
        var item = recycleList[i];
        if (item.selected ?? false) {
          if (i > 0) {
            ids += ',';
          }
          ids += '${recycleList[i].id}';
        }
      }
    } else {
      ids = 'all';
    }
    try {
      await ApiNet.request(Api.recycleDel, data: {
          'ids': ids
      });
      if (delAll) {
        showShortToast('已全部清除所有文件');
      } else {
        showShortToast('删除成功');
      }
      showBottonAction.value = false;
      onRefresh();
      dismissLoading();
      animationController?.reverse();
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
  }

  @override
  void onRefresh() {
    page = 1;
    getRecycleList(isShowLoading: true);
  }

  @override
  void onLoading() {
    page++;
    getRecycleList();
  }

}


RecycleBinLogic get recycleBinLogic {
  if (Get.isRegistered<RecycleBinLogic>()){
    return Get.find<RecycleBinLogic>();
  }
  return Get.put(RecycleBinLogic());
}