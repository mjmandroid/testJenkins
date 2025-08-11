import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class EditNickNameLogin extends BaseLogic {

  var nickname = '';

  final TextEditingController textEditingController = TextEditingController();

  editNickName() async {
    if (textEditingController.text.isEmpty) return;
    showLoading();
    try {
       await ApiNet.request(Api.userEditInfo, data: {'nickname': textEditingController.text});
       await user.getUserVip();
       dismissLoading();
       showShortToast('修改成功');
       pop();
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }

  }

  @override
  void onInit() {
    super.onInit();
    textEditingController.text = user.memberEquity.value!.nickname ?? '';
  }

}


EditNickNameLogin get editNickNameLogin {
  if (Get.isRegistered<EditNickNameLogin>()){
    return Get.find<EditNickNameLogin>();
  }
  return Get.put(EditNickNameLogin());
}