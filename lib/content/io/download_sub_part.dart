import 'package:desk_cloud/content/io/download_sub_logic.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../../alert/price_dialog.dart';
import '../../utils/price_dialog_utils.dart';
import '../tabs/tab_member_logic.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DownloadSubPart extends StatefulWidget {
  final int type;

  const DownloadSubPart(this.type, {super.key});

  @override
  State<DownloadSubPart> createState() => _DownloadSubPartState();
}

// class _DownloadSubPartState extends State<DownloadSubPart> with AutomaticKeepAliveClientMixin {
class _DownloadSubPartState extends BaseXState<DownloadSubLogic, DownloadSubPart> {
  // 声明一个变量来存储 worker
  late Worker _worker;

  @override
  void initState() {
    super.initState();
    // 读取服务器到实际时间
    PopupManager().initialize();
    // 主动显示弹窗
    PopupManager().setNeedShowCallback((value) {
      _showPriceDialog(true);
    });
    _worker = ever(oss.downloadTaskList, (callback) {
      initDates();
    });
    initDates();
  }

  initDates() {
    var results = oss.downloadTaskList.value;
    if (widget.type == 1) {
      results = oss.downloadTaskList.value.query(r'status == 3 SORT(startTime desc)');
    } else if (widget.type == 2) {
      results = oss.downloadTaskList.value.query(r'status == 0 || status == 1 || status == 2 || status == 5 SORT(startTime desc)');
    } else if (widget.type == 3) {
      results = oss.downloadTaskList.value.query(r'status == 4 SORT(startTime desc)');
    }
    ioLogic.initIoDates(results);
  }

  // 显示价格弹窗
  Future<void> _showPriceDialog(bool ignoreDownloadSpeed) async {
    try {
      // var downloadingCount = oss.downloadTaskList.value.query(r'status == 0 || status == 1 || status == 2').length;
      if(!ignoreDownloadSpeed){
        var downloadingCount = oss.downloadSpeed.value;
        if (downloadingCount == 0) {
          return;
        }
      }
      // 获取价格数据
      await user.getUserVip();
      if (user.memberEquity.value!.vipStatus == 1) {
        return;
      }
      await memberLogic.getProducts();
      var data = memberLogic.memberProducts.value;
      if (data == null || data.length == 0) {
        return;
      }
      var showList = data.where((option) => option.isOpen == 1);
      if (showList == null || showList.length == 0) {
        return;
      }
      // 弹窗时间控制
      if (PopupManager().canShowPopup() == false) {
        return;
      }

      // 设置弹窗正在展示
      PopupManager().setPopupShowing(true);

      // 显示底部弹窗
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PriceDialog(
          title: showList.first.describeTitle ?? "",
          options: data,
          agreement: "  用户协议",
          disclaimer: "响应净网行动，严禁传播色情违法内容，否则封号",
        ),
      ).then((_) {
        // 弹窗关闭后，设置弹窗不在展示
        PopupManager().setPopupShowing(false);
      });

      // 显示弹窗后开始倒计时
      PopupManager().startCountdown(() {
        // 倒计时结束后的回调处理
        _showPriceDialog(false);
      });

    } catch (e) {
      if (!mounted) return;
      // 发生异常时，确保弹窗状态被重置
      PopupManager().setPopupShowing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return VisibilityDetector(
      key: Key('downLoad-page'),
      onVisibilityChanged: (visibilityInfo) {
        // 更新界面可见性状态
        PopupManager().setInterfaceVisibility(visibilityInfo.visibleFraction > 0);
        if (visibilityInfo.visibleFraction > 0) {
          // 页面可见，执行操作
          _showPriceDialog(false);
        }
      },
      child: Obx(() {
        return ioLogic.ioDates.isEmpty
            ? const Center(child: EmptyView(title: '没有找到下载记录~'))
            : Stack(
                children: [
                  Positioned.fill(
                      child: CustomScrollView(
                    slivers: [
                      // SliverPadding(
                      //   padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 3.w),
                      //   sliver: SliverToBoxAdapter(
                      //     child: MyText('今天', color: k3(), size: 14.sp,),
                      //   ),
                      // ),
                      SliverPadding(
                          padding: EdgeInsets.only(bottom: 12.w),
                          sliver: Obx(
                            () => SliverList.builder(
                              itemBuilder: (context, index) {
                                var item = ioLogic.ioDates[index];
                                if (!item.item.isValid) return const SizedBox();
                                return MyInkWell(
                                  onTap: () async {
                                    if (!tabParentLogic.ioOption!.allowSelected.value) {
                                      if (item.item.status != 3) return;
                                      logic.clickFile(item.item);
                                    } else {
                                      item.isSelected = !item.isSelected;
                                      ioLogic.selectedChange();
                                    }
                                  },
                                  onLongPress: () {
                                    if (!tabParentLogic.ioOption!.allowSelected.value) {
                                      tabParentLogic.ioOption?.allowSelected.value = true;
                                      item.isSelected = !item.isSelected;
                                      ioLogic.selectedChange();
                                    } else {
                                      tabParentLogic.ioOption?.allowSelected.value = true;
                                      tabParentLogic.ioOption?.hidden();
                                      ioLogic.hiddenCallback();
                                    }
                                  },
                                  child: Container(
                                    width: 343.w,
                                    height: 60.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: item.isSelected ? kEDF3FF() : Colors.transparent),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      children: [
                                        item.item.thumb == null || item.item.thumb == ''
                                            ? Image.asset(
                                                item.item.fileName?.split('.').lastOrNull?.fileIcon ?? '',
                                                width: 32.w,
                                                height: 32.w,
                                              )
                                            : ClipRRect(
                                                borderRadius: 3.borderRadius,
                                                child: CachedNetworkImage(
                                                  imageUrl: item.item.thumb ?? '',
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
                                        if (item.item.status == 3 || item.item.status == 4)
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  item.item.fileName ?? '',
                                                  color: k3(),
                                                  size: 13.sp,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                spaceH(5),
                                                Row(
                                                  children: [
                                                    MyText(
                                                      DateUtil.formatDateMs(item.item.endTime ?? 0, format: 'yyyy-MM-dd HH:mm:ss'),
                                                      color: k9(),
                                                      size: 10.sp,
                                                    ),
                                                    spaceW(8),
                                                    item.item.status == 4
                                                        ? MyText(
                                                            '下载失败',
                                                            color: k9(),
                                                            size: 10.sp,
                                                          )
                                                        : MyText(
                                                            item.item.total?.fileSize ?? '',
                                                            color: k9(),
                                                            size: 10.sp,
                                                          )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        if (item.item.status != 3 && item.item.status != 4) ...[
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  item.item.fileName ?? '',
                                                  color: k3(),
                                                  size: 13.sp,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                spaceH(5),
                                                Row(
                                                  children: [
                                                    if (item.item.status == 1 && item.item.speed != 0)
                                                      MyText(
                                                        // '${item.item.total?.fileSize}/约08分',
                                                        '${item.item.current?.fileSize ?? 0}/${item.item.total?.fileSize ?? 100}',
                                                        color: k9(),
                                                        size: 9.sp,
                                                      ),
                                                    if (item.item.status == 1 && item.item.speed == 0)
                                                      MyText(
                                                        '${item.item.current?.fileSize ?? 0}/${item.item.total?.fileSize ?? 100}',
                                                        color: k9(),
                                                        size: 9.sp,
                                                      ),
                                                    if (item.item.status != 1)
                                                      MyText('${item.item.current?.fileSize ?? 0}/${item.item.total?.fileSize ?? 100}',
                                                          color: k9(), size: 9.sp),
                                                    const Spacer(),
                                                    if (item.item.status == 1) ...[

                                                      Image.asset(
                                                        R.assetsIoFlash,
                                                        width: 7.w,
                                                        height: 10.w,
                                                      ),
                                                      spaceW(2),
                                                      MyText(
                                                        '${(item.item.speed ?? 0) < 0 ? '0KB' : item.item.speed?.fileSize ?? '0KB'}/s',
                                                        color: hexColor('#B66518'),
                                                        size: 9.sp,
                                                      )
                                                    ],
                                                    if (item.item.status != 1)
                                                      MyText(
                                                        switch (item.item.status) { 2 => '暂停中', 5 => '排队中', _ => '--' },
                                                        color: hexColor('#B66518'),
                                                        size: 9.sp,
                                                      ),
                                                  ],
                                                ),
                                                spaceH(4),
                                                SizedBox(
                                                  height: 1.5.w,
                                                  child: LinearProgressIndicator(
                                                    backgroundColor: kBlack(0.08),
                                                    valueColor: AlwaysStoppedAnimation(kE77700()),
                                                    // value: (item.item.current ?? 0)/(item.item.total ?? 1),
                                                    value: _calculateProgress(item.item.current, item.item.total),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                if (item.item.status == 1) {
                                                  oss.cancelTask(item.item);
                                                } else {
                                                  oss.renewDownload(item.item);
                                                }
                                              },
                                              child: Container(
                                                  width: 38.w,
                                                  height: 38.w,
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    item.item.status == 1
                                                        ? R.assetsIoPause
                                                        : item.item.status == 5
                                                            ? R.assetsIcWait
                                                            : R.assetsIoPlay,
                                                    width: 18.w,
                                                    height: 18.w,
                                                  )))
                                        ],
                                        Obx(() => tabParentLogic.ioOption?.allowSelected.value ?? false
                                            ? Row(
                                                children: [spaceW(20), CheckView(size: 14.w, selected: item.isSelected)],
                                              )
                                            : const SizedBox())
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: ioLogic.ioDates.length,
                            ),
                          ))
                    ],
                  )),
                ],
              );
      }),
    );
  }

  // 在类中添加这个辅助方法
  double _calculateProgress(num? current, num? total) {
    if (current == null || total == null || total <= 0) return 0.0;
    return (current / total).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }

  @override
  DownloadSubLogic get initController => DownloadSubLogic();

// @override
// bool get wantKeepAlive => true;
}
