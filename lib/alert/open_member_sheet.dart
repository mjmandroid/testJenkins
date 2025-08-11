import 'package:desk_cloud/alert/open_member_discount_dialog.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/consent_agreement.dart';
import 'package:desk_cloud/widgets/member_products_view.dart';
import 'package:desk_cloud/widgets/pay_item.dart';
import 'package:flutter/material.dart';

enum OpenMemberType {
  /// 回收站
  recycleBin('解锁专享回收站特权', '文件恢复服务+回收站保留%d，不怕误删'),
  /// 视频上传
  videoUpload('解锁视频上传特权', '原画视频极速上传，省时更高效'),
  /// 储存空间
  storage('解锁专享大储存空间', '海量文件任意存放，安全又省心'),
  /// 极速下载
  download('解锁专享极速下载特权', '独享专属带宽，下载速度快人一步'),
  /// 大文件上传
  largeFileUpload('解锁享大文件上传特权', '轻松上传超大文件，高效便捷不受限'),
  /// 在线视频播放
  onlineVideoPlay('解锁在线视频播放特权', '极速加载，流畅播放不卡顿'),
  /// 无限提取
  extractFile('解锁无限提取次数特权', '提取无上限，畅享便利新体验'),
  /// 在线解压
  extractZip('解锁专享在线解压特权', '无需下载，压缩文件一键在线解压更便捷'),
  /// 下载任务数
  downloadTaskCount('解锁专享下载任务数特权', '下载任务数更多，下载更高效'),
  /// 上传任务数
  uploadTaskCount('解锁专享上传任务数特权', '上传任务数更多，上传更高效'),
  ;
  const OpenMemberType(this.title, this.subTitle);

  final String title;
  final String subTitle;

  /// 获取实际的副标题文本
  String get daysSubTitle {
    if (this == OpenMemberType.recycleBin) {
      final days = memberLogic.vipPowersEntity.value?.recycleExpiredDays?.vip1?.value ?? 0;
      return subTitle.replaceAll('%d', days.toString());
    }
    return subTitle;
  }
}

Future<dynamic> showOpenMemberSheet({ OpenMemberType? openMemberType, String? title, String? subTitle}) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
    builder: (context) {
      return _OpenMemberView(openMemberType: openMemberType, title: title, subTitle: subTitle);
    },
    backgroundColor: Colors.transparent,
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
  );
}

class _OpenMemberView extends StatefulWidget {

  const _OpenMemberView({ required this.openMemberType, required this.title, required this.subTitle });

  final OpenMemberType? openMemberType;
  final String? title;
  final String? subTitle;
  
  @override
  State<_OpenMemberView> createState() => _OpenMemberViewState();
}

class _OpenMemberViewState extends BaseXState<OpenMemberLogic, _OpenMemberView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.only(bottom: safeAreaBottom),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: 20.radius),
          color: kF8()
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Image.asset(
                R.assetsIcOpenMemberBg,
                width: 375.w,
                height: 70.w,
              ),
              Container(
                width: 375.w,
                height: 70.w,
                padding: EdgeInsets.only(left: 24.w, right: 26.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        maskText(
                          widget: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MyText(
                                '开通会员',
                                color: k3(),size: 18.sp,
                              ),
                              spaceW(8),
                              MyText(
                                widget.openMemberType?.title ?? widget.title ?? '',
                                color: k3(),size: 14.sp,
                              )
                            ],
                          ), 
                          colors: [hexColor('#C05E00'),hexColor('#713801'),k713801()]
                        ),
                        MyText(widget.openMemberType?.daysSubTitle ?? widget.subTitle ?? '', color: k713801(), size: 12.sp, weight: FontWeight.normal,),
                      ],
                    ),
                    MyButton(
                      onTap: () async {
                        var r = await showOpenMemberDiscountDialog();
                        if (r == true) {
                          pop();
                        }
                      },
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Image.asset(
                        R.assetsDialogClose,
                        width: 28.w,
                        height: 28.w,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Obx(() => MemberProductsView(
            memberProducts: memberLogic.memberProducts.value ?? [], 
            selectedIndex: logic.selectedMemberIndex.value, 
            showAnimation: false,
            changeIndex: (index) {
              logic.selectedMemberIndex.value = index;
              logic.configurationPayList();
              logic.selectedPayTypeIndex.value = 0;
            }
          )),
          Container(
            width: 375.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() => logic.productPayTypeArr.length > 1 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceH(16),
                MyText(
                  '选择付款方式',
                  size: 15.sp
                ),
                // spaceH(8),
                // Obx(() => MyText(
                //   '实付金额:${memberLogic.memberProducts.value![logic.selectedMemberIndex.value].sellPrice}',
                //   size: 15.sp,
                //   color: k9(),
                // )),
                // Obx(() => Column(
                //   children: memberLogic.productPayTypeArr.map((item) {
                //     return PayItem(
                //       index: item['index'], 
                //       payTitle: item['title'], 
                //       payType: item['key'], 
                //       selected: item['index'] == logic.selectedPayTypeIndex.value,
                //       valueChanged: (index) {
                //         logic.selectedPayTypeIndex.value = index;
                //       },
                //     );
                //   }).toList(),
                // ))
                Obx(() => Column(
                  children: List.generate(logic.productPayTypeArr.length, (index) {
                    final item = logic.productPayTypeArr[index];
                    return PayItem(
                      index: index, 
                      payTitle: item['title'], 
                      payType: item['key'], 
                      selected: index == logic.selectedPayTypeIndex.value,
                      valueChanged: (index) {
                        logic.selectedPayTypeIndex.value = index;
                      },
                    );
                  }),
                ))
              ],
            // ) : Obx(() => MyText(
            //   '实付金额:${memberLogic.memberProducts.value![logic.selectedMemberIndex.value].sellPrice}',
            //   size: 15.sp,
            //   color: k9(),
            // )),
            ) : const SizedBox()),
          ),
          spaceH(8),
          Obx(() => ConsentAgreement(consentAgreement: logic.readTheTerms.value, onTap: () {
            logic.readTheTerms.value = !logic.readTheTerms.value;
          }, autoRenew: memberLogic.memberProducts.value![logic.selectedMemberIndex.value].autoRenew != 0)),
          Obx(() => MyButton(
            height: 51.w,
            width: 327.w,
            margin: EdgeInsets.only(top: 16.w),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexColor('#FFE0B5'),
                  hexColor('#FFFCF5'),
                  hexColor('#FFE5C1'), 
                ],
                stops: const [0.0, .5, 1]
              ),
              borderRadius: 12.borderRadius,
              border: Border.all(color: hexColor('#FFDE79'), width: .5.w)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.w),
                  child: MyText(
                    memberLogic.memberProducts.value![logic.selectedMemberIndex.value].autoRenew != 0 ? '同意协议并支付' : '立即支付',
                    color: hexColor('#8D4500'),
                    size: 18.sp
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.w,left: 5.w),
                  child: MyText(
                    '¥',
                    color: hexColor('#8D4500'),
                    size: 16.sp,
                    fontFamily: 'oppos',
                  ),
                ),
                MyText(
                  '${double.parse(memberLogic.memberProducts.value![logic.selectedMemberIndex.value].firstPrice ?? '0') > 0 ? memberLogic.memberProducts.value![logic.selectedMemberIndex.value].firstPrice : memberLogic.memberProducts.value![logic.selectedMemberIndex.value].sellPrice}',
                  color: hexColor('#8D4500'),
                  size: 22.sp,
                  fontFamily: 'oppos',
                )
              ],
            ),
            onTap: () {
              logic.submitOpenMember();
            },
          )),
          Container(
            height: 40.w,
            alignment: Alignment.center,
            child: MyText(
              '响应净网行动，严禁传播色情违法内容，否则封号',
              color: kB3(),
              size: 10.sp,
              weight: FontWeight.normal,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
  
  @override
  OpenMemberLogic get initController => OpenMemberLogic();
}

class OpenMemberLogic extends BaseLogic {

  var selectedMemberIndex = 0.obs;

  /// 阅读并同意条款
  var readTheTerms = false.obs;

  /// 选中的支付方式
  var selectedPayTypeIndex = 0.obs;

  submitOpenMember() {
    if (!readTheTerms.value) {
      showShortToast('请阅读并同意相关协议');
      return;
    }
    pop();
    memberLogic.createPay(
      productId: memberLogic.memberProducts.value![selectedMemberIndex.value].id ?? 0, 
      paymentId: productPayTypeArr[selectedPayTypeIndex.value]['paymentId'],
      relationCode: memberLogic.memberProducts.value![selectedMemberIndex.value].relationCode ?? '',
      reaTderm: readTheTerms.value,
      autoRenew: memberLogic.memberProducts.value![selectedMemberIndex.value].autoRenew ?? 0
    );
  }

  /// 商品可使用的支付列表Map对象
  var productPayTypeArr = <Map>[].obs;
  /// 支付列表Map对象
  var payTypeArr = <Map>[].obs;
  final payArr = ['alipay', 'wechat', 'apple'];

  configurationPayList() {
    productPayTypeArr.clear();
    List<String> payTypes = memberLogic.memberProducts.value?[selectedMemberIndex.value].paysGatewayList ?? [];
    for (var item in payTypes) {
      productPayTypeArr.add(payTypeArr.firstWhere((element) => element['key'] == item));
    }
  }

  /// 获取支付列表
  getPayList() async {
    payTypeArr.clear();
    for (var index = 0; index < payArr.length; index++) {
      payTypeArr.add({
        'index': index,
        'key': payArr[index],
        'title': payArr[index] == 'alipay' ? '支付宝支付' : payArr[index] == 'wechat' ? '微信支付' : 'Apple Pay',
        'paymentId': payArr[index] == 'alipay' ? 2 : payArr[index] == 'wechat' ? 1 : 3,
      });
    }
    configurationPayList();
  }

  @override
  void onInit() {
    super.onInit();
    getPayList();
  }

}