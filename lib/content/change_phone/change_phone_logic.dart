import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:realm/realm.dart';

class ChangePhoneLogic extends BaseLogic {

  var phoneValue = '';

  var messageCode = '';

  getChangePhoneSmsCode() async {
    if (phoneValue.length < 11) {
      showShortToast('手机号码不正确');
      return;
    }
    
    if (memberLogic.timerUtil.isActive()) return;
    memberLogic.reCountDown();

    try{
      await ApiNet.request(Api.sendSms,data: {
        'mobile': phoneValue,
        'scene': 'change_mobile'
      });
    }catch(e){
      showShortToast(e.toString());
    }
  }

  submitChangePhone() async {
    if (phoneValue.length < 11) {
      showShortToast('手机号码不正确');
      return;
    }
    if (messageCode.length < 6) {
      showShortToast('验证码不正确');
      return;
    }
    try{
      var base = await ApiNet.request(Api.userChangeMobile, data: {
        'mobile': phoneValue,
        'sms_code': messageCode,
      });
      if (base.code == 200) {
        if (Get.isRegistered<TabIoLogic>()) {
          ioLogic.unzipTimer?.cancel();
        }

        oss.downloadTaskList.value.query(r'status == 1 || status == 2 || status == 0 || status == 5').forEach((element) {
          oss.cancelTask(element);
        });

        oss.uploadTaskList.value.query(r'status == 1 || status == 2 || status == 0 || status == 5').forEach((element) {
          oss.cancelTask(element);
        });
        tabParentLogic.productController?.dispose();
        tabParentLogic.productController = null;
        tabParentLogic.productAnimation = null;
        SP.token = '';
        pushAndRemove(MyRouter.mobileLogin);
      }
    }catch(e){
      showShortToast(e.toString());
    }
  }

}


ChangePhoneLogic get changePhoneLogic {
  if (Get.isRegistered<ChangePhoneLogic>()){
    return Get.find<ChangePhoneLogic>();
  }
  return Get.put(ChangePhoneLogic());
}