import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/entity/auto_renewal_entity.dart';
import 'package:desk_cloud/entity/base_entity.dart';
import 'package:desk_cloud/utils/export.dart';

class AutoRenewalLogic extends BaseLogic {

  final autoRenewal = Rxn<AutoRenewalEntity>();

  var smsCode = '';

  @override
  onInit() async {
    super.onInit();
    showLoading();
    try {
      var base = await ApiNet.request<AutoRenewalEntity>(Api.autoRenewalOrderList);
      autoRenewal.value = base.data;
      dismissLoading();
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }
  
  getCloseAutoRenewalSmsCode() async {
    try{
      await ApiNet.request(Api.sendSms,data: {
        'mobile': user.memberEquity.value!.mobile,
        'scene': 'close_renew'
      });
    }catch(e){
      showShortToast(e.toString());
    }
  }

  reSendCloseAutoRenewalSmsCode() {
    if (memberLogic.timerUtil.isActive()) return;
    memberLogic.reCountDown();
    getCloseAutoRenewalSmsCode();
  }

  submitCloseAutoRenewal() async {
    if (smsCode.length < 6) {
      showShortToast('请输入正确验证码');
      return;
    }
    try{
      BaseEntity res = await ApiNet.request(Api.closeAutoRenewal,data: {
        'sms_code': user.memberEquity.value!.mobile
      });
      if (res.code == 200) {
        showShortToast('关闭成功');
        pop();
      }
    }catch(e){
      showShortToast(e.toString());
    }
  }

}

AutoRenewalLogic get autoRenewalLogic {
  if (Get.isRegistered<AutoRenewalLogic>()){
    return Get.find<AutoRenewalLogic>();
  }
  return Get.put(AutoRenewalLogic());
}