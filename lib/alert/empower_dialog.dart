import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<dynamic> showEmpowerDialog({ required Permission permission, String? title, String? message }){
  return showDialog(context: globalContext, builder: (context){
    return _EmpowerDialogView(permission: permission, title: title ?? '开启相册权限', message: message ?? '相册权限未开启，允许访问所有相册可以享受更好的上传、下载服务，请在设置中开启');
  },barrierDismissible: false);
}

class _EmpowerDialogView extends StatelessWidget {
  final Permission permission;
  const _EmpowerDialogView({ required this.permission, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.w, bottom: 24.w),
        decoration: BoxDecoration(
          borderRadius: 20.borderRadius,
          color: kWhite(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              R.assetsIcQxXc,
              width: 85.w,
              height: 85.w,
            ),
            spaceH(5),
            MyText(
              title,
              size: 18.sp,
              color: kBlack(),
            ),
            spaceH(16),
            MyText(
              message,
              size: 12.sp,
              color: k3(),
              textAlign: TextAlign.center,
            ),
            spaceH(28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                  onTap: () => pop(),
                  width: 112.w,
                  height: 44.w,
                  title: '取消',
                  decoration: BoxDecoration(
                    color: kBlack(0.04),
                    borderRadius: 12.borderRadius
                  ),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kBlack(),
                    fontWeight: FontWeight.bold
                  ),
                ),
                MyButton(
                  onTap: () async {
                    pop();
                    if (Platform.isAndroid && permission == Permission.manageExternalStorage) {
                      var intent = const AndroidIntent(
                        action: 'android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION',
                        data: 'package:com.payne.disk.cloud', // 指定包名
                      );
                      await intent.launch();
                      return;
                    }
                    openAppSettings();
                  },
                  width: 112.w,
                  height: 44.w,
                  title: '去设置',
                  decoration: BoxDecoration(
                    color: k4A83FF(),
                    borderRadius: 12.borderRadius
                  ),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kWhite(),
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

