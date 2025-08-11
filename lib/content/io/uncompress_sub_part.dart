import 'package:desk_cloud/content/io/io_parent_logic.dart';
import 'package:desk_cloud/content/io/uncompress_sub_logic.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/entity/transfer_record_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class UncompressSubPart extends StatefulWidget {
  final int type;
  const UncompressSubPart(this.type, {super.key});

  @override
  State<UncompressSubPart> createState() => _UncompressSubPartState();
}

// class _UncompressSubPartState extends BaseXState<UncompressSubPartLogic, UncompressSubPart> with AutomaticKeepAliveClientMixin{
class _UncompressSubPartState
    extends BaseXState<UncompressSubPartLogic, UncompressSubPart> {
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // return CustomScrollView(
    //   slivers: [
    //     SliverPadding(
    //       padding: EdgeInsets.only(left: 16.w,right: 16.w,bottom: 3.w),
    //       sliver: SliverToBoxAdapter(
    //         child: MyText('今天',color: k3(),size: 14.sp,),
    //       ),
    //     ),
    //     SliverPadding(
    //       padding: EdgeInsets.only(left: 16.w,right: 16.w,bottom: 12.w),
    //       sliver: SliverList.builder(
    //         itemBuilder: (context,index){
    //           return Container(
    //             width: 343.w,
    //             height: 60.w,
    //             alignment: Alignment.center,
    //             child: Row(
    //               children: [
    //                 Image.asset(R.assetsTypeDir,width: 32.w,height: 32.w,),
    //                 spaceW(16),
    //                 Expanded(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       MyText('快兔上传文件',color: k3(),size: 13.sp,),
    //                       spaceH(4),
    //                       Row(
    //                         children: [
    //                           MyText('3.6GB/约08分',color: k9(),size: 9.sp,),
    //                           const Spacer(),
    //                           Image.asset(R.assetsIoFlash,width: 7.w,height: 10.w,),
    //                           spaceW(2),
    //                           MyText('10MB/s',color: hexColor('#B66518'),size: 9.sp,)
    //                         ],
    //                       ),
    //                       spaceH(4),
    //                       SizedBox(
    //                         height: 1.5.w,
    //                         child: LinearProgressIndicator(
    //                           backgroundColor: kBlack(0.08),
    //                           valueColor: AlwaysStoppedAnimation(kE77700()),
    //                           value: 0.5,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 spaceW(10),
    //                 Image.asset(R.assetsIoPause,width: 18.w,height: 18.w,),
    //                 spaceW(20),
    //                 CheckView(size: 14.w,selected: false,)
    //               ],
    //             ),
    //           );
    //         },
    //         itemCount: 4,
    //       ),
    //     )
    //   ],
    // );
    return Obx(() {
      // if (logic.transferRecordEntity.value.list == null || logic.transferRecordEntity.value.list!.isEmpty) return const Center(child: EmptyView(title: '没有找到解压记录~'),);
      return SmartRefresher(
        controller: logic.controller,
        onRefresh: logic.onRefresh,
        onLoading: logic.onLoading,
        enablePullUp: true,
        child: logic.transferRecordEntity.value.list == null ||
                logic.transferRecordEntity.value.list!.isEmpty
            ? const Center(child: EmptyView(title: '没有找到解压记录~'))
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.w),
                    sliver: SliverList.builder(
                      itemBuilder: (context, index) {
                        TransferRecordList item =
                            logic.transferRecordEntity.value.list![index];
                        return MyInkWell(
                          onTap: () {
                            if (item.statusLocal != 2) return;
                            push(MyRouter.fileListNormal,
                                args: FileNormalSearchEntity(
                                    DiskFileEntity()
                                      ..id = item.id
                                      ..title = item.title,
                                    searchMap: {}));
                          },
                          child: Opacity(
                            opacity: item.statusLocal == 2 ? 1 : .5,
                            child: Container(
                              width: 343.w,
                              height: 60.w,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Image.asset(
                                    R.assetsTypeDir,
                                    width: 32.w,
                                    height: 32.w,
                                  ),
                                  spaceW(16),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          '${item.title}',
                                          color: k3(),
                                          size: 13.sp,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        spaceH(4),
                                        MyText(
                                          '${item.createtime}',
                                          size: 10.sp,
                                          weight: FontWeight.normal,
                                          color: k9(),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (item.statusLocal != 2)
                                    MyText(
                                      '${logic.statusList['${item.statusLocal}']}',
                                      size: 10.sp,
                                      weight: FontWeight.normal,
                                      color: k9(),
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: logic.transferRecordEntity.value.list!.length,
                    ),
                  )
                ],
              ),
      );
    });
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  UncompressSubPartLogic get initController =>
      UncompressSubPartLogic(type: widget.type);

  @override
  String? get tag => 'UncompressSubPartLogic_${widget.type}';
}
