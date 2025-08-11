import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future showNormalDialog({
  String? title,
  String? message,
  String? cancel,
  String? ok,
  bool showCancel = true,
  bool showOk = true,
  bool dismissible = true,
  Color? okBtnColor,
  Color? okTextColor,
  TextAlign messageTextAlign = TextAlign.center,
}){
  return showDialog(context: globalContext, builder: (context){
    return _NormalDialogView(
      showCancel: showCancel, 
      showOk: showOk, 
      title: title,
      message: message,
      cancel: cancel,
      ok: ok,
      okBtnColor: okBtnColor,
      okTextColor: okTextColor,
      messageTextAlign: messageTextAlign,
    );
  },barrierDismissible: dismissible);
}

class _NormalDialogView extends StatelessWidget {
  final String? title;
  final String? message;
  final String? cancel;
  final String? ok;
  final bool showCancel;
  final bool showOk;
  final Color? okBtnColor;
  final Color? okTextColor;
  final TextAlign messageTextAlign;
  const _NormalDialogView({
    this.title,
    this.message,
    this.cancel,
    this.ok,
    required this.showCancel,
    required this.showOk,
    this.okBtnColor,
    this.okTextColor,
    this.messageTextAlign = TextAlign.center
  });

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
            if (title?.isNotEmpty == true)
              MyText(title ?? '',color: k3(),size: 18.sp,textAlign: TextAlign.center,),
            if (message?.isNotEmpty == true)
              Padding(
                padding: EdgeInsets.only(top: 15.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 20.w,  // 最小高度
                    maxHeight: 200.w,  // 最大高度，超出后可滚动
                  ),
                  child: SingleChildScrollView(
                    child: MyText(
                      message ?? '',
                      color: k3(),
                      size: 12.sp,
                      lineHeight: 1.3,
                      textAlign: messageTextAlign,
                      weight: FontWeight.normal
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 30.w),
              child: SizedBox(
                height: 44.w,
                child: Row(
                  children: [
                    if (showCancel)
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
                              child: MyText(cancel ?? '取消',color: k3(),size: 15.sp,),
                              onTap: (){
                                pop(context: context,args: false);
                              },
                            );
                          },
                        ),
                      ),
                    if (showOk && showCancel)
                      spaceW(8),
                    if (showOk)
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context,constrains){
                            return MyButton(
                              width: constrains.maxWidth,
                              height: constrains.maxHeight,
                              decoration: BoxDecoration(
                                color: okBtnColor ?? hexColor('#FFECEA'),
                                borderRadius: 12.borderRadius
                              ),
                              child: MyText(
                                ok ?? '确认',
                                color: okTextColor ?? hexColor('#FE3318'),
                                size: 15.sp
                              ),
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
