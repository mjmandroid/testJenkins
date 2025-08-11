import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:desk_cloud/alert/agent_announcement_dialog.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/file/file_search_page.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_command_logic.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class TabCommandPart extends StatefulWidget {
  const TabCommandPart({super.key});

  @override
  State<TabCommandPart> createState() => _TabCommandPartState();
}

class _TabCommandPartState extends BaseXState<TabCommandLogic, TabCommandPart>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      color: kF8(),
      child: Stack(
        children: [
          Image.asset(
            R.assetsHomeTopBg,
            fit: BoxFit.fitWidth,
            width: 375.w,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Image.asset(
                  R.assetsHomeTopName,
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
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
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
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Image.asset(
                    R.assetsIcSearch,
                    width: 24.w,
                    height: 24.w,
                  ),
                  onTap: () {
                    showFileSearch('');
                  },
                ),
                addPopView()
              ],
            ),
            body: Obx(() {
              return SmartRefresher(
                controller: logic.controller,
                onRefresh: logic.onRefresh,
                onLoading: logic.onLoading,
                enablePullUp: true,
                // footer: ClassicFooter(
                //   noDataText: logic.rootDir.value.subs?.isNotEmpty != true ? '' : null,
                // ),
                footer: MyCustomFooter(
                  noDataText:
                      logic.rootDir.value.subs?.isNotEmpty != true ? '' : null,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: spaceH(12)),
                    SliverPadding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 17.w),
                          decoration: BoxDecoration(
                              color: kWhite(), borderRadius: 20.borderRadius),
                          child: Column(
                            children: [
                              Obx(() => Stack(
                                    children: [
                                      user.memberEquity.value?.vipStatus == 0
                                          ? const SizedBox()
                                          : Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Image.asset(R.assetsVipBg,
                                                  width: 240.w, height: 60.h)),
                                      Positioned(
                                          top: 0.w,
                                          right: 0,
                                          child: MyInkWell(
                                            onTap: () {
                                              tabParentLogic.jumpToPage(3);
                                            },
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                    user.memberEquity.value
                                                                ?.vipStatus ==
                                                            0
                                                        ? R.assetsVipDiscount
                                                        : R.assetsVipBanner,
                                                    width: 102.w,
                                                    height: 70.w),
                                                user.memberEquity.value
                                                            ?.vipStatus ==
                                                        0
                                                    ? const SizedBox()
                                                    : Positioned(
                                                        top: 31.5.w,
                                                        right: 11.5.w,
                                                        child: Text.rich(
                                                            TextSpan(children: [
                                                          TextSpan(
                                                              text:
                                                                  '${user.memberEquity.value?.vipInfo?.useSpace?.floor() ?? 0} ${user.memberEquity.value?.vipInfo!.useSpaceUnit ?? 'GB'}',
                                                              style: TextStyle(
                                                                  color:
                                                                      kBF6502(),
                                                                  fontSize:
                                                                      8.sp,
                                                                  fontFamily:
                                                                      'oppos')),
                                                          TextSpan(
                                                              text:
                                                                  ' / ${double.tryParse(user.memberEquity.value!.vipInfo!.maxSpace ?? '0')?.floor()} ${user.memberEquity.value!.vipInfo!.maxSpaceUnit ?? 'GB'}',
                                                              style: TextStyle(
                                                                  color:
                                                                      kBF6502(),
                                                                  fontSize:
                                                                      6.sp,
                                                                  fontFamily:
                                                                      'oppos'))
                                                        ])))
                                              ],
                                            ),
                                          )),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 14.w, right: 14.w, top: 15.w),
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: hexColor('#d7e3ff', 1),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${user.memberEquity.value?.avatar}',
                                                  width: 36.w,
                                                  height: 36.w,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                          R.assetsIcDefault,
                                                          width: 36.w,
                                                          height: 36.w,
                                                          fit: BoxFit.cover),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          R.assetsIcDefault,
                                                          width: 36.w,
                                                          height: 36.w,
                                                          fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                            spaceW(10),
                                            user.memberEquity.value
                                                        ?.vipStatus ==
                                                    0
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                          '${user.memberEquity.value?.nickname}',
                                                          color: k3(),
                                                          size: 14.sp),
                                                      spaceW(2),
                                                      MyText(
                                                        '你还不是快兔会员，无法享受会员权益',
                                                        color: k9(),
                                                        size: 9.sp,
                                                        weight:
                                                            FontWeight.normal,
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                        '${user.memberEquity.value?.nickname}',
                                                        color: k713801(),
                                                        size: 14.sp,
                                                        weight: FontWeight.bold,
                                                      ),
                                                      spaceW(2),
                                                      MyText(
                                                        '会员有效期至 ${user.memberEquity.value?.vipInfo?.timeEnd}',
                                                        color: k713801(),
                                                        size: 9.sp,
                                                        weight:
                                                            FontWeight.normal,
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 14.w, right: 14.w, top: 18.w),
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 72.w / 90.w,
                                          crossAxisSpacing: 9.w),
                                  itemCount: logic.options.length,
                                  itemBuilder: (context, index) {
                                    var item = logic.options[index];
                                    return GestureDetector(
                                      onTap: item.action,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: kFA(),
                                            borderRadius: 14.borderRadius),
                                        alignment: Alignment.center,
                                        // padding: EdgeInsets.symmetric(horizontal: 16.w),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              item.icon ?? '',
                                              width: 28.w,
                                              height: 28.w,
                                            ),
                                            MyText(
                                              item.title ?? '',
                                              size: 11.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          width: 343.w,
                          height: 124.w,
                          decoration: BoxDecoration(
                              borderRadius: 20.borderRadius,
                              // color: kWhite()
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    hexColor('#FCFDFF'),
                                    hexColor('#EFF6FF'),
                                  ]),
                              border: Border.all(
                                  color: hexColor('#FFFFFF'), width: 1.5.w)),
                          // padding: EdgeInsets.only(top: 8.w, left: 16.w, right: 16.w),
                          child: Column(
                            children: [
                              Container(
                                height: 44.w,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: user.memberEquity.value?.vipStatus == 1
                                    ? Row(
                                        children: [
                                          MyText(
                                            '提取',
                                            color: k3(),
                                            size: 15.sp,
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Image.asset(
                                                R.assetsHomeVipTag,
                                                width: 20.w,
                                                height: 11.w,
                                              ),
                                              spaceW(2),
                                              MyText(
                                                '无限次生效中',
                                                color: kE77700(),
                                                size: 11.sp,
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          MyText(
                                            '提取(${user.memberEquity.value?.configInfo?.codeUsedDays ?? 0}/${user.memberEquity.value?.configInfo?.codeLimitDays ?? 0})',
                                            color: k3(),
                                            size: 15.sp,
                                          ),
                                          const Spacer(),
                                          MyButton(
                                            title: '升级无限提取',
                                            style: TextStyle(
                                                color: k4A83FF(),
                                                fontSize: 12.sp,
                                                decoration:
                                                    TextDecoration.underline),
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            onTap: () {
                                              showOpenMemberSheet(
                                                  openMemberType: OpenMemberType
                                                      .extractFile);
                                            },
                                          ),
                                        ],
                                      ),
                              ),
                              // spaceH(10),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 4.w, left: 4.w, right: 4.w),
                                child: Container(
                                  // width: 311.w,
                                  // height: 50.w,
                                  decoration: BoxDecoration(
                                    color: kWhite(),
                                    borderRadius: 17.borderRadius,
                                  ),
                                  padding: EdgeInsets.all(12.w),
                                  // alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: k4A83FF(), width: 0.5.w),
                                        borderRadius: 14.borderRadius,
                                        color: hexColor('#FAFCFF'),
                                        boxShadow: [
                                          BoxShadow(
                                              color: k4A83FF(.12),
                                              blurRadius: 7,
                                              offset: Offset(0, 4.w))
                                        ]),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: MyTextField(
                                          hintText: '输入口令提取文件',
                                          hintStyle: TextStyle(
                                              color: k4A83FF(.5),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                          style: TextStyle(
                                              color: kBlack(),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                          align: TextAlign.left,
                                          controller: logic.textC,
                                          onSubmitted: (v) {
                                            logic.pickUpAction();
                                          },
                                        )),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 13.w),
                                          child: MyButton(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            onTap: () {
                                              logic.pickUpAction();
                                            },
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border(
                                                    left: BorderSide(
                                                        color: k4A83FF(.4),
                                                        width: .5.w))),
                                            child: MyText(
                                              '提取',
                                              color: k4A83FF(),
                                              size: 16.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
                      sliver: SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            // 点击事件，调用弹窗
                            showAgentAnnouncementDialog();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kWhite(),
                              borderRadius: 10.borderRadius,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h, horizontal: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText('代理操作规范公告！！！', size: 14.sp, color: k4()),
                                Icon(Icons.arrow_forward_ios,
                                    size: 14.w, color: kC()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      return SliverPadding(
                        padding:
                            EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w),
                        sliver: SliverList.builder(
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                width: 343.w,
                                height: 48.w,
                                padding: EdgeInsets.only(
                                    top: 8.w, left: 16.w, right: 16.w),
                                decoration: BoxDecoration(
                                    color: kWhite(),
                                    borderRadius:
                                        BorderRadius.vertical(top: 20.radius)),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  '提取记录',
                                  color: k3(),
                                  size: 15.sp,
                                ),
                              );
                            }
                            if (logic.rootDir.value.subs?.isNotEmpty != true) {
                              return Container(
                                width: 343.w,
                                height: 300.w,
                                decoration: BoxDecoration(
                                    color: kWhite(),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: 20.radius)),
                                alignment: Alignment.center,
                                child: const EmptyView(
                                  title: '没有找到提取记录~',
                                ),
                              );
                            }
                            if (index ==
                                (logic.rootDir.value.subs?.length ?? 0) + 1) {
                              return Container(
                                width: 343.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                    color: kWhite(),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: 20.radius)),
                              );
                            }
                            var item = logic.rootDir.value.subs![index - 1];
                            return InkWell(
                              onTap: () {
                                if (item.isDir == 1) {
                                  push(MyRouter.fileListNormal,
                                      args: FileNormalSearchEntity(item,
                                          searchMap: {'sort': 'desc'}));
                                } else {
                                  tabParentLogic.getDiskDetail(item);
                                }
                              },
                              child: Container(
                                height: 60.w,
                                padding: EdgeInsets.only(left: 16.w),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    // Image.asset(item.fileType?.fileTypeIcon ?? '', width: 32.w, height: 32.w,),
                                    (item.fileType != 1 &&
                                                item.fileType != 2) ||
                                            item.thumb == null ||
                                            item.thumb == ''
                                        ? Image.asset(
                                            item.fileType?.fileTypeIcon ?? '',
                                            width: 32.w,
                                            height: 32.w)
                                        : ClipRRect(
                                            borderRadius: 3.borderRadius,
                                            child: CachedNetworkImage(
                                              imageUrl: item.thumb ?? '',
                                              width: 32.w,
                                              height: 32.w,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Image.asset(R.assetsIcDefault,
                                                      width: 32.w,
                                                      height: 32.w,
                                                      fit: BoxFit.cover),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(R.assetsIcDefault,
                                                      width: 32.w,
                                                      height: 32.w,
                                                      fit: BoxFit.cover),
                                            )),
                                    spaceW(16),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            item.title ?? '',
                                            color: k3(),
                                            size: 13.sp,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          spaceH(5),
                                          // MyText(item.createtime ?? '', color: k9(), size: 10.sp,)
                                          Row(
                                            children: [
                                              MyText(
                                                item.createtime ?? '',
                                                color: k9(),
                                                size: 10.sp,
                                              ),
                                              spaceW(8),
                                              item.isDir == 0
                                                  ? MyText(
                                                      item.size ?? '',
                                                      color: k9(),
                                                      size: 10.sp,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount:
                              (logic.rootDir.value.subs ?? []).length + 2,
                        ),
                      );
                    })
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  addPopView() {
    return CustomPopupMenu(
        arrowColor: kWhite(),
        controller: logic.popC,
        verticalMargin: -15.w,
        menuBuilder: () {
          return Container(
            decoration:
                BoxDecoration(color: kWhite(), borderRadius: 10.borderRadius),
            width: 118.w,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    logic.popC.hideMenu();
                    logic.addOptions[index].action?.call();
                  },
                  child: Container(
                    height: 48.w,
                    color: kWhite(),
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Image.asset(
                          logic.addOptions[index].icon!,
                          width: 18.w,
                          height: 18.w,
                        ),
                        spaceW(10),
                        MyText(
                          logic.addOptions[index].title!,
                          color: k3(),
                          size: 14.sp,
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 42.w),
                  child: Divider(
                    color: hexColor('e5e5e5'),
                    height: 0.5.w,
                  ),
                );
              },
              itemCount: logic.addOptions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(
                  parent: ClampingScrollPhysics()),
              padding: EdgeInsets.zero,
            ),
          );
        },
        pressType: PressType.singleClick,
        child: Container(
          width: 56.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          child: Image.asset(
            R.assetsHomeNavAdd,
            width: 24.w,
            height: 24.w,
          ),
        ));
  }

  @override
  TabCommandLogic get initController => TabCommandLogic();

  @override
  bool get wantKeepAlive => true;
}
