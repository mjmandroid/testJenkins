import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/entity/member_products_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class MemberProductsView extends StatefulWidget {
  final int selectedIndex;
  final List<MemberProductsEntity> memberProducts;
  final ValueChanged changeIndex;
  /// 是否展示优惠动画
  final bool showAnimation;

  const MemberProductsView({ 
    required this.memberProducts, 
    required this.selectedIndex, 
    required this.changeIndex,
    this.showAnimation = true,
    super.key});

  @override
  State<MemberProductsView> createState() => _MemberProductsViewState();
}

class _MemberProductsViewState extends State<MemberProductsView> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    // 获取目标价格
    // final targetPrice = double.parse(widget.memberProducts[0].firstPrice ?? widget.memberProducts[0].sellPrice ?? '0');
    final targetPrice = double.parse(widget.memberProducts[0].firstPrice ?? '0') > 0 ? double.parse(widget.memberProducts[0].firstPrice ?? '0') : double.parse(widget.memberProducts[0].sellPrice ?? '0');
    
    // 初始化动画
    tabParentLogic.initProductAnimation(this, targetPrice);
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 159.5.w,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 16.w,right: 16.w),
        itemBuilder: (context,index){
          return MyInkWell(
            onTap: () => widget.changeIndex(index),
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
              width: 125.w,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: 14.borderRadius,
                        border: Border.all(
                          color: widget.selectedIndex == index ? hexColor('#FFE1B8') : kE(),
                          width: 3.w
                        ),
                        gradient: widget.selectedIndex == index ? LinearGradient(
                          colors: [hexColor('#FFEED8'),hexColor('#FFFBF8')],
                          begin: Alignment.topCenter,end: Alignment.bottomCenter
                        ) : null
                      ),
                      margin: EdgeInsets.only(top: 9.5.w),
                      padding: EdgeInsets.only(bottom: 8.w,top: 22.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyText(
                                    '${widget.memberProducts[index].title}',
                                    color: widget.selectedIndex == index ? hexColor('#8D4500') : k2(),
                                    size: 14.sp
                                  ),
                                  SizedBox(
                                    height: 51.w,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.w),
                                          child: MyText(
                                            '¥',
                                            color: widget.selectedIndex == index ? hexColor('#8D4500') : k2(),
                                            size: 20.sp,
                                            fontFamily: 'oppos',
                                          ),
                                        ),
                                        index == 0 && widget.showAnimation && !tabParentLogic.isShowProductsAnimation.value ? ListenableBuilder(
                                          listenable: tabParentLogic.productController!,
                                          builder: (context, child) {
                                            return MyText(
                                              (tabParentLogic.productAnimation?.value ?? 0).toStringAsFixed((tabParentLogic.productAnimation?.value ?? 0) % 1 == 0 ? 0 : 2),
                                              color: widget.selectedIndex == index ? hexColor('#8D4500') : k2(),
                                              size: 32.sp,
                                              weight: FontWeight.bold,
                                              fontFamily: 'oppos',
                                            );
                                          },
                                        ) : MyText(
                                          '${double.parse(widget.memberProducts[index].firstPrice ?? '0') > 0 ? widget.memberProducts[index].firstPrice : widget.memberProducts[index].sellPrice}',
                                          color: widget.selectedIndex == index ? hexColor('#8D4500') : k3(),
                                          size: 34.sp,
                                          weight: FontWeight.bold,
                                          fontFamily: 'oppos',
                                        )
                                      ],
                                    ),
                                  ),
                                  MyText(
                                    '¥${widget.memberProducts[index].showPrice}',
                                    color: widget.selectedIndex == index ? hexColor('#8D4500',0.6) : k2(0.6),
                                    size: 12.sp,
                                    decoration: TextDecoration.lineThrough
                                  )
                                ],
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: widget.memberProducts[index].autoRenew != 0 ? 1 : 0,
                            child: Container(
                              width: 109.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                color: widget.selectedIndex == index ? hexColor('#FFEBD1') : kE(),
                                borderRadius: 6.borderRadius
                              ),
                              alignment: Alignment.center,
                              child: MyText(
                                '立减¥${widget.memberProducts[index].unitPrice2}',
                                color: widget.selectedIndex == index ? hexColor('#8D4500') : kBlack(),
                                size: 12.sp,
                                weight: FontWeight.normal,
                              ),
                            ),                          
                          )
                        ],
                      ),
                    ),
                  ),
                  if (widget.memberProducts[index].labelId != 0)
                    IntrinsicWidth(
                      child: Container(
                        height: 18.w,
                        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 1.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [hexColor('#FF7429'),hexColor('#FF177E')]),
                          borderRadius: BorderRadius.only(topLeft: 18.radius,topRight: 9.radius,bottomRight: 9.radius)
                        ),
                        alignment: Alignment.center,
                        child: MyText(
                          '${widget.memberProducts[index].label}',
                          color: kWhite(0.9),
                          size: 11.sp,
                          weight: FontWeight.normal,
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context,index){
          return spaceW(12);
        },
        itemCount: widget.memberProducts.length,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}