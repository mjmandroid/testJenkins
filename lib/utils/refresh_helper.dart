import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

mixin RefreshHelper {
  var controller = RefreshController();
  var pageSize = 25;
  var page = 1;

  void onRefresh() {
    Future.delayed(const Duration(seconds: 1), () {
      controller.refreshCompleted();
    });
  }

  void onLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      controller.loadNoData();
    });
  }
}

class MyCustomHeader extends StatefulWidget {
  const MyCustomHeader({super.key});

  @override
  State<MyCustomHeader> createState() => _MyCustomHeaderState();
}

class _MyCustomHeaderState extends State<MyCustomHeader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // 持续旋转动画，稍后会根据状态控制启动和停止
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? mode) {
        if (mode == RefreshStatus.idle || mode == RefreshStatus.completed || mode == RefreshStatus.failed) {
          Future.delayed(const Duration(milliseconds: 3000)).then((_){
            // _animationController.stop(); // 停止旋转
          });

        } else if (mode == RefreshStatus.canRefresh || mode == RefreshStatus.refreshing) {
          _animationController.repeat(); // 开始旋转
        }
        return SizedBox(
          height: 60.w,
          child: Center(
            child: RotationTransition(
              turns: _animationController,
              child: const Center(
                child: CircularProgress(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyCustomFooter extends StatefulWidget {

  final String? noDataText;

  const MyCustomFooter({this.noDataText, super.key});

  @override
  State<MyCustomFooter> createState() => _MyCustomFooterState();
}

class _MyCustomFooterState extends State<MyCustomFooter> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // 持续旋转动画，稍后会根据状态控制启动和停止
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        if (mode == LoadStatus.idle) {
          return SizedBox(
            height: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgress(),
                spaceW(8),
                MyText(
                  '上拉加载更多',
                  size: 13.sp,
                  color: k9(),
                  weight: FontWeight.normal,
                )
              ],
            ),
          );
        } else if (mode == LoadStatus.canLoading) {
          return SizedBox(
            height: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgress(),
                spaceW(8),
                MyText(
                  '松开开始加载数据',
                  size: 13.sp,
                  color: k9(),
                  weight: FontWeight.normal,
                )
              ],
            ),
          );
        } else if (mode == LoadStatus.loading) {
          _animationController.repeat();
          return SizedBox(
            height: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                  turns: _animationController,
                  child: const Center(
                    child: CircularProgress(),
                  ),
                ),
                spaceW(8),
                MyText(
                  '加载中...',
                  size: 13.sp,
                  color: k9(),
                  weight: FontWeight.normal,
                )
              ],
            ),
          );          
        } else {
          return SizedBox(
            height: 60.w,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                widget.noDataText ?? '没有更多数据了',
                size: 13.sp,
                color: k9(),
                weight: FontWeight.normal,
              )
            ]
          ),
          );
        }
      }
    );
  }
}

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.w, 
      height: 22.w,
      child: CustomPaint(
        painter: CirclePainter(),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w;

    // 绘制浅蓝色部分 (左半圆)
    paint.color = kCDDDFF();
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      1.57, // 从90度开始 (1.57弧度)
      3.14, // 绘制180度 (3.14弧度)
      false,
      paint,
    );

    // 绘制深蓝色部分 (右半圆)
    paint.color = k4A83FF();
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -1.57, // 从-90度开始 (-1.57弧度)
      3.14, // 绘制180度
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // 不需要重复绘制
  }
}
