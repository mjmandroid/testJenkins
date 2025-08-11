import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/tabs/tab_member_logic.dart';
import '../entity/member_products_entity.dart';
import '../r.dart';
import '../utils/app_colors.dart';
import '../utils/extension.dart';
import '../widgets/pay_item.dart';

class PriceDialog extends StatefulWidget {
  final String title;
  final List<MemberProductsEntity> options;
  final String agreement;
  final String disclaimer;

  const PriceDialog({
    Key? key,
    required this.title,
    required this.options,
    required this.agreement,
    required this.disclaimer,
  }) : super(key: key);

  Future<void> openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('无法打开 $url');
    }
  }
  @override
  State<PriceDialog> createState() => _PriceDialogState();
}

class _PriceDialogState extends State<PriceDialog> {
  bool _isAgreed = false;
  final defaultPayIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 关闭按钮
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // 标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            // 价格选项 - 修改为可滑动的横向列表
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(

            height: 140, // 设置固定高度
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var option in widget.options)
                    if (option.isOpen == 1)
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 16, // 均分屏幕宽度（减去边距）
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildPriceOption(
                          item: option,
                          buttonText: "开通超级会员",
                          type: "1",
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
            const SizedBox(height: 16),

            // 协议同意选项
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Checkbox(
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isAgreed = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      side: const BorderSide(color: Color(0xFFCCCCCC)),
                      checkColor: Colors.white,
                      activeColor: const Color(0xFFF5A623),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "请阅读并同意",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // 处理用户协议点击事件
                          var url =  user.appInitData.value!.agreement!.reg;
                          if(url != null && url.length > 0){
                            push(MyRouter.webView, args: {'title': '用户协议', 'url': url});
                          }
                        },
                        child: Text(
                          widget.agreement,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 免责声明
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Text(
                widget.disclaimer,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _payAction(MemberProductsEntity item) {
    /// 商品可使用的支付列表Map对象
    var productPayTypeArr = <Map>[].obs;
    /// 支付列表Map对象
    var payTypeArr = <Map>[].obs;
    var payArr = item.paysGatewayList;

    for (var index = 0; index < payArr!.length; index++) {
      payTypeArr.add({
        'index': index,
        'key': payArr[index],
        'title': payArr[index] == 'alipay' ? '支付宝支付' : payArr[index] == 'wechat' ? '微信支付' : 'Apple Pay',
        'paymentId': payArr[index] == 'alipay' ? 2 : payArr[index] == 'wechat' ? 1 : 3,
      });
    }
    for (var item1 in payArr) {
      productPayTypeArr.add(payTypeArr.firstWhere((element) => element['key'] == item1));
    }

    {
      showModalBottomSheet(
          context: CustomNavigatorObserver().navigator!.context,
          builder: (context) {
            return Container(
              height: 360.h + safeAreaBottom,
              padding: EdgeInsets.only(
                  left: 24.w, right: 24.w, top: 20.h, bottom: safeAreaBottom),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: 20.radius),
                  color: kWhite()),
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
                          '实付金额: ${ (item.firstPrice != null && double.tryParse(item.firstPrice ?? "0") != null && double.parse(item.firstPrice ?? "0") > 0) ? item.firstPrice : item.sellPrice }',
                          size: 15.sp,
                          color: k9(),
                          weight: FontWeight.normal,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Obx(() =>
                          Column(
                              children: List.generate(
                                  productPayTypeArr.length,
                                      (index) {
                                    final item = productPayTypeArr[index];
                                    return PayItem(
                                        index: index,
                                        // 直接使用循环的索引
                                        payTitle: item['title'],
                                        payType: item['key'],
                                        selected:
                                        index == defaultPayIndex.value,
                                        valueChanged: (index) {
                                          defaultPayIndex.value = index;
                                        });
                                  })))),
                  MyButton(
                    title: '确认支付',
                    height: 44.h,
                    width: 327.w,
                    decoration: BoxDecoration(
                        borderRadius: 12.borderRadius, color: k4A83FF()),
                    onTap: () {
                      pop();
                      memberLogic.createPay(
                          productId:
                          item.id ??
                              0,
                          paymentId: productPayTypeArr[defaultPayIndex.value]['paymentId'],
                          relationCode:item
                              .relationCode ??
                              '',
                          reaTderm: true,
                          autoRenew: item
                              .autoRenew ??
                              0);
                    },
                  ),
                  spaceH(15)
                ],
              ),
            );
          },
          backgroundColor: Colors.transparent);
    }
}



  Widget _buildPriceOption({
    required MemberProductsEntity item,
    required String buttonText,
    required String type,
  }) {
    return Stack(
      clipBehavior: Clip.none, // 允许子组件超出边界
      children: [
        // 主卡片内容
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF4F8FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            children: [
              Text(
                "${item.dayPrices ?? ""}元/天",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5595BC),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.describe ?? "",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFACB0B6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFAEF),Color(0xFFFFE2BA)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isAgreed) {
                      // 处理购买逻辑
                      Navigator.of(context).pop(type);
                      _payAction(item);
                    } else {
                      showShortToast('请阅读并同意相关协议');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 15.sp,  // 修改为使用响应式单位
                      color: Color(0xFF804A0D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 收购优惠角标
        if((item.days ?? "0").toInt() >= 30)
        Positioned(
          top: -20.w,
          left: -4.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 4.w),
              child: Image.asset(R.assetsIcFirstPay, width: 80.w, height: 25.w,)
          ),
        ),
      ],
    );
  }
}