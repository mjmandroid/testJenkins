import 'dart:async';

import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/content/user/socket_logic.dart';
import 'package:desk_cloud/entity/create_order_entity.dart';
import 'package:desk_cloud/entity/member_products_entity.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/entity/pay_entity.dart';
import 'package:desk_cloud/entity/vip_powers_entity.dart';
import 'package:desk_cloud/utils/apple_pay_utils.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/logutil.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:fluwx/fluwx.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info/package_info.dart';
import 'package:tobias/tobias.dart';

class TabMemberLogic extends BaseLogic with RefreshHelper {

  /// 支付列表Map对象
  var payTypeArr = <Map>[].obs;
  /// 商品可使用的支付列表Map对象
  var productPayTypeArr = <Map>[].obs;
  /// 选中的支付方式
  var selectedPayTypeIndex = 0.obs;
  /// 会员商品
  final memberProducts = Rxn<List<MemberProductsEntity>>();
  /// 选中的会员商品
  final selectedMemberProducts = 0.obs;
  /// 是否选中自动续费
  final selectedAutoRenewal = true.obs;
  /// 校验是否为审核版本（支付提示弹窗）
  final checkVersionExamine = true.obs;
  /// 阅读并同意条款
  var readTheTerms = false.obs;
  /// 当前日期
  var thisDate = '';
  /// 倒计时
  final TimerUtil timerUtil = TimerUtil(mInterval: 1000, mTotalTime: 60 * 1000);
  // /// 当前剩余时长
  var duration = 60.obs;
  /// 倒计时总时长
  int mTotalTime = 60;
  final vipPowersEntity = Rxn<VipPowersEntity>();
  /// 是否展开会员特权对比
  final isExpansion = true.obs;
  /// 优惠倒计时
  Timer? activityTimer;
  int defaultLimitTime = 72;
  int remainingTime = 0;
  var days = '0'.obs;
  var hours = '00'.obs;
  var minutes = '00'.obs;
  var seconds = '00'.obs;
  bool _isPaying = false;
  final payArr = ['alipay', 'wechat', 'apple'];
  /// 是否重新加载商品列表
  bool _isReloadProducts = false;

  @override
  void onInit() async {
    super.onInit();
    getVipPowers();
    _getTimeAndStart();
    // await getPayList();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    checkVersionExamine.value = user.appInitData.value!.version!.contains(packageInfo.version);

    DateTime dateTime = DateTime.now();
    thisDate = '${dateTime.year}.${dateTime.month}.${dateTime.day}';
  }

  myRefresh() async {
    await user.getUserVip();
    await getProducts();
    logger.i('设置限速 ${int.parse(user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0')}');
    oss.client.setSpeedLimit(int.parse(user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0'));
    controller.refreshCompleted();
  }

  _getTimeAndStart() {
    // 获取当前时间
    DateTime now = DateTime.now();
    int limitedTimeOfferTimestamp = SP.limitedTimeOfferTimestamp;
    if (limitedTimeOfferTimestamp <= 0 || limitedTimeOfferTimestamp < now.millisecondsSinceEpoch) {
      // 计算 72 小时后的时间
      DateTime seventyTwoHoursLater = now.add(Duration(hours: defaultLimitTime));
      // 将 72 小时后的时间转换为时间戳（以毫秒为单位）
      int timestamp = seventyTwoHoursLater.millisecondsSinceEpoch;
      SP.limitedTimeOfferTimestamp = timestamp;
      remainingTime = timestamp - now.millisecondsSinceEpoch;
    } else {
      remainingTime = limitedTimeOfferTimestamp - now.millisecondsSinceEpoch;
    }
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      activityTimer = timer;
      if (remainingTime > 0) {
        remainingTime -= 1000;
        // 触发更新界面的方法
      } else {
        timer.cancel();
        _getTimeAndStart();
      }
      formatTime(remainingTime);
    });
  }

  formatTime(int milliseconds) {

    int totalSeconds = milliseconds ~/ 1000;
    int tempDays = totalSeconds ~/ (24 * 60 * 60);
    totalSeconds %= (24 * 60 * 60);
    int tempHours = totalSeconds ~/ (60 * 60);
    totalSeconds %= (60 * 60);
    int tempMinutes = totalSeconds ~/ 60;
    int tempSeconds = totalSeconds % 60;


    days.value = tempDays.toString();
    hours.value = tempHours.toString().padLeft(2, '0');
    minutes.value = tempMinutes.toString().padLeft(2, '0');
    seconds.value = tempSeconds.toString().padLeft(2, '0');      
  }

  /// 重新倒计时
  reCountDown() {
    if (timerUtil.isActive()) return;
    timerUtil.cancel();
    timerUtil.updateTotalTime(mTotalTime * 1000);
    timerUtil.setOnTimerTickCallback((int tick) {
      duration.value = (tick ~/ 1000);
      if (tick.toInt() <= 0) {
        timerUtil.updateTotalTime(mTotalTime * 1000);
        timerUtil.cancel();
      }
    });
    if (duration.value >= mTotalTime) {
      timerUtil.startCountDown();
    }
  }
  
  /// 获取会员商品列表
  Future getProducts () async {
    try{
      var base = await ApiNet.request<List<MemberProductsEntity>>(Api.getProducts,method: 'get');
      if (base.data == null && !_isReloadProducts) {
        _isReloadProducts = true;
        await getProducts();
        return;
      }
      memberProducts.value = base.data;
      await getPayList();
    }catch(e){
      showShortToast(e.toString());
      if (!_isReloadProducts) {
        _isReloadProducts = true;
        await getProducts();
      }
    }
  }

  /// 获取支付列表
  getPayList() async {
    try {
      payTypeArr.clear();
      // var base = await ApiNet.request(Api.checkGateway);
      // var tempArr = base.data ?? [];
      for (var index = 0; index < payArr.length; index++) {
        payTypeArr.add({
          'index': index,
          'key': payArr[index],
          'title': payArr[index] == 'alipay' ? '支付宝支付' : payArr[index] == 'wechat' ? '微信支付' : 'Apple Pay',
          'paymentId': payArr[index] == 'alipay' ? 2 : payArr[index] == 'wechat' ? 1 : 3,
        });
      }
      configurationPayList(selectedMemberProductsIndex: selectedMemberProducts.value);
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  configurationPayList({required int selectedMemberProductsIndex}) {
    productPayTypeArr.clear();
    List<String> payTypes = memberProducts.value?[selectedMemberProductsIndex].paysGatewayList ?? [];
    for (var item in payTypes) {
      productPayTypeArr.add(payTypeArr.firstWhere((element) => element['key'] == item));
    }
    // // 根据 index 排序
    // productPayTypeArr.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
  }

  final equityList = [
    OptionEntity()
      ..title = '超大空间'
      ..icon = R.assetsMemberEquity0,
    OptionEntity()
      ..title = '无限提取文件'
      ..icon = R.assetsMemberEquity1,
    OptionEntity()
      ..title = '无限上传文件'
      ..icon = R.assetsMemberEquity2,
    OptionEntity()
      ..title = '在线解压'
      ..icon = R.assetsMemberEquity3,
    OptionEntity()
      ..title = '极速下载'
      ..icon = R.assetsMemberEquity4,
    OptionEntity()
      ..title = '原画视频上传'
      ..icon = R.assetsMemberEquity5,
    OptionEntity()
      ..title = '视频高清播放'
      ..icon = R.assetsMemberEquity6,
    OptionEntity()
      ..title = '大文件上传'
      ..icon = R.assetsMemberEquity7,
    OptionEntity()
      ..title = '回收站保留'
      ..icon = R.assetsMemberEquity8,
    OptionEntity()
      ..title = '身份标识'
      ..icon = R.assetsMemberEquity9
  ];

  getVipPowers() async {
    try {
      var base = await ApiNet.request<VipPowersEntity>(Api.vipPowers); 
      vipPowersEntity.value = base.data;
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  String vipPowersValueConvert(String showValue, String value) {
    if (showValue.isEmpty) {
      return value;
    }

    if (showValue == 'yes') {
      return '';
    }

    if (showValue == 'no' || showValue == '0') {
      return '无';
    }
    
    return '无限';
  }

  createPay({ required int productId, required int paymentId, required String relationCode, required bool reaTderm, required int autoRenew }) {
    if (!reaTderm) {
      showShortToast('请阅读并同意相关协议');
      return;
    }
    if (paymentId == 1) {
      wechatPay(productId: productId, paymentId: paymentId, autoRenew: autoRenew);
    } else if (paymentId == 2) {
      aliPay(productId: productId, paymentId: paymentId);
    } else {
      applePay(productId: productId, paymentId: paymentId, relationCode: relationCode);
    }
  }

  wechatPay({ required int productId, required int paymentId, required int autoRenew}) async {
    if (!await user.fluwx.isWeChatInstalled) {
      showShortToast('请安装微信');
      return;
    }
    showLoading();
    try {
      CreateOrderEntity? orderEntity = await _createOrder(productId: productId, paymentId: paymentId);
      if (orderEntity == null) {
        dismissLoading();
        return;
      }
      /// 初始化socket
      await socketLogic.initSocket();
      dismissLoading();

      if (autoRenew == 1) {
        if (orderEntity.payWechat == null) {
          showShortToast('微信订阅异常');
          return;
        }
        await user.fluwx.autoDeduct(
          data: AutoDeduct.custom(
            queryInfo: {
              'pre_entrustweb_id': orderEntity.payWechat?.preEntrustwebId ?? ''
            }
          )
        );
      } else {
        if (orderEntity.payArray == null) {
          showShortToast('微信支付异常');
          return;
        }
        await user.fluwx.pay(
          which: Payment(
            appId: orderEntity.payArray?.appid ?? '', 
            partnerId: orderEntity.payArray?.partnerid ?? '', 
            prepayId: orderEntity.payArray?.prepayid ?? '', 
            packageValue: orderEntity.payArray?.package ?? '', 
            nonceStr: orderEntity.payArray?.noncestr ?? '', 
            timestamp: int.parse(orderEntity.payArray?.timestamp ?? '0'), 
            sign: orderEntity.payArray?.sign ?? ''  
          )
        );
      }

    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }

  aliPay({ required int productId, required int paymentId }) async {
    Tobias tobias = Tobias();
    if (!await tobias.isAliPayInstalled) {
      showShortToast('请安装支付宝');
      return;
    }
    showLoading();
    try {
      CreateOrderEntity? orderEntity = await _createOrder(productId: productId, paymentId: paymentId);
      if (orderEntity == null) {
        dismissLoading();
        return;
      }
      /// 初始化socket
      await socketLogic.initSocket();
      dismissLoading();
      Map payMap = await tobias.pay(orderEntity.payToken ?? ''); 
      _listenAliPay(int.parse(payMap['resultStatus']));
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }

  }

  void _listenAliPay(int resultStatus) async {
    switch (resultStatus) {
      case 9000:
        showShortToast('支付完成');
        myRefresh();
        break;
      case 8000:
        showShortToast('正在处理中');
        break;
      case 4000:
        showShortToast('订单支付失败');
        break;
      case 5000:
        showShortToast('重复请求');
        break;
      case 6001:
        showShortToast('取消支付');
        break;
      case 6002:
        showShortToast('网络连接出错');
        break;
      case 6004:
        showShortToast('支付结果未知');
        break;
    }
  }

  applePay({ required int productId, required int paymentId, required String relationCode }) async {
    if (_isPaying) {
      showShortToast('验证支付中...');
      return;
    }
    _isPaying = true;
    /**
     * 请注意，测试环境下需检查商品，正式环境不需要检查
     */
    showLoading();
    try {
      ProductDetails? productDetails = await ApplePayUtils.checkProduct(relationCode);
      if (productDetails == null) {
        showShortToast('商品不可用');
        dismissLoading();
        _isPaying = false;
        return;
      }
      CreateOrderEntity? orderEntity = await _createOrder(productId: productId, paymentId: paymentId);
      if (orderEntity == null) {
        _isPaying = false;
        dismissLoading();
        return;
      }
      /// 初始化socket
      await socketLogic.initSocket();
      dismissLoading();
      PurchaseDetails? purchaseDetails = await ApplePayUtils.startPay(productDetails, orderId: orderEntity.orderSn ?? '');    
      if (purchaseDetails == null) {
        _isPaying = false;
        dismissLoading();
        return;
      }
      var base = await ApiNet.request<PayEntity>(Api.verifyIospay, data: {
        'receipt_data': purchaseDetails.verificationData.serverVerificationData,
        'order_sn': orderEntity.orderSn
      });
      dismissLoading();
      _isPaying = false;
      if (base.code == 200 && base.data?.status == 1) {
        showShortToast('支付完成');
        myRefresh();
      } else {
        showShortToast('支付失败');
      }
    } catch (e) {
      // showShortToast(e.toString());
      dismissLoading();
      _isPaying = false;
    }
  }

  /// 创建订单
  Future<CreateOrderEntity?> _createOrder({ required int productId, required int paymentId }) async {
    try {
      var base = await ApiNet.request<CreateOrderEntity>(Api.orderCreate, data: {
        'product_id': productId,
        'payment_id': paymentId,
        'auto_renew': 1,
        'remark': ''
      });
      return base.data;
    } catch (e) {
      showShortToast(e.toString());
      return null;
    }
  }

  /// 恢复订阅
  restoreOrders() async {
    showLoading();
    try {
       await ApiNet.request(Api.restoreOrders);
       dismissLoading();
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
  }

}


TabMemberLogic get memberLogic {
  if (Get.isRegistered<TabMemberLogic>()){
    return Get.find<TabMemberLogic>();
  }
  return Get.put(TabMemberLogic());
}