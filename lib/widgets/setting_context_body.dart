import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class SettingContextBody extends StatelessWidget {

  const SettingContextBody({super.key, required this.items, this.topAndBottomPadding = true, this.radius = 20});

  final List<Widget> items;

  final bool topAndBottomPadding;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Container(
        padding: EdgeInsets.symmetric(vertical: topAndBottomPadding ? 8.w : 0),
        decoration: BoxDecoration(
          color: kWhite(),
          borderRadius: radius.borderRadius
        ),
        child: Column(
          children: items.map((item) {
            return item;
          }).toList(),
        )
      ),
    );
  }
}


class SettingContextItem extends StatelessWidget {

  const SettingContextItem({super.key, required this.title, required this.onTap, this.subTitle = '',  this.subWidget, this.showBorder = true, this.tipStr = '', this.showNext = true, this.titleColor});

  final String title;

  final GestureTapCallback onTap;

  final String? subTitle;

  final Widget? subWidget;

  final bool? showBorder;

  final String? tipStr;

  final bool? showNext;

  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return MyInkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          height: 44.w,
          decoration: BoxDecoration(
            border: showBorder! ? Border(
              bottom: BorderSide(
                width: 1.w,
                color: kE()
              )
            ) : null
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title,
                    size: 14.sp,
                    weight: FontWeight.bold,
                    color: titleColor ?? kBlack(),
                  ),
                  tipStr!.isEmpty ? const SizedBox() : MyText(
                    tipStr!,
                    size: 10.sp,
                    color: k3(),
                  )
                ],
              ),
              Row(
                children: [
                  MyText(
                    '$subTitle',
                    size: 14.sp,
                    weight: FontWeight.normal,
                    color: k6()
                  ),
                  subWidget ?? const SizedBox(),
                  showNext! ? Image.asset(
                    R.assetsIcNext,
                    width: 24.w,
                    height: 24.w,
                  ) : const SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}