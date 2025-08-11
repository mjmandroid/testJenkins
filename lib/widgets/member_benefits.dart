import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MemberBenefits extends StatelessWidget {
  const MemberBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => !memberLogic.isExpansion.value ? Container(
      margin: EdgeInsets.only(left: 16.w,right: 16.w),
      decoration: BoxDecoration(
        borderRadius: 20.borderRadius,
        color: kWhite()
      ),
      padding: EdgeInsets.only(left: 16.w,right: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 49.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                maskText(widget: MyText('会员尊享权益',color: k3(),size: 15.sp,), colors: [hexColor('#C05E00'),hexColor('#713801'),k713801()]),
                MyButton(
                  onTap: () {
                    memberLogic.isExpansion.value = !memberLogic.isExpansion.value;
                  },
                  decoration: const BoxDecoration(
                    color: Colors.transparent
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText(
                        memberLogic.isExpansion.value ? '收起特权对比' : '展开特权对比',
                        size: 12.sp,
                        color: k6(),
                        weight: FontWeight.normal,
                      ),
                      Transform.rotate(
                        angle: math.pi,
                        child: Image.asset(
                        R.assetsIcDowne,
                          width: 24.w,
                          height: 24.w,
                        ),
                      )
                    ],
                  ),
                )                       
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 5.5.w),
            decoration: BoxDecoration(
              color: hexColor('#FFFBF7'),
              borderRadius: 14.borderRadius
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 3.w,
                crossAxisSpacing: 6.w,
                childAspectRatio: 56.w/68.w
              ),
              itemBuilder: (context,index){
                var item = memberLogic.equityList[index];
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(item.icon ?? '',width: 38.w,height: 38.w,),
                      spaceH(3),
                      MyText(item.title ?? '',color: kBlack(0.6),size: 8.sp,)
                    ],
                  ),
                );
              },
              itemCount: memberLogic.equityList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            ),
          )
        ],
      ),
    ) : _vipPowersBar());
  }

  _vipPowersBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite(),
          borderRadius: 20.borderRadius
        ),
        child: Column(
          children: [
            Container(
              height: 49.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  maskText(widget: MyText('会员尊享权益',color: k3(),size: 15.sp,), colors: [hexColor('#C05E00'),hexColor('#713801'),k713801()]),
                  MyButton(
                    onTap: () {
                      memberLogic.isExpansion.value = !memberLogic.isExpansion.value;
                    },
                    decoration: const BoxDecoration(
                      color: Colors.transparent
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyText(
                          memberLogic.isExpansion.value ? '收起特权对比' : '展开特权对比',
                          size: 12.sp,
                          color: k6(),
                          weight: FontWeight.normal,
                        ),
                        Image.asset(
                          R.assetsIcDowne,
                          width: 24.w,
                          height: 24.w,
                        )
                      ],
                    ),
                  )                       
                ],
              ),
            ),
            _vipPowersTitleBar(),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.maxDisk?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxDisk?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxDisk?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxDisk?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxDisk?.vip0?.value ?? ''), 
              backgroundColor: true
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.codeLimitDays?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.codeLimitDays?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.codeLimitDays?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.codeLimitDays?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.codeLimitDays?.vip0?.value ?? '')
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.maxTaskUpload?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxTaskUpload?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxTaskUpload?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxTaskUpload?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxTaskUpload?.vip0?.value ?? ''),
              backgroundColor: true
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.boolUnzip?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.boolUnzip?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.boolUnzip?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.boolUnzip?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.boolUnzip?.vip0?.value ?? '')
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.maxDownloadSpeed?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxDownloadSpeed?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxDownloadSpeed?.vip1?.value?? '0'), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxDownloadSpeed?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxDownloadSpeed?.vip0?.value ?? '0'),
              backgroundColor: true
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.boolPlayOnline?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.boolPlayOnline?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.boolPlayOnline?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.boolPlayOnline?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.boolPlayOnline?.vip0?.value ?? '')
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.maxUploadSize?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxUploadSize?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxUploadSize?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxUploadSize?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxUploadSize?.vip0?.value ?? ''),
              backgroundColor: true
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.recycleExpiredDays?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.recycleExpiredDays?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.recycleExpiredDays?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.recycleExpiredDays?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.recycleExpiredDays?.vip0?.value ?? '')
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.codeMaxFiles?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.codeMaxFiles?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.codeMaxFiles?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.codeMaxFiles?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.codeMaxFiles?.vip0?.value ?? ''),
              backgroundColor: true
            ),
            _vipPowersRow(
              title: memberLogic.vipPowersEntity.value?.maxTaskDownload?.name ?? '', 
              vipValue: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxTaskDownload?.vip1?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxTaskDownload?.vip1?.value ?? ''), 
              value: memberLogic.vipPowersValueConvert(memberLogic.vipPowersEntity.value?.maxTaskDownload?.vip0?.showValue ?? '', memberLogic.vipPowersEntity.value?.maxTaskDownload?.vip0?.value ?? '')
            ),
            MyButton(
              height: 44.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.transparent
              ),
              title: '收起特权对比',
              style: TextStyle(
                fontSize: 14.sp,
                color: k6()
              ),
              onTap: () {
                memberLogic.isExpansion.value = false;
              },
            )
          ],
        ),
      )
    );
  }

  Widget _vipPowersTitleBar() {
    return SizedBox(
      height: 44.w,
      child: Row(
        children: [
          Expanded(child: Padding(
            padding: EdgeInsets.only(top: 8.w),
            child: Container(
              alignment: Alignment.center,
              color: kF8(),
              child: MyText(
                '权益',
                size: 14.sp,
                color: kBAA998(),
              ),
            ),
          )),
          Expanded(child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [hexColor('#FFF6ED'),hexColor('#FFE2C5')]),
              borderRadius: BorderRadius.vertical(top: 12.radius)
            ),
            child: Image.asset(
              R.assetsMemberVip,
              width: 40.w,
              height: 22.w,
            ),
          )),
          Expanded(child: Padding(
            padding: EdgeInsets.only(top: 8.w),
            child: Container(
              alignment: Alignment.center,
              color: kF8(),
              child: MyText(
                '普通用户',
                size: 14.sp,
                color: k6(),
              ),
            ),
          )),
        ],
      ),
    );
  }

  _vipPowersRow({required String title, required String vipValue, required String value, bool backgroundColor = false}) {
    return Row(
      children: [
        _vipPowersItemBar(isTitle: true, text: title, backgroundColor: backgroundColor),
        _vipPowersItemBar(isVip: true, text: vipValue, backgroundColor: backgroundColor),
        _vipPowersItemBar(text: value, backgroundColor: backgroundColor),
      ],
    );
  }

  _vipPowersItemBar({bool isVip = false, bool isTitle = false, String text = '', bool backgroundColor = false}) {
    return Expanded(
      child: Container(
        height: 36.w,
        alignment: Alignment.center,
        color: isVip && backgroundColor ? kFFF6ED() : isVip ? kFFF3E6() : backgroundColor ? kWhite() : kF8(),
        child: text.isEmpty ? Image.asset(
          R.assetsIcAllow,
          width: 24.w,
          height: 24.w,
        ) : MyText(
          text,
          size: 14.sp,
          color: isTitle ? k3() : isVip ? kA34200() : k6(),
        ),
      ),
    );
  }
}