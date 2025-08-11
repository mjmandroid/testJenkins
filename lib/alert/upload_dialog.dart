import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future showUploadDialog({
  String? message,
  int? enforce,
  required Function(bool) onValueChanged,
  bool dismissible = true
}){
  return showDialog(context: globalContext, builder: (context){
    return _UploadDialogView(message: message, enforce: enforce, onValueChanged: onValueChanged);
  },barrierDismissible: dismissible);
}

class _UploadDialogView extends StatelessWidget {
  final String? message;
  final int? enforce; // 是否强更 0 否，1 是
  final Function(bool) onValueChanged;
  const _UploadDialogView({this.message, this.enforce, required this.onValueChanged});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: MyText('版本更新',color: k3(),size: 18.sp,textAlign: TextAlign.center,),),              
            if (message?.isNotEmpty == true)
              Padding(
                padding: EdgeInsets.only(top: 15.w),
                child: MyText(message ?? '',color: k3(),size: 12.sp,lineHeight: 1.3,textAlign: TextAlign.left, weight: FontWeight.normal),
              ),
            Padding(
              padding: EdgeInsets.only(top: 30.w),
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
                                color: hexColor('#FFECEA'),
                                borderRadius: 12.borderRadius
                            ),
                            child: MyText('立即更新',color: hexColor('#FE3318'),size: 15.sp,),
                            onTap: (){
                              // if (enforce == 1) {
                              //   onValueChanged(true);
                              // } else {
                              //   pop(context: context,args: true);
                              // }
                              onValueChanged(true);
                            },
                          );
                        },
                      ),
                    )
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
