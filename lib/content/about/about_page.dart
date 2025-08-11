import 'package:desk_cloud/content/about/about_logic.dart';
import 'package:desk_cloud/utils/app_config.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/logutil.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends BaseXState<AboutLogic, AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: MyText(
            '关于',
            size: 16.sp            
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: 375.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    spaceH(40),
                    Image.asset(
                      R.assetsLogo,
                      width: 80.w,
                      height: 80.w,
                    ),
                    spaceH(30.h),
                    MyText(
                      '快兔网盘',
                      size: 22.sp,
                    ),
                    spaceH(14),
                    Obx(() => MyText(
                      // '${aboutLogic.versionCode.value}(${aboutLogic.versionBuildCode.value})${Api.beta ? 'beta': ''}',
                      '${aboutLogic.versionCode.value}(${aboutLogic.versionBuildCode.value})${AppConfig.beta ? 'beta': ''}',
                      size: 16.sp,
                      weight: FontWeight.normal,
                    )),
                    spaceH(32),
                    Obx(() => aboutLogic.appVersionEntity.value != null ? MyText(
                      '有新版本更新（${aboutLogic.appVersionEntity.value!.newversion ?? ''}）',
                      size: 14.sp,
                      weight: FontWeight.normal,
                      color: k9(),
                    ) : MyText(
                      '已是最新版本',
                      size: 14.sp,
                      weight: FontWeight.normal,
                      color: k9(),
                    )),
                    spaceH(14),
                    MyText(
                      '客户服务热线:${user.appInitData.value!.about!.servicePhone}',
                      size: 14.sp,
                      weight: FontWeight.normal,
                      color: k9(),
                    ),
                    MyText(
                      '客户服务邮箱:${user.appInitData.value!.about!.serviceEmail}',
                      size: 14.sp,
                      weight: FontWeight.normal,
                      color: k9(),
                    )
                    // MyText(
                    //   'APP备案编号:${user.appInitData.value!.about!.beian}',
                    //   size: 14.sp,
                    //   weight: FontWeight.normal,
                    //   color: k6(),
                    // ),
                    // Text.rich(
                    //   TextSpan(
                    //     text: '查询链接',
                    //     style: TextStyle(
                    //       color: k6(),
                    //       fontSize: 14.sp
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: '${user.appInitData.value!.about!.beianLink}',
                    //         recognizer: TapGestureRecognizer()..onTap = () {
                    //           launchUrlString('${user.appInitData.value!.about!.beianLink}');
                    //         },
                    //         style: TextStyle(
                    //           color: k4A83FF(),
                    //           fontSize: 14.sp
                    //         )
                    //       )
                    //     ]
                    //   )
                    // ),
                    // spaceH(30.h),
                    // SettingContextBody(items: [
                    //   SettingContextItem(title: '用户协议', onTap: () {
                    //     push(MyRouter.webView, args: {'title': '用户协议', 'url': user.appInitData.value!.agreement!.reg});
                    //   }),
                    //   SettingContextItem(title: '服务协议', onTap: () {
                    //     push(MyRouter.webView, args: {'title': '服务协议', 'url': user.appInitData.value!.agreement!.service});
                    //   }),
                    //   SettingContextItem(title: '隐私条款', onTap: () {
                    //     push(MyRouter.webView, args: {'title': '隐私条款', 'url': user.appInitData.value!.agreement!.privacy});
                    //   }),
                    //   SettingContextItem(title: '客户服务热线', tipStr: user.appInitData.value!.about!.servicePhone, showBorder: false, onTap: () {
                    //     if (user.appInitData.value!.about!.servicePhone!.isEmpty) return;
                    //     launchUrlString('tel:${user.appInitData.value!.about!.servicePhone}');
                    //   }),
                    // ]),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    width: 327.w,
                    title: '分享日志',
                    height: 49.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.w,
                        color: k4A83FF()
                      ),
                      borderRadius: 12.borderRadius
                    ),
                    style: TextStyle(
                      color: k4A83FF(),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal
                    ),
                    onTap: () {
                      shareLogs();
                    },
                  ),
                  spaceH(10),
                  MyButton(
                    width: 327.w,
                    title: '检测更新',
                    height: 49.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.w,
                        color: k4A83FF()
                      ),
                      borderRadius: 12.borderRadius
                    ),
                    style: TextStyle(
                      color: k4A83FF(),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal
                    ),
                    onTap: () {
                      aboutLogic.checkAppVersion();
                    },
                  ),
                  spaceH(80),
                  MyText(
                    'Copyright © 2024 - 2025 深圳市寻讯科技有限公司 版权所有',
                    size: 11.sp,
                    color: k9(),
                    textAlign: TextAlign.center,
                  ),
                  spaceH(16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  @override
  AboutLogic get initController => AboutLogic();
}