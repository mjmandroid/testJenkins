import 'package:desk_cloud/content/about/about_page.dart';
import 'package:desk_cloud/content/change_phone/change_phone_page.dart';
import 'package:desk_cloud/content/edit_nickname/edit_nickname_page.dart';
import 'package:desk_cloud/content/feedback/feedback_page.dart';
import 'package:desk_cloud/content/file/file_list_normal_page.dart';
import 'package:desk_cloud/content/file/file_only_list_page.dart';
import 'package:desk_cloud/content/launch/launch_page.dart';
import 'package:desk_cloud/content/login/mobile_code_page.dart';
import 'package:desk_cloud/content/login/mobile_login_page.dart';
import 'package:desk_cloud/content/pay_setting/auto_renewal_page.dart';
import 'package:desk_cloud/content/pay_setting/pay_setting_page.dart';
import 'package:desk_cloud/content/preview/image_preview.dart';
import 'package:desk_cloud/content/preview/pdf_preview.dart';
import 'package:desk_cloud/content/preview/txt_preview.dart';
import 'package:desk_cloud/content/preview/video_page.dart';
import 'package:desk_cloud/content/preview/video_preview_temp.dart';
import 'package:desk_cloud/content/preview/video_view.dart';
import 'package:desk_cloud/content/preview/word_preview.dart';
import 'package:desk_cloud/content/recycle_bin/recycle_bin_page.dart';
import 'package:desk_cloud/content/service/service_page.dart';
import 'package:desk_cloud/content/setting/setting_page.dart';
import 'package:desk_cloud/content/tab_parent_page.dart';
import 'package:desk_cloud/content/webView/app_webview_page.dart';
import 'package:desk_cloud/content/logOff/log_off_page.dart';
import 'package:flutter/material.dart';
import 'package:desk_cloud/content/pay_setting/auto_renewal_manage_page.dart';
import 'package:desk_cloud/content/io/unzipped_files_page.dart';

class MyRouter {
  MyRouter._();

  //启动页
  static const launch = "/launchPage";
  //首页
  static const home = "/homePage";
  //手机登录
  static const mobileLogin = "/mobileLoginPage";
  //手机验证码
  static const mobileCode = "/mobileCodePage";
  //设置
  static const setting = "/settingPage";
  //关于
  static const about = "/aboutPage";
  //内置浏览器
  static const webView = "/webViewPage";
  //注销
  static const logOff = "/logOffPage";
  //修改昵称
  static const editNickName = "/editNickNamePage";
  //建议反馈
  static const feedback = "/feedbackPage";
  //支付设置
  static const paySetting = "/paySettingPage";
  //自动续费
  static const autoRenewal = "/autoRenewalPage";
  //一般文件列表
  static const fileListNormal = "/fileListNormalPage";
  //更换手机号
  static const changePhone = "/changePhonePage";
  //纯文件页面
  static const fileOnlyList = "/fileOnlyListPage";
  //回收站
  static const recycleBin = "/RecycleBinPage";
  //图片预览
  static const imagePreview = "/imagePreviewPage";
  //视频预览
  static const videoView = "/videoView";
  //视频预览
  static const videoPreviewPageTemp = "/videoPreviewPageTemp";
  //视频播放
  static const videoPage = "/videoPage";
  //文本预览
  static const txtPreview = "/txtPreviewPage";
  //PDF预览
  static const pdfPreview = "/pdfPreviewPage";
  //WORD预览
  static const wordPreview = "/wordPreview";
  //客服中心
  static const servicePage = "/servicePage";
  //自动续费管理
  static const autoRenewalManage = "/autoRenewalManagePage";
  //解压文件列表
  static const unzippedFiles = "/unzippedFilesPage";

  static final whiteNames = [launch];

  static generateRoute(settings) {
    var name = settings.name;
    var args = settings.arguments;
    switch (name) {
      case launch:
        return _createRoute(const LaunchPage(), settings);
      case home:
        return _createRoute(const TabParentPage(), settings);
      case mobileLogin:
        return _createRoute(const MobileLoginPage(), settings);
      case mobileCode:
        return _createRoute(const MobileCodePage(), settings);
      case setting:
        return _createRoute(const SettingPage(), settings);
      case about:
        return _createRoute(const AboutPage(), settings);
      case webView:
        return _createRoute(const AppWebViewPage(), settings);
      case logOff:
        return _createRoute(const LogOffPage(), settings);
      case editNickName:
        return _createRoute(const EditNickNamePage(), settings);
      case feedback:
        return _createRoute(const FeedbackPage(), settings);
      case paySetting:
        return _createRoute(const PaySettingPage(), settings);
      case autoRenewal:
        return _createRoute(const AutoRenewalPage(), settings);
      case fileListNormal:
        return _createRoute(FileListNormalPage(args), settings);
      case changePhone:
        return _createRoute(const ChangePhonePage(), settings);
      case fileOnlyList:
        return _createRoute(FileOnlyListPage(args), settings);
      case recycleBin:
        return _createRoute(const RecycleBinPage(), settings);
      case imagePreview:
        return _createRoute(ImagePreviewPage(args), settings);
      case videoView:
        return _createRoute(VideoView(args), settings);
      case videoPreviewPageTemp:
        return _createRoute(VideoPreviewTemp(args), settings);
      case videoPage:
        return _createRoute(VideoPage(args), settings);
      case txtPreview:
        return _createRoute(TxtPreviewPage(args), settings);
      case pdfPreview:
        return _createRoute(PdfPreview(args), settings);
      case wordPreview:
        return _createRoute(WordPreview(args), settings);
      case servicePage:
        return _createRoute(const ServicePage(), settings);
      case autoRenewalManage:
        return _createRoute(const AutoRenewalManagePage(), settings);
      case unzippedFiles:
        return _createRoute(UnzippedFilesPage(path: args), settings);
    }
  }

  static Route<dynamic>? _createRoute(Widget widget,
      [RouteSettings? settings]) {
    //设置路由拦截，如果没有登录，或者不是白名单中的页面，则跳转登录页
    debugPrint(settings?.name);
    // if (!user.hasLogin.value && !whiteNames.contains(settings?.name)){
    //   user.gotoLogin(settings: settings);
    //   return null;
    // }
    return MaterialPageRoute(builder: (context) => widget, settings: settings);
  }
}
