import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<dynamic> showPrivacyDialog(){
  return showDialog(context: globalContext, builder: (context){
    return const _PrivacyDialogView();
  },barrierDismissible: false);
}

class _PrivacyDialogView extends StatelessWidget {
  const _PrivacyDialogView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: kWhite(),
          borderRadius: 20.borderRadius
        ),
        padding: EdgeInsets.only(left: 24.w,right: 24.w,top: 24.w,bottom: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText('用户服务协议及隐私政策',color: k3(),size: 18.sp,),
            spaceH(15),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '已阅读并同意'),
                  TextSpan(
                    text: ' 用户协议 ',
                    style: TextStyle(color: k4A83FF()),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      push(MyRouter.webView, args: {'title': '用户协议', 'url': user.appInitData.value!.agreement!.reg});
                    }
                  ),
                  const TextSpan(text: '和'),
                  TextSpan(
                    text: ' 隐私政策 ',
                    style: TextStyle(color: k4A83FF()),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      push(MyRouter.webView, args: {'title': '隐私政策', 'url': user.appInitData.value!.agreement!.privacy});
                    }
                  ),
                  const TextSpan(text: '以及'),
                  TextSpan(
                    text: ' 中国移动认证服务条款',
                    style: TextStyle(color: k4A83FF()),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      push(MyRouter.webView, args: {'title': '运营商服务条款', 'url': 'https://wap.cmpassport.com/resources/html/contract.html'});
                    }
                  ),
                ]
              ),
              style: TextStyle(color: k6(),fontSize: 14.sp,fontWeight: FontWeight.w600,height: 1.4),
              textAlign: TextAlign.center,
            ),
            spaceH(10),
            MyText('快兔网盘将严格保护你的个人信息安全',color: k6(),size: 13.sp,),
            spaceH(30),
            MyButton(
              width: 218.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: k4A83FF(),
                borderRadius: 12.borderRadius
              ),
              child: MyText('同意并登录',color: kWhite(),size: 15.sp,),
              onTap: (){
                pop(context: context,args: true);
              },
            ),
            MyButton(
              width: 218.w,
              height: 48.w,
              margin: EdgeInsets.only(top: 2.w),
              decoration: BoxDecoration(
                  color: kWhite(),
                  borderRadius: 12.borderRadius
              ),
              child: MyText('不同意',color: k9(),size: 14.sp,),
              onTap: (){
                pop(context: context,args: false);
              },
            )
          ],
        ),
      ),
    );
  }
}
