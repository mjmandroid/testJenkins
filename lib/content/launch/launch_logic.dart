import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desk_cloud/alert/privacy_dialog.dart';
import 'package:desk_cloud/content/about/about_logic.dart';
// import 'package:desk_cloud/content/login/mobile_login_page.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/app_config.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/logutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_origin_resources/flutter_origin.dart';
import 'package:jverify/jverify.dart';

class LaunchLogic extends BaseLogic{
  final path = Rxn<String>();
  bool _initAppCalled = false;  // 标记 initApp 是否已调用过

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;  // 添加订阅对象

  @override
  void onInit() async {
    super.onInit();
    EasyLoading.instance
      ..userInteractions = false
      ..dismissOnTap = false;
    FlutterOriginResources.getResourcePath('img_launch').then((value) => path.value = value);
    // 保存订阅对象以便后续取消
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .firstWhere((result) => result != ConnectivityResult.none)
        .asStream()
        .listen((result) async {
      await initApp();
    });
  }

  initApp() async {
    MLogUtil.init();
    if (_initAppCalled) return;  // 如果 initApp 已经执行过，就不再执行
    _initAppCalled = true;
    
    await 0.3.delay();
    var res = await aboutLogic.checkAppVersion(showToast: false);
    if (res == null || !res) return;
    await user.getInitAppData();
    if (!SP.isAgreement){
      var r = await showPrivacyDialog();
      if (r == true){
        SP.isAgreement = true;
        await 0.25.delay();
      }else{
        // 确保所有资源都被正确释放
        await Future.delayed(const Duration(milliseconds: 100));
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return;
      }
    }
    await initOneKeyLogin();
    if (SP.token.isEmpty){
      user.gotoLogin();
      // showNormalLogin();
    }else {
      bool res = await user.getUserVip();
      if (!res) return;
      await memberLogic.getProducts();
      pushAndRemove(MyRouter.home);
    }
  }

  @override
  void onClose() {
    // 使用 try-catch 避免潜在异常
    try {
      _connectivitySubscription?.cancel();  // 取消订阅
      _connectivity.onConnectivityChanged.drain();  // 清理流
    } catch (e) {
      debugPrint('取消网络监听时发生错误: $e');
    }
    super.onClose();
  }

  Future initOneKeyLogin() async {
    var jverify = Jverify();
    //参数 appKey、channel 只对 IOS 生效
    jverify.setCollectionAuth(true);
    jverify.setup(appKey: MultiAppConfig.jpushId);
    jverify.setDebugMode(AppConfig.beta);
    await 0.2.delay();
  }
}