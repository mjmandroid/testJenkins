import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:desk_cloud/utils/app_colors.dart';

import 'my_gesture_detector.dart';

class MyButton extends StatelessWidget {
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;
  final String? title;
  final Widget? child;
  final Decoration? decoration;
  final Decoration? disableDecoration;
  final Alignment alignment;
  final TextStyle? style;
  final TextStyle? disableStyle;
  final bool disable;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  const MyButton(
    {
      Key? key,
      this.width,
      this.height,
      this.onTap,
      this.title,
      this.child,
      this.decoration,
      this.disableDecoration,
      this.alignment = Alignment.center,
      this.style,
      this.disableStyle,
      this.disable = false,
      this.margin,
      this.padding
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tempsDisableDecoration = disableDecoration ?? BoxDecoration(
        color: k4A83FF(0.4),
        borderRadius: BorderRadius.circular(12.w)
    );
    var tempsDecoration = decoration ?? BoxDecoration(
        color: k4A83FF(),
        borderRadius: BorderRadius.circular(12.w)
    );
    final tempsStyle = style ?? TextStyle(color: kWhite(),fontSize: 15.sp,fontWeight: FontWeight.w600);
    final tempsDisableStyle = disableStyle ?? TextStyle(color: kWhite(0.4),fontSize: 15.sp,fontWeight: FontWeight.w600);
    return MyGestureDetector(
      onTap: (){
        if (!disable){
          onTap?.call();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: height,
            margin: margin,
            padding: padding,
            decoration: disable ? tempsDisableDecoration : tempsDecoration,
            alignment: alignment,
            child: child ?? (title == null ? null : Text(title!,style: disable ? tempsDisableStyle : tempsStyle,)) ,
          ),
        ],
      ),
    );
  }
}
