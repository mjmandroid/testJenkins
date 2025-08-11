import 'dart:async';

import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future showLimitedTimeOfferDialog({bool dismissible = true}){
  return showDialog(context: globalContext, builder: (context){
    return _LimitedTimeOfferDialogView();
  },barrierDismissible: dismissible);
}

class _LimitedTimeOfferDialogView extends StatefulWidget {

  @override
  State<_LimitedTimeOfferDialogView> createState() => _LimitedTimeOfferDialogViewState();
}

class _LimitedTimeOfferDialogViewState extends BaseXState<_LimitedTimeOfferDialogLogic, _LimitedTimeOfferDialogView> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final double startFrame = 80.0; // 起始帧
  final double endFrame = 120.0;  // 结束帧

  late Animation<double> _opacityAnimation;
  bool opacityCompleted = false;

  @override
  void initState() {
    super.initState();

    // 初始化控制器
    _controller = AnimationController(vsync: this, upperBound: 1.0);
    _controller.addListener(() {
      setState(() {});
    });
    // 监听动画播放结束的回调
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        logic.autoCloseDialog();
        // 动画播放结束，开始无限循环播放 80fps 到 120fps
        _controller.repeat(
          min: (startFrame / endFrame).clamp(0.0, 1.0), // 确保值在0到1之间
          max: 1.0,
          period: const Duration(milliseconds: 1200)
        );
      }
    });

    // 控制元素的透明度变化
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        opacityCompleted = true; // 当动画完成时，标记透明度动画完成
      }
    });
    
    // 请求立减金额数据
    logic.fetchInstantReduction();
  }
  // initState里面 加一个接口请求 instantReduction  接口 从里面读取数据读到数据后 动态展示到line 120行的  text: '20',
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕的宽高
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Center(
          child: MyButton(
            onTap: () {
              logic.autoTimer?.cancel();
              if (!logic._isDialogClosing) { // 检查是否已经关闭
                logic._isDialogClosing = true; // 设置为关闭状态
                pop();
              }
            },
            decoration: const BoxDecoration(
              color: Colors.transparent
            ),
            child: Lottie.asset(
              R.assetsFXVipHongBao,
              controller: _controller, // 绑定控制器
              onLoaded: (composition) {
                // 设置动画时长并开始动画
                _controller
                  ..duration = composition.duration
                  ..forward(); // 自动播放动画
              },
            ),
          ),
        ),
        Positioned(
          // top: 260.w,
          top: (screenHeight * 0.3355) - safeAreaBottom,
          right: 0,
          left: 0,
          child: Opacity(
            opacity: opacityCompleted ? 1.0 : _opacityAnimation.value,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '立减 ¥ ',
                      style: TextStyle(
                        color: kFF1413(),
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                      children: [
                        TextSpan(
                          text: '${logic.reductionAmount.value}',
                          style: TextStyle(
                            fontSize: 60.sp
                          )
                        )
                      ]
                    )
                  ),
                  MyText(
                    '数量有限 先到先得',
                    size: 15.sp,
                    color: kFF1413(.5),
                  )
                ],
              ),
            ),
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          // top: 200.w,
          top: (screenHeight * 0.2555) - safeAreaBottom,
          child: Opacity(
            opacity: opacityCompleted ? 1.0 : _opacityAnimation.value,
            child: Center(
              child: Obx(() => MyText(
                '${memberLogic.days.value}天${memberLogic.hours.value}:${memberLogic.minutes.value}:${memberLogic.seconds.value}后失效',
                color: kFFECDD(),
                size: 16.sp,
              )),
            ),
          )
        ),
        Positioned(
          // right: 61.w,
          // top: 198.w,
          right: screenWidth * 0.1555,
          top: (screenHeight * 0.2555) - safeAreaBottom,
          child: Opacity(
            opacity: opacityCompleted ? 1.0 : _opacityAnimation.value,
            child: MyButton(
              decoration: const BoxDecoration(
                color: Colors.transparent
              ),
              onTap: () {
                logic.autoTimer?.cancel();
                pop();
              },
              child: Image.asset(
                R.assetsIcCloseDialog,
                width: 21.w,
                height: 21.w,
              ),
            ),
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          // bottom: 195.w,
          bottom: (screenHeight * 0.2555) - safeAreaBottom,
          child: Opacity(
            opacity: opacityCompleted ? 1.0 : _opacityAnimation.value,
            child: Center(
              child: Obx(() => MyText(
                '${logic.autoCloseTime.value}s后自动收下',
                color: kWhite(.8),
                size: 12.sp
              ))
            )
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          // bottom: 195.w,
          bottom: (screenHeight * 0.4433) - safeAreaTop,
          child: Opacity(
            opacity: opacityCompleted ? 1.0 : _opacityAnimation.value,
            child: Center(
              child: MyText(
                '恭喜获得限时立减券',
                color: kFFDBC2(),
                size: 20.sp
              )
            )
          )
        )
      ],
    );
  }

  @override
  _LimitedTimeOfferDialogLogic get initController => _LimitedTimeOfferDialogLogic();
}

class _LimitedTimeOfferDialogLogic extends BaseLogic {

  var autoCloseTime = 105.obs;
  var reductionAmount = '20'.obs; // 添加立减金额响应式变量
  Timer? autoTimer;  
  bool _isDialogClosing = false; // 新增关闭状态标志

  // 添加获取立减金额的方法
  void fetchInstantReduction() async {
    try {
      // 这里调用你的 instantReduction 接口
      final response = await ApiNet.request(Api.instantReduction);
      if (response.data != null && response.data['product_discount'] != null) {
        reductionAmount.value = response.data['product_discount'].toString();
      }
    } catch (e) {
      // 接口请求失败时保持默认值
      print('获取立减金额失败: $e');
    }
  }

  void autoCloseDialog() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      autoTimer = timer;
      if (autoCloseTime.value > 0) {
        autoCloseTime -= 1;
        // 触发更新界面的方法
      } else {
        timer.cancel();
        autoTimer?.cancel();
        if (!_isDialogClosing) {
          _isDialogClosing = true; // 设置为关闭状态
          pop();
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    autoTimer?.cancel();
    _isDialogClosing = true; // 确保在关闭时设置状态
  }

}
