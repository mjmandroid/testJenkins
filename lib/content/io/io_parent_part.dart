import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/io/download_sub_part.dart';
import 'package:desk_cloud/content/io/io_parent_logic.dart';
import 'package:desk_cloud/content/io/uncompress_sub_part.dart';
import 'package:desk_cloud/content/io/upload_sub_part.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class IoParentPart extends StatefulWidget {
  final int type;

  const IoParentPart(this.type, {super.key});

  @override
  State<IoParentPart> createState() => _IoParentPartState();
}

// class _IoParentPartState extends BaseXState<IoParentLogic, IoParentPart> with AutomaticKeepAliveClientMixin {
class _IoParentPartState extends BaseXState<IoParentLogic, IoParentPart> {
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: 20.radius),
      child: Container(
        color: kWhite(),
        child: Column(
          children: [            
            Obx(() => Container(
              width: 375.w,
              height: 36.w,
              decoration: BoxDecoration(
                  gradient: user.memberEquity.value != null && user.memberEquity.value!.vipStatus == 1 ? LinearGradient(colors: [hexColor('#FFCEA0', .2), hexColor('#FFFFFF', 0)]) : null,
                  borderRadius: BorderRadius.vertical(top: 20.radius)
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                      child: 
                        widget.type == 0 ?
                          Obx(() => Text.rich(
                            TextSpan(
                              children: [
                                ioLogic.downloadingCount.value > 0 ? TextSpan(
                                  text: '${oss.downloadSpeed.value.fileSize}/s',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kB66518()
                                  )
                                ) : TextSpan(
                                  text: '暂无任务',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  )
                                ),
                                TextSpan(
                                  text: user.memberEquity.value!.vipStatus == 1 ? '' : '，',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  ),
                                  children: [
                                    TextSpan(
                                      text: user.memberEquity.value!.vipStatus == 1 ? '' : '开通会员享极速下载',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: hexColor('#B66518')
                                      ),
                                    )
                                  ],
                                )
                              ]
                            )
                          )) :
                        widget.type == 1 ?
                          // Obx(() => MyText('${oss.uploadSpeed.value.fileSize}/s', size: 14.sp,)) :
                          Obx(() => Text.rich(
                            TextSpan(
                              children: [
                                ioLogic.uploadingCount.value > 0 ? TextSpan(
                                  text: '${oss.uploadSpeed.value.fileSize}/s',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kB66518()
                                  )
                                ) : TextSpan(
                                  text: '暂无任务',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  )
                                ),
                                TextSpan(
                                  text: user.memberEquity.value!.vipStatus == 1 ? '' : '，',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  ),
                                  children: [
                                    TextSpan(
                                      text: user.memberEquity.value!.vipStatus == 1 ? '' : '开通会员享大文件上传',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: hexColor('#B66518')
                                      ),
                                    )
                                  ],
                                )
                              ]
                            )
                          )) : 
                        // Obx(() => MyText(ioLogic.unzipingCount.value > 0 ? '' : '已全部在线解压', size: 14.sp,))
                        Obx(() => Text.rich(
                            TextSpan(
                              children: [
                                ioLogic.unzipingCount.value > 0 ? TextSpan(
                                  text: '已全部在线解压',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  )
                                ) : TextSpan(
                                  text: '暂无任务',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  )
                                ),
                                TextSpan(
                                  text: user.memberEquity.value!.vipStatus == 1 ? '' : '，',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack()
                                  ),
                                  children: [
                                    TextSpan(
                                      text: user.memberEquity.value!.vipStatus == 1 ? '' : '开通会员享无限次在线解压',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: hexColor('#B66518')
                                      ),
                                    )
                                  ],
                                )
                              ]
                            )
                          ))
                  ),
                  user.memberEquity.value!.vipStatus == 1 ? Row(
                    children: [
                      Image.asset(R.assetsIoVip, width: 18.w, height: 10.w,),
                      spaceW(6),
                      MyText(widget.type == 0 ? '尊享极速下载生效中' : widget.type == 1 ? '尊享大文件上传生效中' : '无限次解压生效中', color: hexColor('#E77700'), size: 9.sp,)
                    ],
                  ) : MyButton(
                    title: widget.type == 0 ? '开通会员加速' : widget.type == 1 ? '升级大文件上传' : '开通会员',
                    height: 20.w,
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    style: TextStyle(
                      color: k713801(),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold
                    ),
                    decoration: BoxDecoration(
                      borderRadius: 6.borderRadius,
                      color: kFFECDA()
                    ),
                    onTap: () async {
                      await showOpenMemberSheet(openMemberType: widget.type == 0 ? OpenMemberType.download : widget.type == 1 ? OpenMemberType.largeFileUpload : OpenMemberType.extractZip);
                    },
                  )
                ],
              ),
            )),
            Obx(() => () {
              if (oss.downloadTaskList.value.isEmpty && widget.type == 0) {
                return const Expanded(child: Center(child: EmptyView(title: '没有找到下载记录~')));
              } else if (oss.uploadTaskList.value.isEmpty && widget.type == 1) {
                return const Expanded(child: Center(child: EmptyView(title: '没有找到上传记录~')));
              } else if ((widget.type == 2 && logic.uncompressIsEmpty.value) || (ioLogic.unzipAllCount.value == 0 && widget.type == 2)) {
                return const Expanded(child: Center(child: EmptyView(title: '没有找到解压记录~')));
              } else {
                return Expanded(child: Column(children: [
                  Container(
                    width: 375.w,
                    height: 55.w,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w, bottom: 15.w),
                    child: Obx(() {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var item = logic.options[index];
                          return Obx(() {
                            var selected = logic.currentIndex.value == index;
                            var count = 0;
                            if (widget.type != 2) {
                              if (index == 0) {
                                count = widget.type == 0 ? oss.downloadTaskCount.value : oss.uploadTaskCount.value;
                              }else if (index == 1){
                                count = widget.type == 0 ? oss.downloadSuccessCount.value : oss.uploadSuccessCount.value;
                              }else if (index == 2){
                                count = widget.type == 0 ? oss.downloadPlayingCount.value : oss.uploadPlayingCount.value;
                              }else{
                                count = widget.type == 0 ? oss.downloadFailCount.value : oss.uploadFailCount.value;
                              }
                            } else {
                              count = item.count ?? 0;
                            }
                            return GestureDetector(
                              onTap: () {
                                logic.currentIndex.value = index;
                                logic.pageC.jumpToPage(index);
                                ioLogic.hiddenCallback();
                                tabParentLogic.ioOption?.hidden();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: selected ? hexColor('#EDF3FF') : kBlack(0.03),
                                        borderRadius: 8.borderRadius
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: MyText('${item.title ?? ''}${index != 0 ? count : ''}', color: selected ? k4A83FF() : kB3(), size: 11.sp,),
                                  ),
                                  if (index == 2 && count > 0)
                                    Positioned(
                                      top: 2.5.w,
                                      right: 2.5.w,
                                      child: Container(
                                        width: 4.w,
                                        height: 4.w,
                                        decoration: BoxDecoration(
                                          color: k4A83FF(),
                                          borderRadius: 4.borderRadius
                                        ),
                                      )
                                    )
                                ],
                              ),
                            );
                          });
                        },
                        separatorBuilder: (context, index) {
                          return spaceW(9);
                        },
                        itemCount: logic.options.length,
                        physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        shrinkWrap: true,
                      );
                    }),
                  ),
                  Expanded(
                    child: PageView(
                      controller: logic.pageC,
                      physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                      children: [
                        if (widget.type == 0)
                          ...[
                            const DownloadSubPart(0),
                            const DownloadSubPart(1),
                            const DownloadSubPart(2),
                            const DownloadSubPart(3)
                          ],
                        if (widget.type == 1)
                          ...[
                            const UploadSubPart(0),
                            const UploadSubPart(1),
                            const UploadSubPart(2),
                            const UploadSubPart(3)
                          ],
                        if (widget.type == 2)
                          ...[
                            const UncompressSubPart(0),
                            const UncompressSubPart(1),
                            const UncompressSubPart(2),
                            const UncompressSubPart(3)
                          ]
                      ],
                    ),
                  ),
                  SizedBox(height: tabParentLogic.ioOption?.showing.value ?? false ? 40.w : 0)
                ],));
              }
            }(),)
          ],
        ),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  IoParentLogic get initController => IoParentLogic(widget.type);

  @override
  String? get tag => 'IoParentLogic_${widget.type}';
}
