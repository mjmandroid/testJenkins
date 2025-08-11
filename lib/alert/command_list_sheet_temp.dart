import 'package:desk_cloud/content/login/mobile_login_logic.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCommandListSheetTmep() {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return const _CommandListViewTemp();
      },
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true);
}

class _CommandListViewTemp extends StatefulWidget {
  const _CommandListViewTemp();

  @override
  State<_CommandListViewTemp> createState() => _CommandListViewTempState();
}

class _CommandListViewTempState extends BaseXState<_CommandListViewTempLogic, _CommandListViewTemp> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h - 60.w,
      decoration: BoxDecoration(
          color: kWhite(),
          borderRadius: BorderRadius.vertical(top: 20.radius)
      ),
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w + safeAreaBottom, top: 16.w),
      child: Column(
        children: [
          SizedBox(
            width: 343.w,
            height: 28.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MyText('已选择0项', size: 15.sp, color: k3()),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      pop(context: context);
                    },
                    child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,)
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyButton(
                    width: 52.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                        color: kWhite()
                    ),
                    onTap: () {
                      showShortToast('请先登录...');
                      pop(context: context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText('全选', color: k3(), size: 14.w,),
                        CheckView(size: 14.w, selected: false,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                child: MyText('口令', color: k3(), size: 14.w,),
              )
            ],
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemBuilder: (context, index) {
                  var item = logic.codeDiskFileList[index];
                  return GestureDetector(
                    onTap: () {
                      showShortToast('请先登录...');
                      pop(context: context);
                    },
                    child: Container(
                      height: 60.w,
                      color: Colors.white,
                      child: Row(
                        children: [
                          // Image.asset(item.fileType?.fileTypeIcon ?? '', width: 32.w, height: 32.w,),
                          (item.fileType != 1 && item.fileType != 2) || item.thumb == null || item.thumb == '' ? 
                            Image.asset(
                              item.fileType?.fileTypeIcon ?? '', 
                              width: 32.w, 
                              height: 32.w
                            ) : ClipRRect(
                                borderRadius: 3.borderRadius,
                                child: CachedNetworkImage(
                                  imageUrl: item.thumb??'',
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
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(item.title ?? '', color: k3(), size: 13.sp,),
                                spaceH(5),
                                MyText(item.createtime ?? '', color: k9(), size: 10.sp,)
                              ],
                            ),
                          ),
                          MyGestureDetector(
                            onTap: () {
                              showShortToast('请先登录...');
                              pop(context: context);
                            },
                            child: CheckView(size: 14.w, selected: item.selected ?? false)
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: logic.codeDiskFileList.length,
              );
            }),
          ),
          Container(
            width: 343.w,
            height: 40.w,
            color: kWhite(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showShortToast('请先登录...');
                    pop(context: context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText('提取到：', color: k3(), size: 12.sp,),
                      Image.asset(R.assetsTypeDir, width: 20.w, height: 20.w,),
                      spaceW(5),
                      MyText('根目录', color: k6(), size: 12.sp,)
                    ],
                  ),
                ),
                MyButton(
                  width: 95.w,
                  height: 36.w,
                  child: MyText('提取 (0)',color: kWhite(),size: 12.sp,),
                  onTap: () {
                    showShortToast('请先登录...');
                    pop(context: context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  _CommandListViewTempLogic get initController => _CommandListViewTempLogic();
}

class _CommandListViewTempLogic extends BaseLogic {
  final codeDiskFileList = <DiskFileEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    codeDiskFileList.value = find<MobileLoginLogic>()?.codeDiskFileList ?? [];
  }
}
