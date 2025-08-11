import 'package:desk_cloud/content/pay_setting/auto_renewal_logic.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future showCloseAutoRenewalDialog({bool dismissible = true}){
  return showDialog(context: globalContext, builder: (context){
    return _CloseAutoRenewalDialogView();
  },barrierDismissible: dismissible);
}

class _CloseAutoRenewalDialogView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
            color: kWhite(),
            borderRadius: 20.borderRadius
        ),
        padding: EdgeInsets.only(left: 24.w,right: 24.w,top: 24.w,bottom: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              '为了保护您的账户安全，我们需要您再次确认身份。请在下面输入您收到的手机验证码以完成关闭自动续费的操作。',
              size: 13.sp,
              weight: FontWeight.normal,
            ),
            spaceH(20.h),
            Text.rich(
              TextSpan(
                text: '短信验证码发送至 ',
                style: TextStyle(
                  color: kBlack(),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                    text: user.memberEquity.value!.mobile!,
                    style: TextStyle(
                      color: k4A83FF(),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold
                    )
                  )
                ]
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6)
                    ],
                    onChanged: (value) {
                      autoRenewalLogic.smsCode = value;
                    },
                  )),
                  Obx(() => memberLogic.duration.value != 60 ? MyText(
                    '${memberLogic.duration.value}s',
                    size: 14.sp,
                    weight: FontWeight.normal,
                    color: k6(),
                  ) : MyButton(
                    title: '重新发送',
                    height: 48.h,
                    decoration: const BoxDecoration(
                      color: Colors.transparent
                    ),
                    style: TextStyle(
                      color: k4A83FF(),
                      fontSize: 14.sp
                    ),
                    onTap: () {
                      autoRenewalLogic.reSendCloseAutoRenewalSmsCode();
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
