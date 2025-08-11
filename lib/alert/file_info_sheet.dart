import 'dart:io';

import 'package:desk_cloud/entity/disk_file_detail_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/io_option/io_option_container.dart';
import 'package:flutter/material.dart';

Future<dynamic> showFileInfoSheet(dynamic id, {List<IoDataResoult>? dataList}) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _FileInfoView(id, dataList: dataList);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}


class _FileInfoView extends StatefulWidget {
  final dynamic id;
  final List<IoDataResoult>? dataList;

  const _FileInfoView(this.id, {this.dataList});

  @override
  State<_FileInfoView> createState() => _FileInfoViewState();
}

class _FileInfoViewState extends BaseXState<_FileInfoLogic, _FileInfoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 254.w + safeAreaBottom,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: 20.radius),
          color: kWhite()
      ),
      padding: EdgeInsets.only(top: 16.w, left: 16.w, right: 16.w),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                pop(context: context);
              },
              child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
            ),
          ),
          widget.dataList != null ? Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText('文件详情', color: k3(), size: 18.sp,)
                  ],
                ),
                spaceH(20),
                Row(
                  children: [
                    MyText('文件名：', color: k3(), size: 13.sp,),
                    Expanded(child: MyText(
                      widget.dataList?.firstOrNull?.item.fileName ?? '',
                      color: k3(), 
                      size: 13.sp, 
                      weight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
                  ],
                ),
                /// 如果当前是IOS的情况，就不显示
                if (!Platform.isIOS)
                  Column(
                    children: [
                      spaceH(10),
                      Row(
                        children: [
                          MyText('位置：', color: k3(), size: 13.sp,),
                          Expanded(child: MyText(
                            (widget.dataList?.firstOrNull?.item.localPath ?? '')
                                .replaceAll('/storage/emulated/0', '本地'),
                            color: k3(), 
                            size: 13.sp, 
                            weight: FontWeight.normal,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ))
                        ],
                      )
                    ],
                  ),
                spaceH(10),
                Row(
                  children: [
                    MyText('数量：', color: k3(), size: 13.sp,),
                    Expanded(
                      child: MyText(
                        widget.dataList?.length.toString() ?? '' ,
                        color: k3(), 
                        size: 13.sp, 
                        weight: FontWeight.normal,
                      )
                    )
                  ],
                ),
                spaceH(10),
                Row(
                  children: [
                    MyText('大小：', color: k3(), size: 13.sp,),
                    Expanded(
                      child: MyText(
                        widget.dataList?.firstOrNull?.item.total?.fileSize ?? '',
                        color: k3(), 
                        size: 13.sp, 
                        weight: FontWeight.normal
                      )
                    )
                  ],
                ),
                spaceH(10),
                Row(
                  children: [
                    MyText('创建时间：', color: k3(), size: 13.sp,),
                    Expanded(
                      child: MyText(
                        DateUtil.formatDateMs(widget.dataList?.firstOrNull?.item.startTime ?? 0), 
                        color: k3(), 
                        size: 13.sp, 
                        weight: FontWeight.normal,
                      )
                    )
                  ],
                ),
                spaceH(10),
                Row(
                  children: [
                    MyText('最后修改时间：', color: k3(), size: 13.sp,),
                    Expanded(
                      child: MyText(
                        DateUtil.formatDateMs(widget.dataList?.firstOrNull?.item.endTime ?? 0),
                        color: k3(), 
                        size: 13.sp, 
                        weight: FontWeight.normal,
                      )
                    )
                  ],
                )
              ],
            ),
          ) : Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText('文件详情', color: k3(), size: 18.sp,)
                  ],
                ),
                spaceH(20),
                Obx(() {
                  return Row(
                    children: [
                      MyText('文件名：', color: k3(), size: 13.sp,),
                      Expanded(child: MyText(
                        logic.info.value?.title ?? '', 
                        color: k3(), 
                        size: 13.sp, 
                        weight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ))
                    ],
                  );
                }),
                spaceH(10),
                Obx(() {
                  return Row(
                    children: [
                      MyText('位置：', color: k3(), size: 13.sp,),
                      Expanded(child: MyText(
                        logic.info.value?.filePath ?? '', 
                        color: k3(), 
                        size: 13.sp, 
                        weight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ))
                    ],
                  );
                }),
                spaceH(10),
                Obx(() {
                  return Row(
                    children: [
                      MyText('数量：', color: k3(), size: 13.sp,),
                      Expanded(child: MyText(logic.info.value?.fileCount?.toString() ?? '', color: k3(), size: 13.sp, weight: FontWeight.normal,))
                    ],
                  );
                }),
                spaceH(10),
                Obx(() {
                  return Row(
                    children: [
                      MyText('大小：', color: k3(), size: 13.sp,),
                      Expanded(child: MyText(logic.info.value?.size ?? '', color: k3(), size: 13.sp, weight: FontWeight.normal,))
                    ],
                  );
                }),
                spaceH(10),
                Obx(() {
                  return Row(
                    children: [
                      MyText('云端创建时间：', color: k3(), size: 13.sp,),
                      Expanded(child: MyText(logic.info.value?.createtime ?? '', color: k3(), size: 13.sp, weight: FontWeight.normal,))
                    ],
                  );
                }),
                spaceH(10),
                Obx(() {
                  return Row(
                    children: [
                      MyText('最后修改时间：', color: k3(), size: 13.sp,),
                      Expanded(child: MyText(logic.info.value?.updatetime ?? '', color: k3(), size: 13.sp, weight: FontWeight.normal,))
                    ],
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  _FileInfoLogic get initController => _FileInfoLogic(widget.id);
}

class _FileInfoLogic extends BaseLogic {
  final dynamic id;

  _FileInfoLogic(this.id);

  final info = Rxn<DiskFileDetailEntity>();

  @override
  void onInit() {
    super.onInit();
    requestForInfo();
  }

  requestForInfo() async {
    try {
      var base = await ApiNet.request<DiskFileDetailEntity>(Api.diskDetail, data: {'file_id': id});
      info.value = base.data;
    } catch (e) {
      showShortToast(e.toString());
    }
  }
}
