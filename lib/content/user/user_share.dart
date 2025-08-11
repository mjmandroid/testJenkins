
import 'dart:async';

import 'package:desk_cloud/content/user/user_logic.dart';
import 'package:desk_cloud/entity/share_data_entity.dart';
import 'package:desk_cloud/utils/extension.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluwx/fluwx.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'package:weibo_kit/weibo_kit.dart';

import 'user_option_mixin.dart';

mixin UserShare on UserBaseMixin{
  StreamSubscription<TencentResp>? _qqSubs;
  StreamSubscription<BaseResp>? _weiboSubs;
  final Fluwx fluwx = Fluwx();

  initWechat(){
    fluwx.registerApi(appId: 'wx38cd8f1f24d82458', universalLink: 'https://web.diskyun.com/apple-app-site-association');
  }

  initWeibo(){
    Weibo.instance.registerApp(appKey: '4177890682', universalLink: 'https://web.diskyun.com/apple-app-site-association', scope: [WeiboScope.ALL]);
    _weiboSubs = Weibo.instance.respStream().listen(_weiboListenResp);
  }

  initQQ() async {
    await TencentKitPlatform.instance.setIsPermissionGranted(granted: true);
    TencentKitPlatform.instance.registerApp(appId: '102352379',universalLink: 'https://web.diskyun.com/apple-app-site-association');
    _qqSubs = TencentKitPlatform.instance.respStream().listen(_qqListenResp);
  }

  initBugly() async {
    FlutterBugly.init(
      androidAppId: "ef330f9ba0",
      iOSAppId: "6ec26b6174",
    );
  }

  void _weiboListenResp(BaseResp resp) {
    if (resp is AuthResp) { //授权
      //登录
    } else if (resp is ShareMsgResp) {
      //share
    }
  }

  void _qqListenResp(TencentResp resp) {
    if (resp is TencentLoginResp) { //授权
      //登录
    } else if (resp is TencentShareMsgResp) {
      //share
    }
  }

  wechatChatShare(ShareDataEntity data)async{
    if (!await fluwx.isWeChatInstalled) {
      showShortToast('请安装微信');
      return;
    }
    final file = await DefaultCacheManager().getSingleFile(user.appInitData.value!.shareParams!.logo ?? '');
    fluwx.share(
      WeChatShareWebPageModel(
        data.link ?? '',
        title: data.title,
        thumbData: file.readAsBytesSync(),
        description: user.appInitData.value!.shareParams!.desc ?? '',
        scene: WeChatScene.session
      )
    );
  }

  wechatTimelineShare(ShareDataEntity data)async{
    if (!await fluwx.isWeChatInstalled) {
      showShortToast('请安装微信');
      return;
    }
    final file = await DefaultCacheManager().getSingleFile(user.appInitData.value!.shareParams!.logo ?? '');
    fluwx.share(WeChatShareWebPageModel(
      data.link ?? '',
      description: user.appInitData.value!.shareParams!.desc ?? '',
      title: data.title,
      thumbData: file.readAsBytesSync(),
      scene: WeChatScene.timeline,
    ));
  }

  qqChatShare(ShareDataEntity data)async{
    if (!await TencentKitPlatform.instance.isQQInstalled()) {
      showShortToast('请安装QQ');
      return;
    }
    final file = await DefaultCacheManager().getSingleFile(user.appInitData.value!.shareParams!.logo ?? '');
    TencentKitPlatform.instance.shareWebpage(
      scene: TencentScene.kScene_QQ, 
      title: data.title ?? '', 
      targetUrl: data.link ?? '',
      summary: user.appInitData.value!.shareParams!.desc ?? '',
      imageUri: Uri.file(file.path)
    );
  }

  qqSpaceShare(ShareDataEntity data)async{
    if (!await TencentKitPlatform.instance.isQQInstalled()) {
      showShortToast('请安装QQ');
      return;
    }
    final file = await DefaultCacheManager().getSingleFile(user.appInitData.value!.shareParams!.logo ?? '');
    TencentKitPlatform.instance.shareWebpage(
        scene: TencentScene.kScene_QZone,
        title: data.title ?? '',
        targetUrl: data.link ?? '',
        summary: user.appInitData.value!.shareParams?.desc?.substring(0, 9) ?? '',
        imageUri: Uri.file(file.path)
    );
  }
  
  weiboShare(ShareDataEntity data)async{
    if (!await Weibo.instance.isInstalled()) {
      showShortToast('请安装微博');
      return;
    }
    Weibo.instance.shareText(text: '${data.txt}');
    // final file = await DefaultCacheManager().getSingleFile(user.appInitData.value!.shareParams!.logo ?? '');
    // Weibo.instance.shareWebpage(
    //   title: data.title ?? '',
    //   description: data.txt ?? '',
    //   thumbData: file.readAsBytesSync(),
    //   webpageUrl: data.link ?? '',
    // );
  }
  
  closeShare(){
    _qqSubs?.cancel();
    _weiboSubs?.cancel();
    fluwx.clearSubscribers();
  }
}