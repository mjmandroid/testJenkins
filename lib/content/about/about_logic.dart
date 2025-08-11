import 'dart:io';

import 'package:desk_cloud/alert/upload_dialog.dart';
import 'package:desk_cloud/entity/app_version_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutLogic extends BaseLogic {

  var versionCode = ''.obs;

  var versionBuildCode = ''.obs;

  final appVersionEntity = Rxn<AppVersionEntity>();

  DownloadInfo? downloadInfo;

  @override
  void onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionCode.value = packageInfo.version;
    versionBuildCode.value = packageInfo.buildNumber;
    downloadListen();
  }

  checkAppVersion({ bool showToast = true }) async {
    // if (downloadInfo != null) {
    //   showShortToast('后台下载中......');
    //   return;
    // }
    try{
      var base = await ApiNet.request<AppVersionEntity>(Api.checkAppVersion);
      if (base.code == 200 && base.data == null) {
        if (showToast) showShortToast('当前已是最新版本');
        return true;        
      }
      appVersionEntity.value = base.data;
      var res = await showUploadDialog(
        message: appVersionEntity.value!.content,
        dismissible: false,
        enforce: appVersionEntity.value?.enforce ?? 0,
        onValueChanged: (res) async {
          final Uri uri = Uri.parse(appVersionEntity.value?.downloadurl ?? '');
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication
            );
          }
        }
      );
      if (res == null || !res) {
        if (appVersionEntity.value?.enforce == 1) {
          // 确保所有资源都被正确释放
          await Future.delayed(const Duration(milliseconds: 100));
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return false;
        } else {
          return true;
        }
      }
      // if (Platform.isAndroid) {
      //   showShortToast('后台下载中......');
      //   await RUpgrade.upgrade(
      //     appVersionEntity.value!.downloadurl!,
      //     fileName: MultiAppConfig.appName,
      //     notificationStyle: NotificationStyle.speech
      //   );
      // }
    }catch(e){
      showShortToast(e.toString());
    }
  }

  downloadListen() {
    if (Platform.isAndroid) {
      RUpgrade.stream.listen((DownloadInfo info) async {
        downloadInfo = info;
      });
    }
  }
  
}

AboutLogic get aboutLogic {
  if (Get.isRegistered<AboutLogic>()){
    return Get.find<AboutLogic>();
  }
  return Get.put(AboutLogic());
}