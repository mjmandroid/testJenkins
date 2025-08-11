import 'dart:io';

import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/content/user/socket_logic.dart';
import 'package:desk_cloud/entity/upload_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:realm/realm.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingLogic extends BaseLogic {
  var tempFile = Rx<File?>(null).obs;
  var smsNotice = Rx<bool>(SP.smsNotice);
  var interestNotice = Rx<bool>(SP.interestNotice);

  @override
  void onInit() {
    super.onInit();
  }

  /// 退出登录
  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    const String announcementKey = 'has_shown_agent_announcement';
    await prefs.setBool(announcementKey, false);
    user.loginUser.value = null;
    SP.token = null;
    pushAndRemove(MyRouter.mobileLogin);
    // showLogoutTemp();

    if (Get.isRegistered<TabIoLogic>()) {
      ioLogic.unzipTimer?.cancel();
    }

    // oss.client.cancelAllTask();

    oss.downloadTaskList.value
        .query(r'status == 1 || status == 2 || status == 0 || status == 5')
        .forEach((element) {
      oss.cancelTask(element);
    });

    oss.uploadTaskList.value
        .query(r'status == 1 || status == 2 || status == 0 || status == 5')
        .forEach((element) {
      oss.cancelTask(element);
    });

    tabParentLogic.productController?.dispose();
    tabParentLogic.productController = null;
    tabParentLogic.productAnimation = null;

    /// 退出socket
    socketLogic.forceCloseSocket();
  }

  uploadAvatar(BuildContext context) async {
    var photosPermission =
        await requestMyPhotosPermission(androidPermission: Permission.photos);
    if (!photosPermission) return;

    // ignore: use_build_context_synchronously
    List<AssetEntity>? assetsAvatar = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
            maxAssets: 1, requestType: RequestType.image));
    if (assetsAvatar == null) return;
    AssetEntity entity = assetsAvatar[0];
    final file = await entity.originFile;
    if (file == null) return;
    showLoading();
    File fileToUpload;
    // 判断是否为GIF
    if (file.path.endsWith(".gif")) {
      // 压缩GIF，保留动画帧(未完成)
      fileToUpload = await compressGif(file);
    } else {
      // 对于JPEG或PNG，使用flutter_image_compress进行压缩
      fileToUpload = await compressImage(file);
    }
    try {
      var base = await ApiNet.uploadFile<UploadFileEntity>(
          Api.uploadFile, fileToUpload);
      await ApiNet.request(Api.userEditInfo, data: {'avatar': base.data.url});
      dismissLoading();
      await user.getUserVip();
      showShortToast('修改成功');
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
    return fileToUpload;
  }
}

SettingLogic get settingLogic {
  if (Get.isRegistered<SettingLogic>()) {
    return Get.find<SettingLogic>();
  }
  return Get.put(SettingLogic());
}
