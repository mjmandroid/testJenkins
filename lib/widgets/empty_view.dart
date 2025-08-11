import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String? title;
  const EmptyView({super.key,this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(R.assetsEmpty,width: 100.w,height: 100.w,),
        spaceH(10),
        MyText(title ?? '没有找到记录~',color: k9(),size: 13.w,)
      ],
    );
  }
}
