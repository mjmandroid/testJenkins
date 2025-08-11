import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future showSubscribeDialog({required subscriType,required price,required data, String? cancel,String? ok,bool showCancel = true,bool showOk = true,bool dismissible = true}){
  return showDialog(context: globalContext, builder: (context){
    return _SubscribeDialogView(subscriType: subscriType, price: price, data: data, showCancel: showCancel, showOk: showOk, cancel: cancel,ok: ok,);
  },barrierDismissible: dismissible);
}

class _SubscribeDialogView extends StatelessWidget {
  final String subscriType;
  final String price;
  final String data;
  final String? cancel;
  final String? ok;
  final bool showCancel;
  final bool showOk;
  const _SubscribeDialogView({super.key,required this.subscriType,required this.price,required this.data, this.cancel,this.ok,required this.showCancel,required this.showOk});

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
              '确认订阅',
              size: 18.sp,
              weight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: MyText(
                '你选择了自动续费选项。请确认以下信息：',
                size: 12.sp,
                color: k3(),
                weight: FontWeight.normal
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: MyText(
                '订阅计划：$subscriType',
                size: 12.sp,
                color: k3(),
                weight: FontWeight.normal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: MyText(
                '费用：$price元',
                size: 12.sp,
                color: k3(),
                weight: FontWeight.normal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: MyText(
                '续费日期：$data',
                size: 12.sp,
                color: k3(),
                weight: FontWeight.normal,
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
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      hexColor('#D27000'),
                                      hexColor('#864406'),
                                    ]
                                  ),
                                  borderRadius: 12.borderRadius
                              ),
                              child: MyText(ok ?? '确认',color: kWhite(),size: 15.sp,),
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
