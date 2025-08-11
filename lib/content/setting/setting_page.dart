import 'package:desk_cloud/content/setting/seting_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/custom_switch_with_label.dart';
import 'package:desk_cloud/widgets/setting_context_body.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BaseXState<SettingLogic, SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: MyAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: MyText(
                '设置',
                size: 16.sp,
              ),
              actions: [
                IconButton(
                  icon: Image.asset(
                    R.assetsIcMore,
                    width: 24.w,
                    height: 24.w,
                  ),
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (BuildContext context) {
                      return _logOffBottomSheet();
                    }, backgroundColor: Colors.transparent);
                  }, 
                )
              ],
            ),
            body: ListView(
              children: [
                SettingContextBody(items: [
                  SettingContextItem(title: '头像', subWidget: Obx(() => ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        color: hexColor('#d7e3ff', 1),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: user.memberEquity.value!.avatar!,
                        width: 32.w,
                        height: 32.w,
                        placeholder: (context, url) => Image.asset(
                          R.assetsIcDefault,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.cover
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          R.assetsIcDefault,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.cover
                        ),
                      ),
                    )),
                  ), onTap: () {
                    logic.uploadAvatar(context);
                  }),
                  Obx(() => SettingContextItem(title: '昵称', subTitle: user.memberEquity.value!.nickname, onTap: () {
                    push(MyRouter.editNickName);
                  })),
                  SettingContextItem(title: '绑定手机号', subTitle: TextUtil.hideNumber(user.memberEquity.value!.mobile!), showBorder: false, onTap: () {
                    push(MyRouter.changePhone);
                  })
                ]),
                spaceH(16.h),
                SettingContextBody(items: [
                  SettingContextItem(title: '客服中心', onTap: () {
                    push(MyRouter.servicePage);
                  }),
                  SettingContextItem(title: '意见反馈', onTap: () {
                    push(MyRouter.feedback);
                  }),
                  SettingContextItem(title: '关于', showBorder: false, onTap: () {
                    push(MyRouter.about);
                  }),
                  // SettingContextItem(title: '给个好评', showBorder: false, onTap: () {

                  // }),
                ]),
                spaceH(16.h),
                SettingContextBody(items: [
                  Obx(() => SettingContextItem(title: '消息通知', showNext: false, subWidget: CustomSwitchWithLabel(
                      value: logic.smsNotice.value,
                      onChanged: (value) {
                        logic.smsNotice.value = value;
                        SP.smsNotice = value;
                      },
                    ),
                    onTap: () {}
                  )),
                  Obx(() => SettingContextItem(title: '个性化推荐', showNext: false, subWidget: CustomSwitchWithLabel(
                      value: logic.interestNotice.value,
                      onChanged: (value) {
                        logic.interestNotice.value = value;
                        SP.interestNotice = value;
                      },
                    ),
                    onTap: () {}
                  )),
                  SettingContextItem(title: '用户协议', onTap: () {
                    push(MyRouter.webView, args: {'title': '用户协议', 'url': user.appInitData.value!.agreement!.reg});
                  }),
                  SettingContextItem(title: '服务协议', onTap: () {
                    push(MyRouter.webView, args: {'title': '服务协议', 'url': user.appInitData.value!.agreement!.service});
                  }),
                  SettingContextItem(title: '隐私条款', showBorder: false, onTap: () {
                    push(MyRouter.webView, args: {'title': '隐私条款', 'url': user.appInitData.value!.agreement!.privacy});
                  })
                ]),
                spaceH(16),
                SettingContextBody(items: [
                  SettingContextItem(title: '支付管理', showBorder: false, onTap: () {
                    push(MyRouter.paySetting);
                  })
                ], topAndBottomPadding: false, radius: 14),
                spaceH(16),
                SettingContextBody(items: [
                  SettingContextItem(
                    title: '退出登录', 
                    showNext: false, 
                    showBorder: false, 
                    titleColor: kRed(),
                    onTap: () {
                      settingLogic.logOut();
                    }
                  )
                ], topAndBottomPadding: false, radius: 14),
                spaceH(16)
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: MyButton(
          //     title: '支付设置',
          //     height: 49.h,
          //     margin: EdgeInsets.only(bottom: 20.h),
          //     style: TextStyle(
          //       color: k2C54AA()
          //     ),
          //     decoration: const BoxDecoration(
          //       color: Colors.transparent
          //     ),
          //     onTap: () => push(MyRouter.paySetting),
          //   ),
          // )    
        ],
      ),
    );
  }

  Widget _logOffBottomSheet () {
    return Stack(
      children: [
        Container(
          height: 151.h,
          decoration: BoxDecoration(
            color: kF8(),
            borderRadius: BorderRadius.vertical(top: 20.radius)
          ),
          alignment: Alignment.center,
          child: MyInkWell(
            onTap: () {
              pushReplace(MyRouter.logOff);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: kWhite(),
                    borderRadius: 15.borderRadius
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    R.assetsIcLogOff,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                spaceH(8),
                MyText(
                  '账号注销',
                  size: 13,
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 16.h,
          right: 16.w,
          child: IconButton(
            onPressed: () {
              pop();
            }, 
            icon: Image.asset(
              R.assetsDialogClose,
              width: 28.w,
              height: 28.w
            )
          )
        )
      ],
    );
  }
  
  @override
  SettingLogic get initController => SettingLogic();
}