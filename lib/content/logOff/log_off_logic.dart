import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/content/user/socket_logic.dart';
import 'package:desk_cloud/entity/base_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:realm/realm.dart';

class LogOffLogic extends BaseLogic {

  var confirm = false.obs;

  var confirmNext = false.obs;

  submitLogOff() async {
    showLoading();
    try{
      BaseEntity res = await ApiNet.request(Api.userCancel);
      dismissLoading();
      if (res.code == 200) {
        showShortToast('注销成功');
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

        /// 退出socket
        socketLogic.forceCloseSocket();

        SP.token = '';
        
        pushAndRemove(MyRouter.mobileLogin);
      }
    }catch(e){
      showShortToast(e.toString());
      dismissLoading();
    }
  }

}

LogOffLogic get logOffLogic {
  if (Get.isRegistered<LogOffLogic>()){
    return Get.find<LogOffLogic>();
  }
  return Get.put(LogOffLogic());
}