import 'package:desk_cloud/alert/subscribe_dialog.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/consent_agreement.dart';
import 'package:desk_cloud/widgets/member_benefits.dart';
import 'package:desk_cloud/widgets/member_products_view.dart';
import 'package:desk_cloud/widgets/pay_item.dart';
import 'package:flutter/material.dart';

class TabMemberPart extends StatefulWidget {
  const TabMemberPart({super.key});

  @override
  State<TabMemberPart> createState() => _TabMemberPartState();
}

class _TabMemberPartState extends BaseXState<TabMemberLogic, TabMemberPart> with AutomaticKeepAliveClientMixin {
  // final ExpansionTileController expansionTileController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      color: kF8(),
      child: Stack(
        children: [
          Obx(() => Image.asset(user.memberEquity.value?.vipStatus == 0 ? R.assetsMemberTopBg : R.assetsMemberTopBg2,
              width: 375.w, height: 230.w)),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Image.asset(
                  R.assetsMemberName,
                  width: 75.w,
                  height: 18.w,
                ),
              ),
              actions: [
                InkWell(
                  highlightColor: Colors.transparent, // 透明色
                  splashColor: Colors.transparent, // 透明色
                  onTap: () {
                    user.jumpService();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "联系客服",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                MyButton(
                  padding: EdgeInsets.only(right: 16.w),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Image.asset(
                    R.assetsIcService,
                    width: 24.w,
                    height: 24.w,
                  ),
                  onTap: () {
                    user.jumpService();
                  },
                ),
                MyButton(
                  padding: EdgeInsets.only(right: 16.w),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Image.asset(
                    R.assetsMemberSettings,
                    width: 24.w,
                    height: 24.w,
                  ),
                  onTap: () {
                    push(MyRouter.setting);
                  },
                )
              ],
            ),
            body: SmartRefresher(
              controller: logic.controller,
              onRefresh: logic.myRefresh,
              enablePullUp: false,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Obx(() => Row(
                        children: [
                          spaceW(24),
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
                                // 错误占位图
                                errorWidget: (context, url, error) => Image.asset(
                                  R.assetsIcDefault,
                                  width: 50.w,
                                  height: 50.w,
                                ),
                              ),
                            ),
                          ),
                          spaceW(12),
                          user.memberEquity.value?.vipStatus == 0
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText('${user.memberEquity.value?.nickname}', color: k3(), size: 16.sp),
                                    spaceH(4),
                                    MyText(
                                      '你还不是快兔会员，无法享受会员权益',
                                      color: k9(),
                                      size: 10.sp,
                                      weight: FontWeight.normal,
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        MyText(
                                          '${user.memberEquity.value?.nickname}',
                                          color: k713801(),
                                          size: 16.sp,
                                          weight: FontWeight.bold,
                                        ),
                                        spaceW(7.5),
                                        Image.asset(
                                          R.assetsMemberVip,
                                          width: 27.w,
                                          height: 15.w,
                                        )
                                      ],
                                    ),
                                    spaceH(4),
                                    MyInkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        if (user.memberEquity.value?.renewPlan == null) return;
                                        push(MyRouter.autoRenewalManage);
                                      },
                                      child: Row(
                                        children: [
                                          MyText(
                                            '会员有效期至 ${user.memberEquity.value?.vipInfo?.timeEnd}',
                                            color: k713801(),
                                            size: 10.sp,
                                            weight: FontWeight.normal,
                                          ),
                                          if (user.memberEquity.value?.renewPlan != null)
                                            Image.asset(
                                              R.assetsIcNextM,
                                              width: 14.w,
                                              height: 14.w,
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                        ],
                      )),
                  Container(
                    height: 50.w,
                    margin: EdgeInsets.only(left: 16.w, top: 14.w, right: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   width: 257.w,
                        //   height: 50.w,
                        //   decoration: BoxDecoration(
                        //     color: kWhite(),
                        //     borderRadius: 14.borderRadius
                        //   ),
                        //   alignment: Alignment.center,
                        //   padding: EdgeInsets.only(left: 16.w,right: 10.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Expanded(
                        //         child: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 MyText(
                        //                   '${user.memberEquity.value!.vipInfo!.useSpace ?? 0} ${user.memberEquity.value!.vipInfo!.useSpaceUnit ?? 'GB'}',
                        //                   color: user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : kBlack(),
                        //                   size: 22.sp,
                        //                   weight: FontWeight.bold,
                        //                   overflow: TextOverflow.ellipsis,
                        //                   fontFamily: 'squadaone',
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.only(top: 8.w),
                        //                   child: MyText(
                        //                     ' / ${user.memberEquity.value!.vipInfo!.maxSpace ?? 0} ${user.memberEquity.value!.vipInfo!.maxSpaceUnit ?? 'GB'}',
                        //                     color: user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : k6(),
                        //                     size: 12.sp,
                        //                     fontFamily: 'squadaone',
                        //                   ),
                        //                 ),
                        //                 const Spacer(),
                        //                 Padding(
                        //                   padding: EdgeInsets.only(top: 9.w),
                        //                   child: MyText(
                        //                     '${user.memberEquity.value!.vipInfo!.usedRate2}',
                        //                     color: user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : kB3(),
                        //                     size: 9.sp
                        //                   ),
                        //                 )
                        //               ],
                        //             ),
                        //             spaceH(4),
                        //             ClipRRect(
                        //               borderRadius: 3.borderRadius,
                        //               child: SizedBox(
                        //                 height: 5.w,
                        //                 child: LinearProgressIndicator(
                        //                   backgroundColor: kF8(),
                        //                   valueColor: AlwaysStoppedAnimation(
                        //                       user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : k4A83FF()
                        //                   ),
                        //                   value: user.memberEquity.value!.vipInfo!.usedRate!.toDouble(),
                        //                 ),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.only(top: 25.w),
                        //         child: maskText(widget: SizedBox(
                        //           width: 65.w,
                        //           child: MyText(
                        //             user.memberEquity.value!.vipStatus! == 0 ? '开会员享大空间' : '权益生效中',
                        //             size: 9.sp,
                        //             textAlign: TextAlign.right,
                        //           ),
                        //         ), colors: [hexColor('#C05E00'),hexColor('#713801'),hexColor('#713801')]),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                            child: Container(
                          height: 50.w,
                          decoration: BoxDecoration(color: kWhite(), borderRadius: 14.borderRadius),
                          padding: EdgeInsets.only(left: 16.w, right: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text.rich(TextSpan(
                                            text:
                                                '${user.memberEquity.value?.vipInfo?.useSpace ?? 0} ${user.memberEquity.value?.vipInfo!.useSpaceUnit ?? 'GB'}',
                                            style: TextStyle(
                                              color: user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : kBlack(),
                                              fontSize: 16.sp,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: 'oppos',
                                            ),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      ' / ${user.memberEquity.value!.vipInfo!.maxSpace ?? 0} ${user.memberEquity.value!.vipInfo!.maxSpaceUnit ?? 'GB'}',
                                                  style: TextStyle(
                                                      color: user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : k6(),
                                                      fontSize: 9.sp,
                                                      fontFamily: 'oppos'))
                                            ]))),
                                    spaceH(4),
                                    Obx(() => ClipRRect(
                                          borderRadius: 3.borderRadius,
                                          child: SizedBox(
                                            height: 5.w,
                                            child: LinearProgressIndicator(
                                              backgroundColor: kF8(),
                                              valueColor: AlwaysStoppedAnimation(
                                                  user.memberEquity.value!.vipInfo!.usedRate!.toDouble() >= 0.8 ? kRed() : k4A83FF()),
                                              value: user.memberEquity.value!.vipInfo!.usedRate!.toDouble(),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.w),
                                child: maskText(
                                    widget: MyText(
                                      user.memberEquity.value!.vipStatus! == 0 ? '开会员享大空间' : '权益生效中',
                                      size: 8.sp,
                                      textAlign: TextAlign.right,
                                    ),
                                    colors: [hexColor('#C05E00'), hexColor('#713801'), hexColor('#713801')]),
                              ),
                            ],
                          ),
                        )),
                        spaceW(8),
                        MyButton(
                          width: 78.w,
                          height: 50.w,
                          decoration: BoxDecoration(color: kWhite(), borderRadius: 14.borderRadius),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                R.assetsMemberDelete,
                                width: 18.w,
                                height: 18.w,
                              ),
                              spaceH(3),
                              MyText(
                                '回收站',
                                color: kBlack(),
                                size: 10.sp,
                              )
                            ],
                          ),
                          onTap: () {
                            push(MyRouter.recycleBin);
                          },
                        )
                      ],
                    ),
                  ),
                  spaceH(16),
                  Obx(() => MemberProductsView(
                      memberProducts: logic.memberProducts.value ?? [],
                      selectedIndex: logic.selectedMemberProducts.value,
                      changeIndex: (index) {
                        logic.selectedMemberProducts.value = index;
                        logic.configurationPayList(selectedMemberProductsIndex: logic.selectedMemberProducts.value);
                        logic.selectedPayTypeIndex.value = 0;
                      })),
                  Obx(() => memberLogic.memberProducts.value?[memberLogic.selectedMemberProducts.value].autoRenew != 0
                      ? Column(
                          children: [
                            spaceH(8),
                            Row(
                              children: [
                                spaceW(16),
                                MyText(
                                  '自动续费¥${memberLogic.memberProducts.value?[memberLogic.selectedMemberProducts.value].sellPrice}/月，可随时取消',
                                  color: kB3(),
                                  size: 10.sp,
                                )
                              ],
                            ),
                          ],
                        )
                      : const SizedBox()),
                  Obx(() => memberLogic.memberProducts.value?[memberLogic.selectedMemberProducts.value].coupon != null
                      ? Column(
                          children: [
                            spaceH(8),
                            Container(
                              margin: EdgeInsets.only(left: 16.w, right: 16.w),
                              decoration: BoxDecoration(borderRadius: 7.borderRadius, border: Border.all(color: kFFBF81())),
                              child: Column(
                                children: [
                                  Container(
                                    height: 32.w,
                                    padding: EdgeInsets.only(left: 9.w, right: 12.w),
                                    // decoration: BoxDecoration(
                                    //   border: Border(
                                    //     bottom: BorderSide(color: kFFBF81(), width: .5.w)
                                    //   )
                                    // ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          R.assetsIcJian,
                                          width: 18.w,
                                          height: 18.w,
                                        ),
                                        spaceW(8),
                                        MyText(
                                          '新人专享优惠',
                                          size: 12.sp,
                                          color: k2(),
                                        ),
                                        const Spacer(),
                                        Text.rich(TextSpan(text: '已减', style: TextStyle(color: kF87B00(), fontSize: 12.sp), children: [
                                          TextSpan(
                                            text:
                                                '¥${memberLogic.memberProducts.value?[memberLogic.selectedMemberProducts.value].coupon?.price ?? 0}',
                                            style: TextStyle(
                                              color: kF87B00(),
                                              fontSize: 12.sp,
                                              fontFamily: 'oppos',
                                            ),
                                          )
                                        ]))
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    final currentProduct = memberLogic.memberProducts.value?[memberLogic.selectedMemberProducts.value];
                                    final hasGiftLabel = currentProduct?.giftTitle?.isNotEmpty == true;
                                    return hasGiftLabel
                                        ? Column(
                                      children: [
                                        Container(
                                          height: 1,
                                          color: kFFBF81(),
                                        ),
                                        Container(
                                          height: 32.w,
                                          padding: EdgeInsets.only(left: 9.w, right: 12.w),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                R.assetsIcSong,
                                                width: 18.w,
                                                height: 18.w,
                                              ),
                                              spaceW(8),
                                              MyText(
                                                currentProduct?.giftTitle ?? '',
                                                size: 12.sp,
                                                color: k2(),
                                              ),
                                              spaceW(20),
                                              MyText(
                                                currentProduct?.giftDesc ?? '',
                                                size: 12.sp,
                                                color: hexColor('#FF3700'),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                        : const SizedBox();
                                  }),
                                ],
                              ),
                            )
                          ],
                        )
                      : const SizedBox()),
                  Obx(() => memberLogic.productPayTypeArr.length > 1 ? _selectedPayBar() : const SizedBox()),
                  spaceH(12),
                  const MemberBenefits(),
                  spaceH(128)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => Container(
                  width: 375.w,
                  height: 103.w,
                  decoration: BoxDecoration(
                      color: kWhite(),
                      borderRadius: BorderRadius.vertical(top: 16.radius),
                      boxShadow: [BoxShadow(color: kBlack(0.06), offset: Offset(0, -8.w), blurRadius: 8.w)]),
                  padding: EdgeInsets.only(bottom: 16.w, top: 12.w),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Obx(() => ConsentAgreement(
                              consentAgreement: logic.readTheTerms.value,
                              autoRenew: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].autoRenew != 0,
                              onTap: () {
                                logic.readTheTerms.value = !logic.readTheTerms.value;
                              })),
                        ),
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 6.w),
                            child: MyButton(
                              width: 327.w,
                              height: 51.w,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    hexColor('#FFE0B5'),
                                    hexColor('#FFFCF5'),
                                    hexColor('#FFE5C1'),
                                  ], stops: const [
                                    0.0,
                                    .5,
                                    1
                                  ]),
                                  borderRadius: 12.borderRadius,
                                  border: Border.all(color: hexColor('#FFDE79'), width: .5.w)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.w),
                                    child: MyText(
                                        memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].autoRenew != 0
                                            ? '同意协议并支付'
                                            : '立即支付',
                                        color: hexColor('#8D4500'),
                                        size: 18.sp),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.w, left: 5.w),
                                    child: MyText(
                                      '¥',
                                      color: hexColor('#8D4500'),
                                      size: 16.sp,
                                      fontFamily: 'oppos',
                                    ),
                                  ),
                                  MyText(
                                    '${double.parse(memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].firstPrice ?? '0') > 0 ? memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].firstPrice : memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].sellPrice}',
                                    color: hexColor('#8D4500'),
                                    size: 22.sp,
                                    fontFamily: 'oppos',
                                  )
                                ],
                              ),
                              onTap: () async {
                                if (memberLogic.checkVersionExamine.value) {
                                  var r = await showSubscribeDialog(
                                      subscriType: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].title,
                                      price: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].sellPrice,
                                      data: memberLogic.thisDate);
                                  if (!r) return;
                                }
                                memberLogic.createPay(
                                    productId: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].id ?? 0,
                                    paymentId: memberLogic.productPayTypeArr[memberLogic.selectedPayTypeIndex.value]['paymentId'],
                                    relationCode:
                                        memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].relationCode ?? '',
                                    reaTderm: memberLogic.readTheTerms.value,
                                    autoRenew: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].autoRenew ?? 0);
                              },
                            ),
                          ),
                          Obx(() => Positioned(
                              top: 6.w,
                              left: 0,
                              child: user.memberEquity.value?.vipStatus == 0
                                  ? Container(
                                      height: 16.w,
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                          borderRadius: 4.borderRadius,
                                          gradient: LinearGradient(colors: [hexColor('#FF1212'), hexColor('#FF8140')])),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            R.assetsIcJinBao,
                                            width: 10.w,
                                            height: 12.h,
                                          ),
                                          spaceW(5),
                                          Obx(() => MyText(
                                                '限时优惠，${logic.days.value}天${logic.hours.value}:${logic.minutes.value}:${logic.seconds.value}后失效',
                                                size: 10.sp,
                                                color: kWhite(),
                                              ))
                                        ],
                                      ),
                                    )
                                  : const SizedBox()))
                        ],
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  _selectedPayBar() {
    return MyInkWell(
      onTap: () {
        showModalBottomSheet(
            context: CustomNavigatorObserver().navigator!.context,
            builder: (context) {
              return Container(
                height: 360.h + safeAreaBottom,
                margin: EdgeInsets.all(10.w),
                padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h, bottom: safeAreaBottom),
                decoration: BoxDecoration(borderRadius: BorderRadius.all( 20.radius), color: kWhite()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            '请选择支付方式',
                            size: 15.sp,
                          ),
                          spaceH(8),
                          MyText(
                            '实付金额:${memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].sellPrice}',
                            size: 15.sp,
                            color: k9(),
                            weight: FontWeight.normal,
                          )
                        ],
                      ),
                    ),
                    // Expanded(child: Obx(() => Column(
                    //   children: memberLogic.productPayTypeArr.map((item) {
                    //     return PayItem(
                    //       index: item['index'],
                    //       payTitle: item['title'],
                    //       payType: item['key'],
                    //       selected: item['index'] == logic.selectedPayTypeIndex.value,
                    //       valueChanged: (index) {
                    //         logic.selectedPayTypeIndex.value = index;
                    //       }
                    //     );
                    //   }).toList(),
                    // ))),
                    Expanded(
                        child: Obx(() => Column(
                                children: List.generate(memberLogic.productPayTypeArr.length, (index) {
                              final item = memberLogic.productPayTypeArr[index];
                              return PayItem(
                                  index: index,
                                  // 直接使用循环的索引
                                  payTitle: item['title'],
                                  payType: item['key'],
                                  selected: index == logic.selectedPayTypeIndex.value,
                                  valueChanged: (index) {
                                    logic.selectedPayTypeIndex.value = index;
                                  });
                            })))),
                    Center(
                      child: MyButton(
                        title: '确认支付',
                        height: 44.h,
                        width: 300.w,
                        decoration: BoxDecoration(borderRadius: 12.borderRadius, color: k4A83FF()),
                        onTap: () {
                          pop();
                          memberLogic.createPay(
                              productId: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].id ?? 0,
                              paymentId: memberLogic.productPayTypeArr[memberLogic.selectedPayTypeIndex.value]['paymentId'],
                              relationCode: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].relationCode ?? '',
                              reaTderm: memberLogic.readTheTerms.value,
                              autoRenew: memberLogic.memberProducts.value![memberLogic.selectedMemberProducts.value].autoRenew ?? 0);
                        },
                      ),
                    ),
                    spaceH(15)
                  ],
                ),
              );
            },
            backgroundColor: Colors.transparent);
      },
      child: Container(
        height: 56.h,
        color: kWhite(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(top: 8.w),
        child: Row(
          children: [
            Obx(() => Expanded(
                    child: Row(
                  children: [
                    Image.asset(
                      memberLogic.productPayTypeArr[memberLogic.selectedPayTypeIndex.value]['key'] == 'alipay'
                          ? R.assetsIcPayAli
                          : memberLogic.productPayTypeArr[memberLogic.selectedPayTypeIndex.value]['key'] == 'wechat'
                              ? R.assetsIcPayWechat
                              : R.assetsIcPayApple,
                      width: 24.w,
                      height: 24.w,
                    ),
                    spaceW(14),
                    MyText(
                      memberLogic.productPayTypeArr[memberLogic.selectedPayTypeIndex.value]['title'],
                      size: 14.sp,
                      weight: FontWeight.normal,
                    )
                  ],
                ))),
            Image.asset(
              R.assetsIcNext,
              width: 24.w,
              height: 24.w,
            )
          ],
        ),
      ),
    );
  }

  @override
  TabMemberLogic get initController => TabMemberLogic();

  @override
  bool get wantKeepAlive => true;
}
