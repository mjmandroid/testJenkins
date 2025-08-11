import 'dart:async';
import 'dart:io';
import 'package:desk_cloud/entity/prelogin_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:jverify/jverify.dart';

class OneKeyLogin {
  static Future<bool> check() async {
    var verify = Jverify();
    //判断当前的手机网络环境是否可以使用认证
    var result = await verify.checkVerifyEnable();
    if (result.isEmpty) {
      return false;
    }
    if (result["result"] != true) {
      return false;
    }
    return true;
  }

  static Completer<PreloginEntity>? _completer;

  static Future<PreloginEntity> start() async {
    showLoading();
    var verify = Jverify();
    //唤起一键登录页面
    var config = await _getConfig();
    // ignore: constant_identifier_names
    const String btn_widgetId = "jv_add_custom_button"; // 标识控件 id
    // ignore: constant_identifier_names
    // const String text_widgetId = "jv_add_custom_text"; // 标识控件 id
    // ignore: constant_identifier_names
    const String close_widgetId = "jv_add_custom_close_button"; // 标识控件 id

    var widgetList = <JVCustomWidget>[];
    // JVCustomWidget buttonWidget = JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
    // buttonWidget.top = (Platform.isIOS ? 580 : 520).w.toInt();
    // buttonWidget.width = 112.w.toInt();
    // buttonWidget.height = 16.w.toInt();
    // buttonWidget.btnNormalImageName = "icon_quick_login";
    // buttonWidget.btnPressedImageName = 'icon_quick_login';
    // buttonWidget.left = 158.w.toInt();

    JVCustomWidget textWidget = JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
    textWidget.top = (Platform.isIOS ? 520 : 456).w.toInt();
    textWidget.width = 327.w.toInt();
    textWidget.height = 49.w.toInt();
    textWidget.btnNormalImageName = "icon_mobile_login";
    textWidget.btnPressedImageName = 'icon_mobile_login';
    textWidget.left = 24.w.toInt();

    // JVCustomWidget closeWidget = JVCustomWidget(close_widgetId, JVCustomWidgetType.button);
    // closeWidget.width = 28.w.toInt();
    // closeWidget.height = 28.w.toInt();
    // closeWidget.btnNormalImageName = "icon_nav_back";
    // closeWidget.btnPressedImageName = 'icon_nav_back';
    // closeWidget.top = Platform.isIOS ? 50.w.toInt() : 16.w.toInt();
    // closeWidget.left = 16.w.toInt();

    widgetList.add(textWidget);
    // widgetList.add(closeWidget);
    // widgetList.add(buttonWidget);



    // 添加第二个 Logo 作为自定义控件
    const String secondLogoId = "login_logo_name";
    JVCustomWidget secondLogoWidget = JVCustomWidget(secondLogoId, JVCustomWidgetType.button);
    secondLogoWidget.top = 233.w.toInt(); // 根据需要调整位置
    secondLogoWidget.width = 80.w.toInt();
    secondLogoWidget.height = 18.5.w.toInt();
    secondLogoWidget.left = (ScreenUtil().screenWidth - 75.w) ~/ 2;
    secondLogoWidget.btnNormalImageName = "login_logo_name"; // 确保在资源中添加此图片
    secondLogoWidget.btnPressedImageName = "login_logo_name";

    // 将第二个 Logo 添加到 widgetList 中
    widgetList.add(secondLogoWidget);



    _completer = Completer();
    verify.addClikWidgetEventListener(btn_widgetId, (widgetId) async {
      verify.dismissLoginAuthView();
      dismissLoading();
      _completer?.complete(PreloginEntity().copyWith(resultType: PreloginType.toMobile));
      _completer = null;
    });

    verify.addClikWidgetEventListener(close_widgetId, (widgetId) async {
      verify.dismissLoginAuthView();
      dismissLoading();
      _completer?.complete(PreloginEntity().copyWith(resultType: PreloginType.cancel));
      _completer = null;
    });

    verify.setCustomAuthorizationView(
      false,
      config,
      landscapeConfig: config,
      widgets: widgetList,
    );
    verify.addAuthPageEventListener((event) {
      /**
       * 1	login activity closed.	授权页关闭事件
        2	login activity started.	授权页打开事件
        3	carrier privacy clicked.	运营商协议点击事件
        3	privacy 1 clicked.	自定义协议 1 点击事件
        3	privacy 2 clicked.	自定义协议 2 点击事件
        6	checkbox checked.	协议栏 checkbox 变为选中事件
        7	checkbox unchecked.	协议栏 checkbox 变为未选中事件
        8	login button clicked.	一键登录按钮（可用状态下）点击事件
       */
      // if (event.code == 1){
      //   dismissLoading();
      //   _completer?.complete(PreloginEntity().copyWith(resultType: PreloginType.cancel));
      //   _completer = null;
      // }
    });
    verify.loginAuth(true).then((result) async {
      debugPrint(result.toString());
      var code = result["code"];
      if (code == 6000) {
        dismissLoading();
        _completer?.complete(PreloginEntity().copyWith(resultType: PreloginType.oneKeyLogin,loginToken: result["message"]));
        _completer = null;
      } else if (code == 6002) {
        dismissLoading();
        _completer?.complete(PreloginEntity().copyWith(resultType: PreloginType.toMobile));
        _completer = null;
      }else{
        showShortToast('网络连接不通');
        dismissLoading();
        _completer?.complete(PreloginEntity().copyWith(resultType: PreloginType.toMobile));
        _completer = null;
      }
    });
    return await _completer!.future;
  }

  static Future<JVUIConfig> _getConfig() async {
    JVUIConfig uiConfig = JVUIConfig();
    bool isiOS = Platform.isIOS;

    uiConfig.statusBarHidden = false;
    uiConfig.authBackgroundImage = "login_bg";

    uiConfig.navText = "";
    uiConfig.navTextColor = const Color(0xff333333).value;
    // uiConfig.navReturnImgPath = "icon_nav_back"; //图片必须存在
    // uiConfig.navReturnBtnHidden = false;
    uiConfig.navTransparent = false;
    uiConfig.navColor = kWhite().value;
    uiConfig.statusBarColorWithNav = true;
    uiConfig.statusBarDarkMode = true;
    uiConfig.navTransparent = false;
    uiConfig.navHidden = true;

    uiConfig.logoWidth = 80.w.toInt();
    uiConfig.logoHeight = 80.w.toInt();
    uiConfig.logoOffsetY = Platform.isIOS ? 138.w.toInt() : 138.w.toInt();
    uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
    uiConfig.logoHidden = false;
    uiConfig.logoImgPath = "login_logo";

    uiConfig.numFieldOffsetY = isiOS ? 150.w.toInt() : 320.w.toInt();
    uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
    uiConfig.numberColor = k3().value;
    uiConfig.numberTextBold = true;
    uiConfig.numberSize = 22.sp.toInt();
    uiConfig.numberFieldHeight = isiOS ? 30.w.toInt() : 30.w.toInt();
    uiConfig.numberFieldWidth = 300.w.toInt();

    uiConfig.sloganOffsetY = isiOS ? 0.w.toInt() : 350.w.toInt();
    uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
    uiConfig.sloganTextColor = k3(0.4).value;
    uiConfig.sloganTextSize = 12.sp.toInt();
    //        uiConfig.slogan
    //uiConfig.sloganHidden = 0;

    uiConfig.logBtnWidth = 327.w.toInt();
    uiConfig.logBtnHeight = 49.w.toInt();
    uiConfig.logBtnOffsetY = isiOS ? 35.w.toInt() : 390.w.toInt();
    uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
    uiConfig.logBtnText = '';
    uiConfig.logBtnTextColor = Colors.white.value;
    uiConfig.logBtnTextSize = 15.sp.toInt();
    uiConfig.logBtnBackgroundPath = 'icon_quick_login';
    uiConfig.loginBtnNormalImage = 'icon_quick_login';
    uiConfig.loginBtnPressedImage = 'icon_quick_login';
    uiConfig.loginBtnUnableImage = 'icon_quick_login';

    uiConfig.privacyState = false; //设置默认勾选
    uiConfig.privacyCheckboxSize = 18.w.toInt();
    uiConfig.checkedImgPath = "check_round_y"; //图片必须存在
    uiConfig.uncheckedImgPath = "check_round_n"; //图片必须存在

    // uiConfig.privacyCheckboxInCenter = true;

    uiConfig.privacyOffsetX = 28.w.toInt();
    uiConfig.privacyOffsetY = (safeAreaBottom + 50.w).toInt(); // 距离底部距离
    uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
    uiConfig.clauseBaseColor = k3(0.4).value;
    uiConfig.clauseColor = k4A83FF().value;
    uiConfig.privacyItem = [
      JVPrivacy('用户协议', user.appInitData.value!.agreement!.reg, afterName: '请阅读并同意', beforeName: "和"),
      JVPrivacy('隐私协议', user.appInitData.value!.agreement!.privacy, afterName: "")
    ];
    uiConfig.privacyTextSize = 12.sp.toInt();
    uiConfig.authStatusBarStyle = JVIOSBarStyle.StatusBarStyleLightContent;
    uiConfig.clauseName = '用户协议';
    uiConfig.clauseUrl = user.appInitData.value!.agreement!.reg;
    uiConfig.clauseNameTwo = '隐私协议';
    uiConfig.clauseUrlTwo = user.appInitData.value!.agreement!.privacy;

    uiConfig.needStartAnim = true;
    uiConfig.needCloseAnim = true;

    uiConfig.privacyNavTitleTextSize = 12.sp.floor();
    uiConfig.privacyNavTitleTitle1 = "《用户服务协议》";
    uiConfig.privacyNavTitleTitle2 = "《隐私协议'》";
    uiConfig.privacyNavReturnBtnImage = "one_key_back";
    // if (Platform.isAndroid) {
    //   uiConfig.isAlertPrivacyVc = false;
    //   uiConfig.privacyCheckDialogConfig = JVPrivacyCheckDialogConfig()
    //     ..contentTextSize = 16.sp.toInt()
    //     ..titleTextSize = 16.sp.toInt()
    //     ..width = 300.w.toInt()
    //     ..logBtnTextColor = k3().value
    //     ..logBtnText = '同意并登录'
    //     ..logBtnImgPath = 'one_key_login_second_btn'
    //     ..logBtnWidth = 280.w.toInt()
    //     ..logBtnHeight = 40.w.toInt();
    // }

    return uiConfig;
  }
}
