import 'package:desk_cloud/content/change_phone/change_phone_logic.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/key_board_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future showChangePhoneDialog({bool dismissible = false}){
  return showDialog(context: globalContext, builder: (context){
    return _ChangePhoneDialogView();
  },barrierDismissible: dismissible);
}

class _ChangePhoneDialogView extends StatefulWidget {

  @override
  State<_ChangePhoneDialogView> createState() => _ChangePhoneDialogViewState();
}

class _ChangePhoneDialogViewState extends State<_ChangePhoneDialogView> {
  final KeyboardUtils _keyboardUtils = KeyboardUtils();
  double _keyboardHeight = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在组件初始化时添加监听
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取键盘高度并监听变化
      _keyboardUtils.updateKeyboardHeight(context, (double height) {
        setState(() {
          _keyboardHeight = height;
        });
      });
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(bottom: _keyboardHeight),
        decoration: BoxDecoration(
            color: kWhite(),
            borderRadius: 20.borderRadius
        ),
        padding: EdgeInsets.only(left: 24.w,right: 24.w,top: 24.w,bottom: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              '为了保护您的账户安全，我们需要您再次确认身份。请在下面输入您收到的手机验证码以完成更换手机号的操作。',
              size: 13.sp,
              weight: FontWeight.normal,
            ),
            spaceH(20.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: k3(.04),
                borderRadius: 12.borderRadius
              ),
              child: MyTextField(
                maxLength: 11,
                hintText: '请输入手机号',
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: changePhoneLogic.phoneValue,
                )..selection = TextSelection.fromPosition(
                  TextPosition(affinity: TextAffinity.downstream, offset: changePhoneLogic.phoneValue.length)
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11)
                ],
                onChanged: (value) {
                  changePhoneLogic.phoneValue = value;
                }
              )
            ),
            spaceH(16.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: k3(.04),
                borderRadius: 12.borderRadius
              ),
              child: Row(
                children: [
                  Expanded(child: MyTextField(
                    maxLength: 6,
                    hintText: '请输入验证码',
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: changePhoneLogic.messageCode),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6)
                    ],
                    onChanged: (value) {
                      changePhoneLogic.messageCode = value;
                    },
                  )),
                  Obx(() => memberLogic.duration.value != 60 ? MyText(
                    '${memberLogic.duration.value}s',
                    size: 14.sp,
                    weight: FontWeight.normal,
                    color: k6(),
                  ) : MyButton(
                    title: '获取验证码',
                    height: 48.h,
                    decoration: const BoxDecoration(
                      color: Colors.transparent
                    ),
                    style: TextStyle(
                      color: k4A83FF(),
                      fontSize: 14.sp
                    ),
                    onTap: () {
                      changePhoneLogic.getChangePhoneSmsCode();
                    },
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: SizedBox(
                height: 44.w,
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context,constrains){
                          return MyButton(
                            width: constrains.maxWidth,
                            height: constrains.maxHeight,
                            decoration: BoxDecoration(
                                color: kBlack(0.04),
                                borderRadius: 12.borderRadius
                            ),
                            child: MyText('取消',color: k3(),size: 15.sp,),
                            onTap: (){
                              pop(context: context,args: false);
                            },
                          );
                        },
                      ),
                    ),
                    spaceW(8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context,constrains){
                          return MyButton(
                            width: constrains.maxWidth,
                            height: constrains.maxHeight,
                            decoration: BoxDecoration(
                                color: kBlack(.04),
                                borderRadius: 12.borderRadius
                            ),
                            child: MyText('确认',color: k4A83FF(),size: 15.sp,),
                            onTap: (){
                              pop(context: context,args: true);
                            },
                          );
                        },
                      ),
                    ),                      
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
