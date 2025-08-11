import 'package:desk_cloud/content/login/mobile_login_logic.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/entity/login_user_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:gp_utils/gp_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:desk_cloud/alert/agent_announcement_dialog.dart';

class MobileCodeLogic extends BaseLogic {
  var smsTips = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  submit(String code) async {
    showLoading();
    smsTips.value = '';
    try {
      var uniqueDeviceId = await GpUtils.getUniqueDeviceId();
      var base = await ApiNet.request<LoginUserEntity>(Api.login, data: {
        'mobile': find<MobileLoginLogic>()?.mobileC.text.trim(),
        'sms_code': code,
        'device_id': uniqueDeviceId
      });
      user.loginUser.value = base.data;
      SP.token = base.data?.token;
      await user.getUserVip();
      await memberLogic.getProducts();
      dismissLoading();
      showShortToast('登录成功');
      pushAndRemove(MyRouter.home);

      // 延迟执行，确保首页加载完毕
      Future.delayed(const Duration(milliseconds: 500), () async {
        final prefs = await SharedPreferences.getInstance();
        const String announcementKey = 'has_shown_agent_announcement';

        // 使用 '?? false' 来确保当值为 null 时，我们得到的是 false，使逻辑更清晰
        if (!(prefs.getBool(announcementKey) ?? false)) {
          await prefs.setBool(announcementKey, true);
          showAgentAnnouncementDialog();
        }
      });
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
      smsTips.value = e.toString();
    }
  }
}
