import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future<dynamic> showOpenMemberDiscountDialog() {
  return showDialog(context: CustomNavigatorObserver().navigator!.context,
    builder: (context) {
      return const OpenMemberDiscountView();
    },
    barrierDismissible: false,
  );
}

class OpenMemberDiscountView extends StatefulWidget {
  
  const OpenMemberDiscountView({super.key});

  @override
  State<OpenMemberDiscountView> createState() => _OpenMemberDiscountViewState();
}

class _OpenMemberDiscountViewState extends State<OpenMemberDiscountView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.w,
        height: 427.w,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(R.assetsOpenMemberDiscountBg))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: MyButton(
                onTap: () {
                  pop(args: true);
                },
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),
                child: Image.asset(
                  R.assetsIcCloseDialog,
                  width: 21.w,
                  height: 21.w,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 23.w, right: 23.w, bottom: 21.w),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 24.w),
                    child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeWidget(memberLogic.days.value),
                        spaceW(6),
                        _buildTimeText('天'),
                        spaceW(6),
                        _buildTimeWidget(memberLogic.hours.value),
                        spaceW(6),
                        _buildTimeText('时'),
                        spaceW(6),
                        _buildTimeWidget(memberLogic.minutes.value),
                        spaceW(6),
                        _buildTimeText('分'),
                        spaceW(6),
                        _buildTimeWidget(memberLogic.seconds.value),
                        spaceW(6),
                        _buildTimeText('秒'),
                      ],
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyButton(
                        width: 120.w,
                        height: 40.w,
                        title: '忍痛放弃',
                        decoration: BoxDecoration(
                          color: kWhite(),
                          borderRadius: 28.borderRadius
                        ),
                        style: TextStyle(
                          color: k8D4015(),
                          fontSize: 17.sp,
                        ),
                        onTap: () {
                          pop(args: true);
                        },
                      ),
                      MyButton(
                        width: 120.w,
                        height: 40.w,
                        title: '开通会员',
                        decoration: BoxDecoration(
                          borderRadius: 28.borderRadius,
                          gradient: LinearGradient(
                            colors: [kFF177E(), kFF7429()]
                          )
                        ),
                        style: TextStyle(
                          color: kWhite(),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold
                        ),
                        onTap: () {
                          pop(args: false);
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWidget(String time) {
    return Container(
      width: 28.w,
      height: 28.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: k8D4015(),
        borderRadius: 6.borderRadius
      ),
      child: MyText(
        time,
        size: 18.sp,
        color: kWhite(),
        weight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTimeText(String timeText) {
    return MyText(
      timeText,
      size: 16.sp,
      color: k8D4015(),
      weight: FontWeight.normal,
    );
  }
}