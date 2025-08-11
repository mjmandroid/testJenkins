import 'package:app_install_date/app_install_date_imp.dart';
import 'package:desk_cloud/content/login/mobile_login_page.dart';
import 'package:desk_cloud/content/login/one_key_login.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/content/user/user_option_mixin.dart';
import 'package:desk_cloud/content/user/user_share.dart';
import 'package:desk_cloud/entity/app_init_entity.dart';
import 'package:desk_cloud/entity/base_entity.dart';
import 'package:desk_cloud/entity/guest_cool_down_entity.dart';
import 'package:desk_cloud/entity/login_user_entity.dart';
import 'package:desk_cloud/entity/member_equity_entity.dart';
import 'package:desk_cloud/entity/prelogin_entity.dart';
import 'package:desk_cloud/entity/search_result_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:gp_utils/gp_utils.dart';

class UserLogic extends UserBaseMixin with UserOptionMixin,UserShare{
  final appInitData = Rxn<AppInitEntity>();
  final hasLogin = false.obs;
  final loginUser = Rxn<LoginUserEntity>();
  final memberEquity = Rxn<MemberEquityEntity>();
  final searchEnumType = Rxn<List<SearchResultEnumDataType>>();

  @override
  onInit() {
    super.onInit();
    fluwx.addSubscriber(_listenWechatPay);
  }

  /// 获取会员信息
  Future<bool> getUserVip () async {
    try{
      var base = await ApiNet.request<MemberEquityEntity>(Api.getUserVip,method: 'get');
      var coolDownTime = await ApiNet.request<GuestCoolDownEntity>(Api.getCoolDown,method: 'get');
      SP.coolDown = coolDownTime.data?.guest_cooldown_time ?? "";
      memberEquity.value = base.data;
      memberEquity.refresh();
      return true;
    }catch(e){
      showShortToast(e.toString());
      return false;
    }
  }

  Future getInitAppData()async{
    while(true){
      try{
        final DateTime date = await AppInstallDate().installDate;
        var base = await ApiNet.request<AppInitEntity>(Api.common,method: 'post', data: {
          'installDate': date.millisecondsSinceEpoch
        });
        appInitData.value = base.data;
        break;
      }catch(e){
        await 1.delay();
      }
    }
  }

  Future initSearchData()async{
    try{
      var base = await ApiNet.request<SearchResultEntity>(Api.diskSearchInit,method: 'get');
      searchEnumType.value = base.data?.fileEnum?.dataType?? [];
    }catch(e){
      showShortToast(e.toString());
    }
  }

  void _listenWechatPay(WeChatResponse resp) async {
    if (resp is WeChatPaymentResponse) {
      switch (resp.errCode) {
        case -2:
          showShortToast('取消支付');
          break;
        case -1:
          showShortToast('系统问题或网络不稳定');
          break;
        case 0:
          showShortToast('支付完成');
          memberLogic.myRefresh();
          break;
        default:
          showShortToast('订单无效');
      }
    }
  }

  /// 跳转客服
  jumpService() async {
    /// type 2 跳转微信，1 使用webview
    if (appInitData.value?.webview?.service?.type == 2) {
      if (!await fluwx.isWeChatInstalled) {
        showShortToast('请安装微信');
        return;
      }
      fluwx.open(target: CustomerServiceChat(corpId: appInitData.value?.webview?.service?.cid ?? '', url: appInitData.value?.webview?.service?.url ?? ''));
    } else {
      push(MyRouter.webView, args: {'title': '客服中心', 'url': user.appInitData.value?.webview?.service?.url});
    }
  }

  @override
  void onClose() {
    closeShare();
    super.onClose();
  }
}

extension LoginUser on UserLogic{
  Future<bool> gotoLogin()async{
    PreloginEntity? entity;
    while(true){
      debugPrint('1');
      var r = await OneKeyLogin.start();
      debugPrint('2');
      if (r.type == PreloginType.toMobile){
        debugPrint('3');
        r = await showNormalLogin();
        debugPrint('4');
      }
      entity = r;
      if (r.type != PreloginType.toOneKey){
        debugPrint('5');
        break;
      }
    }
    if (entity.type == PreloginType.cancel){
      debugPrint('6');
      return false;
    }
    if (entity.type == PreloginType.oneKeyLogin){
      showLoading();
      debugPrint('7');

      try {
        BaseEntity checkLoginRes = await ApiNet.request(Api.checkLogin);
        if (checkLoginRes.code != 200) {
          // 0.5.delay().then((value) => user.gotoLogin());
          return false;
        } 
      } catch (e) {
        // 0.5.delay().then((value) => user.gotoLogin());
        showShortToast(e.toString());
        return false;
      }

      try{
        var uniqueDeviceId =  await GpUtils.getUniqueDeviceId();
        var base = await ApiNet.request<LoginUserEntity>(Api.loginFast,data: {
          "access_token": entity.loginToken,
          "bussiness": '2',
          'device_id': uniqueDeviceId
        });
        loginUser.value = base.data;
        SP.token = base.data?.token;
        await getUserVip();
        await memberLogic.getProducts();
        dismissLoading();
        showShortToast('登录成功');
        pushAndRemove(MyRouter.home);
      }catch(e){
        dismissLoading();
        showShortToast(e.toString());
        entity = await showNormalLogin();
      }
    }
    hasLogin.value = true;
    return true;
  }
}

UserLogic get user {
  if (Get.isRegistered<UserLogic>()){
    return Get.find<UserLogic>();
  }
  return Get.put(UserLogic());
}