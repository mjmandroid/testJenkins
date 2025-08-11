import 'package:desk_cloud/content/login/mobile_code_logic.dart';
import 'package:desk_cloud/content/login/mobile_login_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class MobileCodePage extends StatefulWidget {
  const MobileCodePage({super.key});

  @override
  State<MobileCodePage> createState() => _MobileCodePageState();
}

class _MobileCodePageState extends BaseXState<MobileCodeLogic,MobileCodePage> with TickerProviderStateMixin {

  // 修改动画相关变量
  late AnimationController _breathingController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // 创建缩放动画
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, 
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    // 延迟200毫秒后执行一次动画
    Future.delayed(const Duration(milliseconds: 200), () {
      _breathingController.forward().then((_) {
        _breathingController.reverse(); // 放大后缩回原始大小
      });
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          spaceH(50),
          MyText('请输入6位验证码', color: k3(), size: 20.sp,),
          spaceH(6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText('验证码通过短信发送至 ', color: k9(), size: 12.sp,),
              MyText(
                // '${find<MobileLoginLogic>()?.mobileC.text.substring(0, 3)} ${find<MobileLoginLogic>()?.mobileC.text.substring(3, 7)} ${find<MobileLoginLogic>()?.mobileC.text.substring(7, 11)}',
                '${find<MobileLoginLogic>()?.mobileC.text.substring(0, 3)} **** ${find<MobileLoginLogic>()?.mobileC.text.substring(7, 11)}',
                color: k6(), 
                size: 12.sp
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.w, left: 18.w, right: 18.w),
            child: Pinput(
              autofocus: true,
              length: 6,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              defaultPinTheme: PinTheme(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: k3(0.04),
                  borderRadius: 12.borderRadius
                ),
                textStyle: TextStyle(color: k3(),fontSize: 32.sp,fontWeight: FontWeight.w600)
              ),
              focusedPinTheme: PinTheme(
                  width: 48.w,
                  height: 48.w,
                  padding: EdgeInsets.only(bottom: 3.w),
                  decoration: BoxDecoration(
                    color: k3(0.04),
                    borderRadius: 12.borderRadius,
                    border: Border.all(color: k4A83FF(),width: 1.w),
                  ),
                  textStyle: TextStyle(
                    color: k4A83FF(),
                    fontSize: 32.sp,
                  ),
              ),
              onCompleted: (v){
                logic.submit(v);
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          spaceH(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => logic.smsTips.value.isEmpty ? const SizedBox() : MyText(
                  logic.smsTips.value,
                  size: 12.sp,
                  color: kRed(),
                )),
                Obx(() => mobileLoginLogic.duration.value != 60 ? MyButton(
                  title: '重新获取(${mobileLoginLogic.duration.value}s)',
                  height: 22.h,
                  decoration: const BoxDecoration(
                    color: Colors.transparent
                  ),
                  style: TextStyle(
                    color: kB3(),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal
                  ),
                ) : AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: MyButton(
                          title: mobileLoginLogic.firstSendCode.value ? '立即发送' : '重新发送',
                          height: 22.h,
                          decoration: const BoxDecoration(
                            color: Colors.transparent
                          ),
                          style: TextStyle(
                            color: k4A83FF(),
                            fontSize: 14.sp
                          ),
                          onTap: () {
                            mobileLoginLogic.reSendSmsCode();
                          },
                        ),
                      );
                    },
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  MobileCodeLogic get initController => MobileCodeLogic();
}
