import 'package:desk_cloud/content/io/io_parent_part.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

class TabIoPart extends StatefulWidget {
  const TabIoPart({super.key});

  @override
  State<TabIoPart> createState() => _TabIoPartState();
}

class _TabIoPartState extends BaseXState<TabIoLogic, TabIoPart>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: kF8(),
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: MyText(
            '传输',
            color: k3(),
            size: 18.sp,
          ),
        ),
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
      body: Column(
        children: [
          Container(
            width: 342.w,
            height: 42.w,
            margin: EdgeInsets.only(left: 17.5.w, right: 17.5.w),
            decoration:
                BoxDecoration(color: k3(0.04), borderRadius: 12.borderRadius),
            padding: EdgeInsets.all(4.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(() {
                  return Align(
                    alignment: Alignment(logic.offset.value - 1, 0),
                    child: Container(
                      width: 108.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                          color: kWhite(), borderRadius: 8.borderRadius),
                    ),
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          logic.pageC.animateToPage(0,
                              duration: 0.2.seconds, curve: Curves.ease);
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Obx(() {
                                return MyText(
                                  '下载',
                                  color: logic.currentIndex.value == 0
                                      ? k3()
                                      : k3(0.4),
                                  size: 13.sp,
                                );
                              }),
                            ),
                            Obx(() => logic.downloadingCount.value > 0
                                ? Positioned(
                                    top: 4.w,
                                    right: 8.w,
                                    child: Container(
                                      width: 6.w,
                                      height: 6.w,
                                      decoration: BoxDecoration(
                                          color: k4A83FF(),
                                          borderRadius: 3.borderRadius),
                                    ),
                                  )
                                : const SizedBox())
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          logic.pageC.animateToPage(1,
                              duration: 0.2.seconds, curve: Curves.ease);
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Obx(() {
                                return MyText(
                                  '上传',
                                  color: logic.currentIndex.value == 1
                                      ? k3()
                                      : k3(0.4),
                                  size: 13.sp,
                                );
                              }),
                            ),
                            Obx(() => logic.uploadingCount.value > 0
                                ? Positioned(
                                    top: 4.w,
                                    right: 8.w,
                                    child: Container(
                                      width: 6.w,
                                      height: 6.w,
                                      decoration: BoxDecoration(
                                          color: k4A83FF(),
                                          borderRadius: 3.borderRadius),
                                    ),
                                  )
                                : const SizedBox())
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          logic.pageC.animateToPage(2,
                              duration: 0.2.seconds, curve: Curves.ease);
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Obx(() {
                                return MyText(
                                  '解压',
                                  color: logic.currentIndex.value == 2
                                      ? k3()
                                      : k3(0.4),
                                  size: 13.sp,
                                );
                              }),
                            ),
                            Obx(() => logic.unzipingCount.value > 0
                                ? Positioned(
                                    top: 4.w,
                                    right: 8.w,
                                    child: Container(
                                      width: 6.w,
                                      height: 6.w,
                                      decoration: BoxDecoration(
                                          color: k4A83FF(),
                                          borderRadius: 3.borderRadius),
                                    ),
                                  )
                                : const SizedBox())
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          spaceH(12),
          Expanded(
            child: PageView(
              controller: logic.pageC,
              children: const [
                IoParentPart(0),
                IoParentPart(1),
                IoParentPart(2)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  TabIoLogic get initController => TabIoLogic();

  @override
  bool get wantKeepAlive => true;
}
