import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:desk_cloud/alert/command_list_sheet.dart';
import 'package:desk_cloud/alert/mobile_file/mobile_file_image_video_sheet.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/entity/base_list_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class TabCommandLogic extends BaseLogic with RefreshHelper {
  final currentCode = Rxn<String>();
  //口令查询结果
  final codeDiskFileList = <DiskFileEntity>[].obs;
  final textC = TextEditingController();
  //提取记录，人为设置一个parent，方便统一
  final rootDir = Rx(DiskFileEntity());
  FileOptionController? get optionC => find<TabParentLogic>()?.optionC;
  late final options = [
    OptionEntity()
      ..icon = R.assetsTypeZip
      ..title = '压缩包zip'
      ..action = () {
        push(MyRouter.fileOnlyList, args: DiskFileType.zip);
      },
    OptionEntity()
      ..icon = R.assetsVideo
      ..title = '视频'
      ..action = () {
        push(MyRouter.fileOnlyList, args: DiskFileType.video);
      },
    OptionEntity()
      ..icon = R.assetsImage
      ..title = '图片'
      ..action = () {
        push(MyRouter.fileOnlyList, args: DiskFileType.image);
      },
    OptionEntity()
      ..icon = R.assetsFile
      ..title = '文档'
      ..action = () {
        push(MyRouter.fileOnlyList, args: DiskFileType.document);
      },
  ];

  late final addOptions = [
    OptionEntity()
      ..icon = R.assetsAddImage
      ..title = '添加图片'
      ..action = () async {
        /// 先获取权限
        var res = await requestMyPhotosPermission(
            androidPermission: Permission.photos);
        if (!res) return;
        showMobileImageVideoSheet(mediumType: MediumType.image);
      },
    OptionEntity()
      ..icon = R.assetsAddVideo
      ..title = '添加视频'
      ..action = () async {
        /// 先获取权限
        var res = await requestMyPhotosPermission(
            androidPermission: Permission.videos);
        if (!res) return;
        showMobileImageVideoSheet(mediumType: MediumType.video);
      },
    OptionEntity()
      ..icon = R.assetsAddFile
      ..title = '添加文件'
      ..action = () async {
        await oss.fileSelectedAciont();
      }
  ];

  final popC = CustomPopupMenuController();

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  requestForRecords() async {
    try {
      var base = await ApiNet.request<BaseListEntity>(Api.diskCodeLogs,
          method: 'get', data: {'page': page, 'pageSize': pageSize});
      rootDir.value.subs ??= [];
      if (page == 1) {
        rootDir.value.subs?.clear();
      }
      rootDir.value.subs?.addAll(jsonConvert
              .convertListNotNull<DiskFileEntity>(base.data?.list ?? []) ??
          []);
      if ((rootDir.value.subs?.length ?? 0) >= (base.data?.total ?? 0)) {
        controller.loadNoData();
      } else {
        controller.loadComplete();
      }
      controller.refreshCompleted();
      rootDir.refresh();
    } catch (e) {
      controller.refreshFailed();
      controller.loadFailed();
      showShortToast(e.toString());
    }
  }

  @override
  void onRefresh() {
    page = 1;
    requestForRecords();
  }

  @override
  void onLoading() {
    page++;
    requestForRecords();
  }

  // getClipboardData()async{
  //   var r = await Clipboard.getData('text/plain');
  //   var data = r?.text;
  //   if (data?.isNotEmpty != true) return;
  //   currentCode.value = data;
  //   getCommandFiles();
  // }

  Future getCommandFiles({DiskFileEntity? file}) async {
    try {
      var base =
          await ApiNet.request<List<DiskFileEntity>>(Api.diskCodeViews, data: {
        'code': currentCode.value,
        'dir_id': file?.id ?? 0,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
      if (file == null) {
        //顶级目录
        codeDiskFileList.clear();
        codeDiskFileList.addAll(base.data ?? []);
        var res = await showCommandListSheet();
        if (res != null && res) {
          textC.text = '';
        }
      } else {
        file.subs = base.data;
        codeDiskFileList.refresh();
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  pickUpAction({String shareCode = ''}) async {
    closeEdit();
    if (textC.text.trim().isEmpty && shareCode.isEmpty) return;
    currentCode.value =
        textC.text.trim().isEmpty ? shareCode : textC.text.trim();
    getCommandFiles();
    tabParentLogic.refreshFileHome();
  }
}

TabCommandLogic get tabCommandLogic {
  if (Get.isRegistered<TabCommandLogic>()) {
    return Get.find<TabCommandLogic>();
  }
  return Get.put(TabCommandLogic());
}
