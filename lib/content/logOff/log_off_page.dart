import 'package:desk_cloud/content/logOff/log_off_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LogOffPage extends StatefulWidget {
  const LogOffPage({super.key});

  @override
  State<LogOffPage> createState() => _LogOffPageState();
}

class _LogOffPageState extends BaseXState<LogOffLogic, LogOffPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          title: MyText(
            '账号注销',
            size: 16.sp,
          ),
        ),
        body: ListView(
          children: [
            spaceH(30),
            Container(
              padding: EdgeInsets.only(left: 30.w),
              child: Image.asset(
                R.assetsIcWarning,
                width: 70.w,
                height: 70.w,
                alignment: Alignment.centerLeft,
              ),
            ),
            spaceH(23.h),
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: MyText(
                logOffLogic.confirmNext.value ? '账号一经注销成功，将无法恢复' : '请阅读并同意《快兔账号注销协议》',
                size: 20.sp,
              ),
            )),
            spaceH(23.h),
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: MyText(
                logOffLogic.confirmNext.value ? '为了保证您的财产安全和顺利注销，请您在确认如下事宜后，再点击“确认注销”' : '【重要提示】注销账号后，您将无法再使用本账号，也无法找回当前账号中与账号相关的任何信息，包括并不限于:',
                size: 15.sp,
                color: k3(),
              ),
            )),
            spaceH(23.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: MyText(
                '1、当前账号的个人信息 \n2、当前账号浏览、收藏、关注、订阅等信息(包括但不限于网址、小说、网盘文件等) \n3、当前账号未使用奖励、未使用的会员权益、已购买未到期的产品/会员服务等',
                size: 13.sp,
                weight: FontWeight.normal,
                color: k6(),
              ),
            ),
            spaceH(161.5),
            Obx(() => logOffLogic.confirmNext.value ? _confirmNextWidget() : _nextWidget())
          ],
        ),
      ),
    );
  }

  Widget _confirmNextWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: LayoutBuilder(builder: (context, constrains) {
        return Column(
          children: [
            MyButton(
              margin: EdgeInsets.only(bottom: 10.h),
              width: constrains.maxWidth,
              height: 49.h,
              decoration: BoxDecoration(
                color: kBlack(.06),
                borderRadius: 12.borderRadius
              ),
              title: '确认注销',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: kBlack()
              ),
              onTap: () => _confirmBottomSheet(),
            ),
            MyButton(
              margin: EdgeInsets.only(bottom: 10.h),
              width: constrains.maxWidth,
              height: 49.h,
              decoration: BoxDecoration(
                color: kRed(.04),
                borderRadius: 12.borderRadius
              ),
              title: '放弃注销',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: kRed()
              ),
              onTap: () => pop(),
            )
          ],
        );
      }),
    );
  }

  Widget _nextWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: LayoutBuilder(builder: (context, constrains) {
            return Obx(() => MyButton(
              title: '下一步', 
              alignment: Alignment.center, 
              width: constrains.maxWidth, 
              height: 49.h, 
              disable: !logOffLogic.confirm.value,
              onTap: () => logOffLogic.confirmNext.value = true,
            ));
          })
        ),
        spaceH(20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              MyInkWell(
                onTap: () {
                  logOffLogic.confirm.value = !logOffLogic.confirm.value;
                },
                child: Obx(() => Image.asset(
                  logOffLogic.confirm.value ? R.assetsCheckSquareY : R.assetsCheckSquareN,
                  width: 18.w,
                  height: 18.w,
                )),
              ),
              spaceW(5),
              Text.rich(
                TextSpan(
                  text: '我已经阅读并同意',
                  children: [
                    TextSpan(
                      text: '《账号注销协议》',
                      style: TextStyle(
                        color: k4A83FF()
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        push(MyRouter.webView, args: {'title': '账号注销协议', 'url': user.appInitData.value!.agreement!.cancel});
                      }
                    )
                  ]
                ),
                style: TextStyle(
                  color: k6(),
                  fontSize: 12.sp
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _confirmBottomSheet() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: 255.h,
        decoration: BoxDecoration(
          color: kWhite(),
          borderRadius: BorderRadius.vertical(top: 20.radius)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                '账号个人资产无法恢复提醒',
                size: 20.sp,
              ),
              spaceH(24),
              Text.rich(
                TextSpan(
                  text: '您的当前账号注销后，以下资产将丢失无法找回:',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kBlack(),
                    fontWeight: FontWeight.bold
                  ),
                  children: [
                    TextSpan(
                      text: '所有网盘云文件、压缩包、视频、图片、文档、音频',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: kRed(),
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ]
                )
              ),
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.5.w),
                child: Row(
                  children: [
                    Expanded(child: LayoutBuilder(builder: (context, constrains) {
                      return MyButton(
                        title: '取消注销',
                        height: 49.h,
                        width: constrains.maxWidth,
                        decoration: BoxDecoration(
                          color: kRed(0.04),
                          borderRadius: 12.borderRadius
                        ),
                        style: TextStyle(
                          color: kRed(),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp
                        ),
                        onTap: () {
                          pop();
                          pop();
                        },
                      );
                    })),
                    spaceW(20),
                    Expanded(child: LayoutBuilder(builder: (context, constrains) {
                      return MyButton(
                        title: '继续注销',
                        height: 49.h,
                        width: constrains.maxWidth,
                        decoration: BoxDecoration(
                          color: kBlack(0.06),
                          borderRadius: 12.borderRadius
                        ),
                        style: TextStyle(
                          color: kBlack(),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp
                        ),
                        onTap: () {
                          logOffLogic.submitLogOff();
                        },
                      );
                    })),
                  ],
                ),
              ))
            ],
          ),
        ),
      );
    }, backgroundColor: Colors.transparent);
  }
  
  @override
  LogOffLogic get initController => LogOffLogic();
}