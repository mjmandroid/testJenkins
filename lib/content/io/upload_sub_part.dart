import 'package:desk_cloud/content/io/upload_sub_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:realm/realm.dart';

class UploadSubPart extends StatefulWidget {
  final int type;

  const UploadSubPart(this.type, {super.key});

  @override
  State<UploadSubPart> createState() => _UploadSubPartState();
}

class _UploadSubPartState extends BaseXState<UploadSubLogic, UploadSubPart> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      var results = oss.uploadTaskList.value;
      if (widget.type == 1) {
        results = oss.uploadTaskList.value.query(r'status == 3 SORT(startTime desc)');
      } else if (widget.type == 2) {
        results = oss.uploadTaskList.value.query(r'status == 0 || status == 1 || status == 2 || status == 5 SORT(startTime desc)');
      } else if (widget.type == 3) {
        results = oss.uploadTaskList.value.query(r'status == 4 SORT(startTime desc)');
      }
      return results.isEmpty ? const Center(child: EmptyView(title: '没有找到上传记录~')) : CustomScrollView(
        slivers: [
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 3.w),
          //   sliver: SliverToBoxAdapter(
          //     child: MyText(
          //       '今天',
          //       color: k3(),
          //       size: 14.sp,
          //     ),
          //   ),
          // ),
          SliverPadding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.w),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                var item = results[index];
                return MyInkWell(
                  onTap: () async {
                    if (item.status != 3) return;        
                    logic.clickFile(item);
                    // if (ioLogic.images.contains(item.fileName?.split('.').lastOrNull?.toLowerCase())) {
                    //   push(MyRouter.imagePreview, args: item.localPath);
                    // } else if (ioLogic.videos.contains(item.fileName?.split('.').lastOrNull?.toLowerCase())) {
                    //   // push(MyRouter.videoPreview, args: item.item.localPath);
                    //   // push(MyRouter.videoView, args: item.item.localPath);
                    //   showVideoPage(pathUrl: item.localPath ?? '');
                    // } else if (ioLogic.zips.contains(item.fileName?.split('.').lastOrNull?.toLowerCase())) {
                    //   if (user.memberEquity.value?.vipStatus == 0) {
                    //     await showOpenMemberSheet(openMemberType: OpenMemberType.extractZip);
                    //   } else {
                    //     showShortToast('该文件类型不支持在线预览,请下载后再查看');
                    //   }
                    // } else {
                    //   showShortToast('该文件类型不支持在线预览,请下载后再查看');
                    // }
                  },
                  child: Container(
                    width: 343.w,
                    height: 60.w,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        item.thumb?.isEmpty ?? true ? Image.asset(
                          item.fileName?.split('.').lastOrNull?.fileIcon ?? '',
                          width: 32.w,
                          height: 32.w,
                        ) : item.thumb == '0' ? Image.asset(
                          item.fileName?.split('.').lastOrNull?.fileIcon ?? '',
                          width: 32.w,
                          height: 32.w,
                        ) : ClipRRect(
                          borderRadius: 3.borderRadius,
                          child: Image(
                            image: ThumbnailProvider(
                              mediumId: item.thumb??'', // 媒体的唯一 ID
                              highQuality: true, // 是否为高质量图片
                            ),
                            fit: BoxFit.cover, // 充满方式
                            width: 32.w,
                            height: 32.w,
                          )
                        ),
                        spaceW(16),
                        if (item.status == 3 || item.status == 4)
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  item.fileName ?? '', 
                                  color: k3(), 
                                  size: 13.sp,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                spaceH(5),
                                // MyText(
                                //   DateUtil.formatDateMs(item.endTime ?? 0, format: 'yyyy-MM-dd HH:mm:ss'),
                                //   color: k9(),
                                //   size: 10.sp,
                                // ),
                                Row(
                                  children: [
                                    MyText(DateUtil.formatDateMs(item.endTime ?? 0,format: 'yyyy-MM-dd HH:mm:ss'), color: k9(), size: 10.sp,),
                                    spaceW(8),
                                    // MyText(item.total?.fileSize ?? '', color: k9(), size: 10.sp,)
                                    // spaceW(8),
                                    item.status == 4 ? 
                                      MyText('上传失败', color: k9(), size: 10.sp,) :
                                      MyText(item.total?.fileSize ?? '', color: k9(), size: 10.sp,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        if (item.status != 3 && item.status != 4) ...[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  item.fileName ?? '', 
                                  color: k3(), 
                                  size: 13.sp,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                spaceH(5),
                                Row(
                                  children: [
                                    if (item.status == 1 && item.speed != 0)
                                      MyText(
                                        // '${item.total?.fileSize}/约08分',
                                        // '${item.total?.fileSize}/约08分',
                                        '${item.current?.fileSize ?? 0}/${item.total?.fileSize ?? 100}',
                                        color: k9(),
                                        size: 9.sp,
                                      ),
                                    if (item.status == 1 && item.speed == 0)
                                      MyText(
                                        '${item.current?.fileSize ?? 0}/${item.total?.fileSize ?? 100}',
                                        color: k9(),
                                        size: 9.sp,
                                      ),
                                    if (item.status != 1)
                                      MyText(
                                        '${item.current?.fileSize ?? 0}/${item.total?.fileSize ?? 100}',
                                        color: k9(),
                                        size: 9.sp,
                                      ),
                                    const Spacer(),
                                    if (item.status == 1) ...[
                                      Image.asset(
                                        R.assetsIoFlash,
                                        width: 7.w,
                                        height: 10.w,
                                      ),
                                      spaceW(2),
                                      MyText(
                                        '${item.speed?.fileSize??0}/s',
                                        color: hexColor('#B66518'),
                                        size: 9.sp,
                                      )
                                    ],
                                    if (item.status != 1)
                                      MyText(
                                        '--',
                                        color: hexColor('#B66518'),
                                        size: 9.sp,
                                      )
                                  ],
                                ),
                                spaceH(4),
                                SizedBox(
                                  height: 1.5.w,
                                  child: LinearProgressIndicator(
                                    backgroundColor: kBlack(0.08),
                                    valueColor: AlwaysStoppedAnimation(kE77700()),
                                    value: (item.current ?? 0) / (item.total ?? 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                if (item.status == 1) {
                                  oss.cancelTask(item);
                                } else {
                                  oss.renewUpload(item);
                                }
                              },
                              child: Container(
                                  width: 38.w,
                                  height: 38.w,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    item.status == 1 ? R.assetsIoPause : R.assetsIoPlay,
                                    width: 18.w,
                                    height: 18.w,
                                  )))
                        ],
                        // spaceW(10),
                        // CheckView(
                        //   size: 14.w,
                        //   selected: false,
                        // )
                      ],
                    ),
                  ),
                );
              },
              itemCount: results.length,
            ),
          )
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  UploadSubLogic get initController => UploadSubLogic();
}
