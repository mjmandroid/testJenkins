import 'package:desk_cloud/alert/file_sort_type_sheet.dart';
import 'package:desk_cloud/alert/file_upload_sheet.dart';
import 'package:desk_cloud/content/file/file_home_sub_part.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_file_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TabFilePart extends StatefulWidget {
  const TabFilePart({super.key});

  @override
  State<TabFilePart> createState() => _TabFilePartState();
}

class _TabFilePartState extends BaseXState<TabFileLogic, TabFilePart>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        title: Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: MyText(
              '文件',
              color: k3(),
              size: 18.sp,
            )),
        actions: [   InkWell(
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
        ],
      ),
      backgroundColor: kF8(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              const FileSearchBar(),
              // GestureDetector(
              //   onTap: (){
              //     showFileSearch('');
              //   },
              //   child: Container(
              //     width: 343.w,
              //     height: 44.w,
              //     margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 3.w),
              //     decoration: BoxDecoration(
              //         color: kWhite(),
              //         borderRadius: 14.borderRadius
              //     ),
              //     padding: EdgeInsets.symmetric(horizontal: 10.w),
              //     child: Row(
              //       children: [
              //         Image.asset(R.assetsFileSearch, width: 24.w, height: 24.w,),
              //         spaceW(6),
              //         Expanded(
              //           child: MyTextField(
              //             hintText: '搜索网盘文件',
              //             hintStyle: TextStyle(fontSize: 13.sp, color: k9(), fontWeight: FontWeight.w600),
              //             style: TextStyle(fontSize: 13.sp, color: k3(), fontWeight: FontWeight.w600),
              //             enabled: false,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              spaceH(12),
              Expanded(
                child: Container(
                  width: 375.w,
                  decoration: BoxDecoration(
                      borderRadius: 20.borderRadius, color: kWhite()),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          var r = await showFileSortTypeSheet(
                              type: logic.sortType.value,
                              subType: logic.subSortType.value);
                          if (r == null) return;
                          logic.sortType.value = r[0];
                          logic.subSortType.value = r[1];
                          logic.refreshAllSubLogic();
                        },
                        child: Container(
                          height: 50.w,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Obx(() {
                                return MyText('按${logic.sortType.value.name}',
                                    color: k6(),
                                    size: 13.sp,
                                    weight: FontWeight.normal);
                              }),
                              spaceW(8),
                              Obx(() {
                                return Transform.rotate(
                                    angle: logic.subSortType.value ==
                                            FileSortSubType.desc
                                        ? math.pi
                                        : 0,
                                    child: Image.asset(
                                      R.assetsFileSort,
                                      width: 10.w,
                                      height: 16.w,
                                    ));
                              })
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 28.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 2.w),
                        width: 375.w,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Obx(() {
                              final selected =
                                  index == logic.currentIndex.value;
                              return MyButton(
                                height: 24.w,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                    color: selected
                                        ? hexColor('#EDF3FF')
                                        : kBlack(0.03),
                                    borderRadius: 8.borderRadius),
                                onTap: () {
                                  logic.pageC.animateToPage(index,
                                      duration: 0.12.seconds,
                                      curve: Curves.ease);
                                },
                                child: MyText(
                                  logic.tabs[index].title ?? '',
                                  color: selected ? k4A83FF() : kB3(),
                                  size: 11.sp,
                                ),
                              );
                            });
                          },
                          separatorBuilder: (context, index) {
                            return spaceW(10);
                          },
                          itemCount: logic.tabs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(
                              parent: ClampingScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      spaceH(10),
                      Expanded(
                        child: PageView(
                          controller: logic.pageC,
                          children: const [
                            FileHomeSubPart(''),
                            FileHomeSubPart(2),
                            FileHomeSubPart(1)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            right: 10.w,
            bottom: 9.w,
            child: GestureDetector(
              onTap: () async {
                var res = await showFileUploadSheet(dirId: 0);
                if (res == null || res == false) return;
                tabParentLogic.refreshFileHome();
              },
              child: Image.asset(
                R.assetsFileAdd,
                width: 61.w,
                height: 61.w,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  TabFileLogic get initController => TabFileLogic();

  @override
  bool get wantKeepAlive => true;
}
