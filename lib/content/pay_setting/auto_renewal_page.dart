import 'package:desk_cloud/alert/close_auto_renewal_dialog.dart';
import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/content/pay_setting/auto_renewal_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class AutoRenewalPage extends StatefulWidget {
  const AutoRenewalPage({super.key});

  @override
  State<AutoRenewalPage> createState() => _AutoRenewalPageState();
}

class _AutoRenewalPageState extends BaseXState<AutoRenewalLogic, AutoRenewalPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kF5(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          title: MyText(
            '自动续费',
            size: 16,
          ),
        ),
        body: Obx(() {
          if (autoRenewalLogic.autoRenewal.value == null) return const Center(child: EmptyView(),);
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: 343.w,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: kWhite(),
                    borderRadius: 20.borderRadius
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText(
                        '快兔会员连续包月',
                        size: 16.sp,
                        weight: FontWeight.normal,
                      ),
                      spaceH(24.h),
                      _item(title: '当前状态', subTitle: autoRenewalLogic.autoRenewal.value!.status == 1 ? '生效中' : '已关闭'),
                      spaceH(12.h),
                      _item(title: '开通时间', subTitle: '${autoRenewalLogic.autoRenewal.value!.createtime}'),
                      spaceH(12.h),
                      _item(title: '开通账号', subTitle: '${autoRenewalLogic.autoRenewal.value!.mobile}')
                    ],
                  )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MyButton(
                  title: '关闭扣费服务',
                  height: 49.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: const BoxDecoration(
                    color: Colors.transparent
                  ),
                  style: TextStyle(
                    color: k2C54AA(),
                    fontSize: 14.sp
                  ),
                  onTap: () async {
                    var res = await showNormalDialog(title: '关闭扣费', message: '关闭后，服务到期时将不再自动扣费，确定关闭？', dismissible: false);
                    if (!res) return;
                    autoRenewalLogic.reSendCloseAutoRenewalSmsCode();
                    var closeAutoRenewalRes = await showCloseAutoRenewalDialog(dismissible: false);
                    if (!closeAutoRenewalRes) return;
                    autoRenewalLogic.submitCloseAutoRenewal();
                  },
                ),
              )
            ],
          );
        })
      ),
    );
  }

  Widget _item({required String title, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          title,
          size: 12.sp,
          color: k6(),
          weight: FontWeight.normal,
        ),
        MyText(
          subTitle,
          size: 12.sp,
          color: k3(),
          weight: FontWeight.normal,
        )
      ],
    );
  }
  
  @override
  AutoRenewalLogic get initController => AutoRenewalLogic();
}