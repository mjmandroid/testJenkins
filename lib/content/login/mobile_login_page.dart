import 'package:desk_cloud/alert/privacy_dialog.dart';
import 'package:desk_cloud/content/about/about_logic.dart';
import 'package:desk_cloud/content/login/mobile_login_logic.dart';
import 'package:desk_cloud/utils/app_config.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> showNormalLogin() async {
  return await CustomNavigatorObserver().navigator?.push(PageRouteBuilder(
      pageBuilder: (context, a1, a2) {
        return const MobileLoginPage();
      },
      transitionDuration: Duration.zero));
}

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({super.key});

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState
    extends BaseXState<MobileLoginLogic, MobileLoginPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logic.getClipboardContext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        // logic.getClipboardContext();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            spaceH(50),
            MyText(
              '请输入手机号登录',
              color: k3(),
              size: 20.sp,
            ),
            spaceH(6),
            MyText(
              '未注册的手机号验证通过后将自动注册',
              color: k3(0.6),
              size: 12.sp,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.w, left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 69.w,
                    height: 49.w,
                    decoration: BoxDecoration(
                        color: k3(0.04),
                        borderRadius: BorderRadius.horizontal(left: 14.radius)),
                    alignment: Alignment.center,
                    child: MyText(
                      '+86',
                      color: k3(),
                      size: 16.sp,
                    ),
                  ),
                  spaceW(6),
                  Expanded(
                      child: Container(
                    width: 264.w,
                    height: 49.w,
                    decoration: BoxDecoration(
                        color: k3(0.04),
                        borderRadius:
                            BorderRadius.horizontal(right: 14.radius)),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: MyTextField(
                      hintText: '请输入手机号码',
                      focusNode: logic.focusNode,
                      controller: logic.mobileC,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11)
                      ],
                    ),
                  )),
                ],
              ),
            ),
            MyButton(
              width: 327.w,
              height: 49.w,
              margin: EdgeInsets.only(top: 55.w),
              title: '短信登录',
              onTap: () {
                logic.submit();
              },
            ),
            MyButton(
              width: 327.w,
              height: 49.w,
              margin: EdgeInsets.only(top: 16.w),
              decoration:
                  BoxDecoration(color: kF5(), borderRadius: 12.borderRadius),
              title: '一键登录',
              style: TextStyle(color: kBlack(), fontSize: 15.sp),
              onTap: () async {
                if (!logic.checked.value) {
                  var r = await showPrivacyDialog();
                  if (!r) return;
                  logic.checked.value = true;
                }
                user.gotoLogin();
              },
            ),
            // Obx(() {
            //   return MyButton(
            //     width: 327.w,
            //     height: 49.w,
            //     margin: EdgeInsets.only(top: 55.w),
            //     disable: (!logic.canSubmit.value || !logic.checked.value),
            //     title: '验证码登录',
            //     onTap: () {
            //       logic.submit();
            //     },
            //   );
            // }),
            // Obx(() => MyButton(
            //   width: 327.w,
            //   height: 49.w,
            //   margin: EdgeInsets.only(top: 16.w),
            //   disable: !logic.checked.value,
            //   decoration: BoxDecoration(
            //     color: kF5(),
            //     borderRadius: 12.borderRadius
            //   ),
            //   title: '一键登录',
            //   style: TextStyle(
            //     color: kBlack(),
            //     fontSize: 15.sp
            //   ),
            //   onTap: () async {
            //     user.gotoLogin();
            //   },
            // )),

            Padding(
              padding: EdgeInsets.only(left: 27.5.w, right: 27.5.w, top: 20.w),
              child: InkWell(
                onTap: () {
                  logic.checked.value = !logic.checked.value;
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Obx(() {
                        return Image.asset(
                          logic.checked.value
                              ? R.assetsCheckSquareY
                              : R.assetsCheckSquareN,
                          width: 18.w,
                          height: 18.w,
                        );
                      }),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: '阅读并同意', style: TextStyle(color: k6())),
                          TextSpan(
                              text: '《用户协议》',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  push(MyRouter.webView, args: {
                                    'title': '用户协议',
                                    'url':
                                        user.appInitData.value!.agreement!.reg
                                  });
                                }),
                          TextSpan(
                              text: '《隐私保护政策》',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  push(MyRouter.webView, args: {
                                    'title': '隐私保护政策',
                                    'url': user
                                        .appInitData.value!.agreement!.privacy
                                  });
                                }),
                          TextSpan(
                              text: '《中国移动认证服务条款》',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  push(MyRouter.webView, args: {
                                    'title': '中国移动认证服务条款',
                                    'url':
                                        'https://wap.cmpassport.com/resources/html/contract.html'
                                  });
                                })
                        ]),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.sp, color: k4A83FF(), height: 1.5),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (AppConfig.beta)
              Obx(() => Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.w),
                    child: MyText(
                      '${aboutLogic.versionCode.value}(${aboutLogic.versionBuildCode.value})${AppConfig.beta ? 'beta' : ''}',
                    ),
                  ))
          ],
        )),
      ),
    );
  }

  @override
  MobileLoginLogic get initController => MobileLoginLogic();
}
