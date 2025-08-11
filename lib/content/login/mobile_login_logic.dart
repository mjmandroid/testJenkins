import 'package:desk_cloud/alert/command_list_sheet_temp.dart';
import 'package:desk_cloud/alert/privacy_dialog.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/share_code_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MobileLoginLogic extends BaseLogic{
  final mobileC = TextEditingController();
  final checked = false.obs;
  final focusNode = FocusNode();
  final canSubmit = false.obs;

  final codeDiskFileList = <DiskFileEntity>[].obs;

  /// 倒计时
  final TimerUtil timerUtil = TimerUtil(mInterval: 1000, mTotalTime: 60 * 1000);
  // /// 当前剩余时长
  var duration = 60.obs;
  /// 倒计时总时长
  int mTotalTime = 60;
  var firstSendCode = true.obs;

  @override
  void onInit() {
    super.onInit();
    0.3.delay().then((value) => focusNode.requestFocus());

    mobileC.addListener(() {
      // canSubmit.value = mobileC.text.trim().length == 11;
      canSubmit.value = RegexUtil.isMobileExact(mobileC.text.trim());
    });
  }

  submit()async{
    if (!checked.value){
      var r = await showPrivacyDialog();
      if (!r) return;
      checked.value = true;
    }
    if (mobileC.text.trim().length < 11){
      showShortToast('请输入正确的手机号');
      return;
    }
    push(MyRouter.mobileCode);
    if (timerUtil.isActive()) return;
    reSendSmsCode();
  }

  getClipboardContext() async {
    // 访问剪贴板的内容。
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text!.isNotEmpty) {
      try {
        var base = await ApiNet.request<ShareCodeEntity>(Api.getShareCode, data: {
          'text': clipboardData.text
        });
        Clipboard.setData(const ClipboardData(text: ''));
        if (base.data!.code!.isNotEmpty && base.data!.pageType! == 2) {
          getDiskCodeViews(base.data!.code!);
        }
      } catch (e) {
        // showShortToast(e.toString());
      }
    }
  }

  getDiskCodeViews(String code) async {
    var base = await ApiNet.request<List<DiskFileEntity>>(Api.diskCodeViews,data: {
      'code': code,
      'dir_id': 0
    });
    codeDiskFileList.clear();
    codeDiskFileList.addAll(base.data??[]);
    showCommandListSheetTmep();
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

  reSendSmsCode() async {
    firstSendCode.value = false;
    showLoading();
    try{
      await ApiNet.request(Api.sendSms,data: {
        'mobile': mobileC.text.trim(),
        'scene': 'login'
      });
      dismissLoading();
      reCountDown();
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
    }
  }
}

MobileLoginLogic get mobileLoginLogic {
  if (Get.isRegistered<MobileLoginLogic>()){
    return Get.find<MobileLoginLogic>();
  }
  return Get.put(MobileLoginLogic());
}