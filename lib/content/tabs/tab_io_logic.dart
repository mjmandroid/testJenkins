import 'dart:async';

import 'package:desk_cloud/alert/unzip_normal_dialog.dart';
import 'package:desk_cloud/content/io/io_parent_logic.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/entity/transfer_record_entity.dart';
import 'package:desk_cloud/entity/unzip_progress_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/io_option/io_option_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:realm/realm.dart';

class TabIoLogic extends BaseLogic{
  final currentIndex = 0.obs;
  final offset = 0.0.obs;
  var downloadingCount = 0.obs;
  var uploadingCount = 0.obs;
  var unzipingCount = 0.obs;
  var unzipAllCount = 0.obs;
  /// 解压进度
  var unzipProgressMap = {}.obs;
  /// 是否已退出解压进度页面
  var unzipIsPopPage = false;
  /// 解压轮询
  Timer? unzipTimer;

  final pageC = PageController();

  var ioDates = <IoDataResoult>[].obs;

  final images = ['png', 'jpg', 'jpeg', 'gif', 'heic'];
  final videos = ['avi', 'mp4', 'mov', 'mkv', 'rm', 'ogg', 'webm', 'm3u8', '3gp', 'flv'];
  final zips = ['zip', 'rar', '7z', 'tar', 'gz', 'bz2', 'xz', 'zipx', 'war', 'jar', 'ear'];

  @override
  void onInit() {
    super.onInit();
    if (oss.uploadTaskList.value.isEmpty) {
      oss.uploadTaskList.value = oss.realm.query<FileIoDataRM>(r'type == $0 AND userId == $1 SORT(startTime desc)',[0, user.memberEquity.value?.id ?? 0]);
    }
    if (oss.downloadTaskList.value.isEmpty) {
      oss.downloadTaskList.value = oss.realm.query<FileIoDataRM>(r'type == $0 AND userId == $1 SORT(startTime desc)',[1, user.memberEquity.value?.id ?? 0]);
    }
    pageC.addListener(() {
      offset.value = pageC.page ?? 0;
      currentIndex.value = (pageC.page ?? .0).round();
      tabParentLogic.ioOption?.hidden();
      hiddenCallback();
    });
    downloadingCount.value = oss.downloadTaskList.value.query(r'status == 0 || status == 1 || status == 2').length;
    uploadingCount.value = oss.uploadTaskList.value.query(r'status == 0 || status == 1 || status == 2').length;
    ever(oss.downloadTaskList, (callback) {
      downloadingCount.value = oss.downloadTaskList.value.query(r'status == 0 || status == 1 || status == 2').length;
    });
    ever(oss.uploadTaskList, (callback) {
      uploadingCount.value = oss.uploadTaskList.value.query(r'status == 0 || status == 1 || status == 2').length;
    });
    geTransferRecord();
  }

  selectedChange()async{
    find<TabParentLogic>()?.ioOption?.addSelectedCallback(_totalSelectedCallback);
    find<TabParentLogic>()?.ioOption?.addHiddenCallback(hiddenCallback);
    find<TabParentLogic>()?.ioOption?.show(ioDates.where(((element) => element.isSelected == true)));
    find<TabParentLogic>()?.ioOption?.totalSelected = ioDates.where((element) => element.isSelected != true).isEmpty == true;
    ioDates.refresh();
  }

  _totalSelectedCallback(IoOptionController control,bool isTotal){
    for (var element in ioDates) {
      element.isSelected = isTotal;
    }
    control.totalSelected = isTotal;
    selectedChange();
  }

  hiddenCallback() {
    for (var element in ioDates) {
      element.isSelected = false;
    }
    ioDates.refresh();
  }

  /// 初始化数据
  initIoDates(RealmResults<FileIoDataRM> results) {
    // 创建一个 Map 用于存储现有的 selected 状态
    Map<String, bool> selectedStateMap = {
      for (var item in ioDates)
        if (item.item.isValid) item.item.taskId: item.isSelected
    };
    ioDates.clear();
    ioDates.value = results.map((item) {
      return IoDataResoult(item, isSelected: selectedStateMap[item.taskId] ?? false);
    }).toList();
  }

  geTransferRecord() async {
    try {
      var base = await ApiNet.request<TransferRecordEntity>(Api.transferList, data: {
        'page': 1,
        'pageSize': 1,
        'type': 0
      }); 
      unzipingCount.value = base.data?.report?.total1 ?? 0;
      unzipAllCount.value = base.data?.total ?? 0;
      if (Get.isRegistered<IoParentLogic>(tag: 'IoParentLogic_2')) {
        IoParentLogic ioParentLogic = Get.find<IoParentLogic>(tag: 'IoParentLogic_2');
        ioParentLogic.options[1].count = base.data?.report?.total2 ?? 0;
        ioParentLogic.options[2].count = base.data?.report?.total1 ?? 0;
        ioParentLogic.options[3].count = base.data?.report?.total3 ?? 0;
        ioParentLogic.options.refresh();
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }
  
  getTaskDetail(String taskId) async {
    var taskBase = await ApiNet.request<UnzipProgressEntity>(Api.aliyunGetTaskDetail, data: {'task_id': taskId, 'type': 2}); 
    await geTransferRecord();
    unzipProgressMap[taskId] = taskBase.data!.progress ?? 0;
    if (taskBase.data!.progress! >= 100) {
      oss.refreshUnzipList();
      if (!unzipIsPopPage) {
        unzipIsPopPage = true;
        pop();
      }
    }
    // unzipTimer?.cancel();
    // unzipTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    //   try {
    //     var taskBase = await ApiNet.request<UnzipProgressEntity>(Api.aliyunGetTaskDetail, data: {'task_id': taskId, 'type': 2}); 
    //     await geTransferRecord();
    //     unzipProgressMap[taskId] = taskBase.data!.progress ?? 0;
    //     if (taskBase.data!.progress! >= 100) {
    //       timer.cancel();
    //       await 1.5.delay();
    //       if (!unzipIsPopPage) {
    //         unzipIsPopPage = true;
    //         pop();
    //       }
    //     }
    //   } catch (e) {
    //     timer.cancel();
    //     showShortToast(e.toString());
    //   }
    // });
  }

  /// 是否已经展示弹窗
  bool isShowUnzipNormalDialog = false;

  /// 解压刷新数据
  socketOnUnzip(String taskId, int relationDirId, String title) async {
    try {
      var taskBase = await ApiNet.request<UnzipProgressEntity>(Api.aliyunGetTaskDetail, data: {'task_id': taskId, 'type': 2}); 
      await geTransferRecord();
      unzipProgressMap[taskId] = taskBase.data!.progress ?? 0;
      if (taskBase.data!.progress! >= 100) {
        oss.refreshUnzipList();
        tabParentLogic.refreshFileHome();
        await 1.5.delay();
        if (!unzipIsPopPage) {
          unzipIsPopPage = true;
          pop();
        }
        if (!isShowUnzipNormalDialog) {
          showUnzipNormalDialog();
          isShowUnzipNormalDialog = true;
        }
        unzipNormalDialogLogic.setData(title, relationDirId);
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  @override
  void dispose() {
    unzipTimer?.cancel();
    super.dispose();
  }

}

TabIoLogic get ioLogic {
  if (Get.isRegistered<TabIoLogic>()){
    return Get.find<TabIoLogic>();
  }
  return Get.put(TabIoLogic());
}