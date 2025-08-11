import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/recycle_bin/recycle_bin_logic.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RecycleBinPage extends StatefulWidget {
  const RecycleBinPage({super.key});

  @override
  State<RecycleBinPage> createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends BaseXState<RecycleBinLogic, RecycleBinPage> with TickerProviderStateMixin {

  Animation<double>? _bottomAnima;
  AnimationController? _animaC;
  TickerProvider? _provider;

  @override
  void initState() {
    super.initState();
    _provider = this;
    _animaC?.reset();
    _animaC?.dispose();
    _animaC = AnimationController(duration: 0.18.seconds, vsync: _provider!);
   _bottomAnima = Tween<double>(begin: -(safeAreaBottom + 150.w),end: 0).animate(CurvedAnimation(parent: _animaC!, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: MyText(
          '回收站',
          size: 18.sp,
        ),
        actions: [
          MyButton(
            margin: EdgeInsets.only(right: 16.w),
            decoration: const BoxDecoration(
              color: Colors.transparent
            ),
            child: Image.asset(
              R.assetsIcClear,
              width: 24.w,
              height: 24.w,
            ),
            onTap: () async {
              var r = await showNormalDialog(title: '提醒', message: '确定清除所有内容吗？');
              if (r != true){
                return;
              }
              recycleBinLogic.recycleDel(_animaC, delAll: true);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Column(
            children: [
              _vipBar(),
              MyButton(
                height: 56.w,
                width: 375.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),
                onTap: () {
                  recycleBinLogic.sort.value = recycleBinLogic.sort.value == 'desc' ? 'asc' : 'desc';
                  recycleBinLogic.onRefresh();
                },
                child: Row(
                  children: [
                    MyText(
                      '按删除时间', 
                      color: k6(), 
                      size: 14.sp,
                      weight: FontWeight.normal,
                    ),
                    spaceW(8),
                    Obx(() {
                      return Transform.rotate(
                        angle: recycleBinLogic.sort.value == 'desc' ? math.pi : 0,
                        child: Image.asset(R.assetsFileSort, width: 10.w, height: 16.w,)
                      );
                    })
                  ],
                ),
              ),
              SizedBox(
                height: 24.h,
                child: Obx(() => logic.tabs.isEmpty ? Container() : ListView.separated(
                  itemBuilder: (context, index) {
                    return MyButton(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      margin: EdgeInsets.only(left: index == 0 ? 16.w : 0, right: index == recycleBinLogic.tabs.length - 1 ? 16.w : 0),
                      title: recycleBinLogic.tabs[index].name!,
                      decoration: BoxDecoration(
                        borderRadius: 8.borderRadius,
                        color: index == recycleBinLogic.tabsIndex.value ? kEDF3FF() : kBlack(.03),
                      ),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: index == recycleBinLogic.tabsIndex.value ? k4A83FF() : kB3(),
                        fontWeight: FontWeight.bold
                      ),
                      onTap: () {
                        recycleBinLogic.tabsIndex.value = index;
                        recycleBinLogic.onRefresh();
                      },
                    );
                  }, 
                  separatorBuilder: (context, index) {
                    return spaceW(10);
                  }, 
                  itemCount: recycleBinLogic.tabs.length,
                  scrollDirection: Axis.horizontal,
                )),
              ),
              spaceH(12),
              Expanded(child: Obx(() {
                if (recycleBinLogic.recycleList.isEmpty) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      height: 300.w,
                      alignment: Alignment.center,
                      child: const EmptyView(),
                    ),
                  );
                } else {
                  return SmartRefresher(
                    controller: recycleBinLogic.controller,
                    onRefresh: recycleBinLogic.onRefresh,
                    onLoading: recycleBinLogic.onLoading,
                    enablePullUp: true,
                    // footer: ClassicFooter(
                    //   noDataText: recycleBinLogic.recycleList.isNotEmpty != true ? '' : null,
                    // ),
                    footer: MyCustomFooter(
                      noDataText: recycleBinLogic.recycleList.isNotEmpty != true ? '' : null,
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var item = recycleBinLogic.recycleList[index];
                        return InkWell(
                          onTap: () {
                            recycleBinLogic.changeRecycleItemSelected(item, _animaC);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            color: item.selected! ? kEDF3FF() : kWhite(),
                            child: Row(
                              children: [
                                // Image.asset(item.fileType?.fileTypeIcon ?? '', width: 32.w, height: 32.w),
                                (item.fileType != 1 && item.fileType != 2) || item.thumb == null || item.thumb == '' ? 
                                  Image.asset(
                                    item.fileType?.fileTypeIcon ?? '', 
                                    width: 32.w, 
                                    height: 32.w
                                  ) : ClipRRect(
                                      borderRadius: 3.borderRadius,
                                      child: CachedNetworkImage(
                                      imageUrl: '${user.memberEquity.value?.avatar}',
                                      width: 32.w,
                                      height: 32.w,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        R.assetsIcDefault,
                                        width: 32.w,
                                        height: 32.w,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        R.assetsIcDefault,
                                        width: 32.w,
                                        height: 32.w,
                                      ),
                                    ),
                                  ),
                                spaceW(16),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      '${item.name}',
                                      size: 13.sp,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    spaceH(3),
                                    Row(
                                      children: [
                                        MyText(
                                          '${item.createtime}',
                                          size: 10.sp,
                                          color: k9(),
                                        ),
                                        spaceW(6),
                                        MyText(
                                          item.fileType == 0 ? '${item.fileCount}项' : '${item.fileSize}',
                                          size: 10.sp,
                                          color: k9(),
                                        ),
                                        spaceW(6),
                                        MyText(
                                          '${item.expireddays}天后清除',
                                          size: 10.sp,
                                          color: k9(),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                                CheckView(size: 14.w, selected: item.selected ?? false)
                              ],
                            ),
                          ),
                        );
                      }, 
                      separatorBuilder: (context, index) {
                        return spaceH(0);
                      }, 
                      itemCount: recycleBinLogic.recycleList.length
                    ),
                  );
                }
              })),
              Obx(() => SizedBox(height: logic.showBottonAction.value ? safeAreaBottom + 70.w : 0))
            ],
          )),
          _bottomAction()
        ],
      )
    );
  }

  Widget _vipBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 28.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            kFFF5EC(),
            kWhite()
          ],
          stops: const [0.0, .8]
        )
      ),
      child: Obx(() => user.memberEquity.value!.vipStatus == 1 ? Row(
        children: [
          Image.asset(
            R.assetsIoVip,
            width: 27.w,
            height: 15.w,
          ),
          spaceW(8),
          MyText(
            '会员尊享，回收站保持有效期${user.memberEquity.value?.configInfo?.recycleExpiredDays?.last ?? 0}天',
            size: 11.sp,
            color: kE77700(),
            weight: FontWeight.normal,
          )
        ],
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            '已删除内容不占用空间，${user.memberEquity.value?.configInfo?.recycleExpiredDays?.last ?? 0}天后自动清除',
            size: 11.sp,
            color: kE77700(),
            weight: FontWeight.normal,
          ),
          MyButton(
            title: '延迟至${memberLogic.vipPowersEntity.value?.recycleExpiredDays?.vip1?.value ?? 0}',
            width: 66.w,
            height: 22.w,
            alignment: Alignment.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: k713801(),
              fontWeight: FontWeight.bold
            ),
            decoration: BoxDecoration(
              borderRadius: 6.borderRadius,
              color: kFFECDA()
            ),
            onTap: () {
              showOpenMemberSheet(openMemberType: OpenMemberType.recycleBin);
            },
          )                    
        ],
      )),
    );
  }

  Widget _bottomAction() {
    return () {
    if (_bottomAnima == null) return Container();
    return AnimatedBuilder(animation: _bottomAnima!, builder: (context, child) {
      return Positioned(
        bottom: _bottomAnima!.value,
        child: SizedBox(
          width: 375.w,
          height: safeAreaBottom + 97.w,
          child: Align(
            child: Container(
              width: 343.w,
              height: 73.h,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: kWhite(),
                borderRadius: 16.borderRadius,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2.5.h),
                    blurRadius: 16.w,
                    color: k3(.16)
                  )
                ]
              ),
              child: Row(
                children: [
                  Expanded(child: LayoutBuilder(builder: (context, constraints) {
                    return MyButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            R.assetsIcReduction,
                            width: 18.w,
                            height: 18.w,
                          ),
                          spaceH(8),
                          MyText(
                            '还原',
                            size: 11.sp
                          )
                        ],
                      ),
                      onTap: () {
                        recycleBinLogic.recycle(_animaC);
                      },
                    );
                  })),
                  Expanded(child: LayoutBuilder(builder: (context, constraints) {
                    return MyButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            R.assetsIcReductionDel,
                            width: 18.w,
                            height: 18.w,
                          ),
                          spaceH(8),
                          MyText(
                            '删除',
                            size: 11.sp
                          )
                        ],
                      ),
                      onTap: () async {
                        var r = await showNormalDialog(title: '提醒', message: '确定要删除选中内容吗？');
                        if (r != true){
                          return;
                        }
                        recycleBinLogic.recycleDel(_animaC);
                      },
                    );
                  }))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }();
  }
  
  @override
  RecycleBinLogic get initController => RecycleBinLogic();
}