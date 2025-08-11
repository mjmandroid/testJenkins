import 'dart:io';

import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class PaySettingPage extends StatelessWidget {
  const PaySettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          title: MyText(
            '支付设置',
            size: 16,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              MyInkWell(
                onTap: () => push(MyRouter.autoRenewal),
                child: Container(
                  height: 44.w,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: kWhite(),
                    borderRadius: 14.borderRadius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        '自动续费',
                        weight: FontWeight.bold,
                        size: 14.sp,
                      ),
                      Image.asset(
                        R.assetsIcNext,
                        width: 24.w,
                        height: 24.w,
                      )
                    ],
                  ),
                ),
              ),
              spaceH(16),
              if (Platform.isIOS)
                MyInkWell(
                  onTap: () {
                    memberLogic.restoreOrders();
                  },
                  child: Container(
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: kWhite(),
                      borderRadius: 20.borderRadius
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          '恢复订阅',
                          weight: FontWeight.bold,
                          size: 14.sp,
                        ),
                        Image.asset(
                          R.assetsIcNext,
                          width: 24.w,
                          height: 24.w,
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}