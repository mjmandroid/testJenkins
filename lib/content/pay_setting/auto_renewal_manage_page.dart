import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/member_benefits.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AutoRenewalManagePage extends StatelessWidget {
  const AutoRenewalManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kF8(),
      appBar: MyAppBar(
        backgroundColor: kF8(),
        title: MyText('管理自动续费'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        color: hexColor('#d7e3ff', 1),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '${user.memberEquity.value?.avatar}',
                        width: 50.w,
                        height: 50.w,
                        placeholder: (context, url) => Image.asset(
                          R.assetsIcDefault,
                          width: 50.w,
                          height: 50.w,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          R.assetsIcDefault,
                          width: 50.w,
                          height: 50.w,
                        ),
                      ),
                    ),
                  ),
                  spaceW(12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${user.memberEquity.value?.nickname}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: kBlack(),
                                fontWeight: FontWeight.bold
                              )
                            ),
                            TextSpan(
                              text: ' （${user.memberEquity.value?.mobile}）',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: k6(),
                              )
                            ),
                          ],
                        ),
                      ),
                      spaceH(3.5),
                      MyText('已开通自动续费服务', size: 10.sp, color: k6(),),
                    ],
                  ))
                ],
              ),
            ),
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(R.assetsAutoRenewalBg), alignment: Alignment.topCenter),
                  color: hexColor('#FFF8F2'),
                  border: Border.all(color: kWhite(), width: 2.w),
                  borderRadius: 20.borderRadius
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 24.w),
                          alignment: Alignment.centerLeft,
                          height: 54.w,
                          child: MyText(
                            user.memberEquity.value?.renewPlan?.productTitle ?? '',
                            size: 16.sp,
                            color: hexColor('#8D4500')
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: MyButton(
                            onTap: () {
                              push(MyRouter.paySetting);
                            },
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Container(
                              width: 70.w,
                              height: 27.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(19.w),
                                  topRight: Radius.circular(19.w),
                                ),
                                border: Border.all( width: 1.w, color: kWhite())
                              ),
                              child: MyText('支付管理', size: 12.sp, color: hexColor('#C58C53'), weight: FontWeight.normal),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 11.5.w, right: 11.5.w, bottom: 18.5.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 13.5.w, vertical: 13.5.w),
                        decoration: BoxDecoration(
                          color: kWhite(),
                          borderRadius: 16.borderRadius
                        ),
                        child: Column(
                          children: [
                            _buildItem(title: '下次续费日期', value: user.memberEquity.value?.renewPlan?.payTime ?? '', subTitle: '会员到期前一天发起扣款'),
                            _buildItem(title: '下次续费金额', value: user.memberEquity.value?.renewPlan?.sellMoney ?? '', subPrice: '(${user.memberEquity.value?.renewPlan?.showMoney})'), 
                            _buildItem(title: '支付方式', value: user.memberEquity.value?.renewPlan?.payType ?? ''), 
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
            spaceH(12),
            const MemberBenefits(),
            spaceH(24),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '会员协议',
                    style: TextStyle(
                      color: k6(),
                      fontSize: 10.sp,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      push(MyRouter.webView, args: {'title': '用户协议', 'url': user.appInitData.value!.agreement!.reg});
                    }
                  ),
                  TextSpan(
                    text: '  |  ',
                    style: TextStyle(
                      color: k6(),
                      fontSize: 10.sp,
                    ),
                  ),
                  TextSpan(
                    text: '自动续费规则',
                    style: TextStyle(
                      color: k6(),
                      fontSize: 10.sp,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      push(MyRouter.webView, args: {'title': '续费协议', 'url': user.appInitData.value!.agreement!.renew});
                    }
                  ),
                ],
              ),
            ),
            spaceH(safeAreaBottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({required String title, required String value, String? subTitle, String? subPrice}) {
    return SizedBox(
      height: 43.5.w,
      child: Row(
        children: [
          MyText(title, size: 12.sp, color: k6(), weight: FontWeight.normal),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: value, style: TextStyle(fontSize: 13.sp, color: k3())),
                  if (subPrice != null) TextSpan(text: subPrice, style: TextStyle(fontSize: 13.sp, color: k9())),
                ])
              ),
              if (subTitle != null) MyText(subTitle, size: 10.sp, color: k9(), weight: FontWeight.normal),
            ],
          )
        ],
      ),
    );
  }
}