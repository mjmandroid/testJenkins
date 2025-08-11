import 'package:desk_cloud/alert/change_phone_dialog.dart';
import 'package:desk_cloud/content/change_phone/change_phone_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class ChangePhonePage extends StatefulWidget {
  const ChangePhonePage({super.key});

  @override
  State<ChangePhonePage> createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends BaseXState<ChangePhoneLogic, ChangePhonePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SizedBox(
          width: 375.w,
          child: ListView(
            children: [
              spaceH(65.5),
              Align(
                alignment: Alignment.center,
                child: MyText(
                  '您的手机号 ${TextUtil.hideNumber(user.memberEquity.value!.mobile!)}',
                  size: 22.sp,
                ),
              ),
              spaceH(16),
              Align(
                alignment: Alignment.center,
                child: MyText(
                  '手机号是您账号的主要凭证，请确保手机号可用',
                  size: 14.sp,
                  weight: FontWeight.normal,
                ),
              ),
              spaceH(378.5),
              Align(
                alignment: Alignment.center,
                child: MyButton(
                  title: '更换手机号',
                  height: 49.h,
                  width: 327.w,
                  onTap: () async {
                    var res = await showChangePhoneDialog();
                    if (!res) return;
                    changePhoneLogic.submitChangePhone();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  ChangePhoneLogic get initController => ChangePhoneLogic();
}