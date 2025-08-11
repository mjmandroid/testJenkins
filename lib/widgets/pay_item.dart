import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class PayItem extends StatefulWidget {
  final int index;
  final String payTitle;
  final String payType;
  final bool selected;
  final ValueChanged valueChanged;
  const PayItem({required this.index, required this.payTitle, required this.payType, this.selected = false, required this.valueChanged, super.key});
  @override
  State<PayItem> createState() => _PayItemState();
}

class _PayItemState extends State<PayItem> {
  @override
  Widget build(BuildContext context) {
    return MyInkWell(
      onTap: () => widget.valueChanged(widget.index),
      child: SizedBox(
        height: 56.h,
        child: Row(
          children: [
            Expanded(child: Row(
              children: [
                Image.asset(
                  widget.payType == 'alipay' ? R.assetsIcPayAli : widget.payType == 'wechat' ? R.assetsIcPayWechat : R.assetsIcPayApple,
                  width: 24.w,
                  height: 24.w,
                ),
                spaceW(14),
                MyText(
                  widget.payTitle,
                  size: 14.sp,
                  weight: FontWeight.normal,
                )
              ],
            )),
            Image.asset(
              widget.selected ? R.assetsCheckRoundY : R.assetsCheckRoundN,
              width: 14.w,
              height: 14.w,
            )
          ],
        ),
      ),
    );
  }
}