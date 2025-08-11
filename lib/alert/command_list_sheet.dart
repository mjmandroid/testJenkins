import 'dart:convert';

import 'package:desk_cloud/alert/command_target_sheet.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_command_logic.dart';
import 'package:desk_cloud/entity/disk_dir_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:flutter/material.dart';

/// 提取
Future<dynamic> showCommandListSheet() {
  return showModalBottomSheet(
      context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return const _CommandListView();
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}

class _CommandListView extends StatefulWidget {
  const _CommandListView();

  @override
  State<_CommandListView> createState() => _CommandListViewState();
}

class _CommandListViewState
    extends BaseXState<_CommandListLogic, _CommandListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h - 60.w,
      decoration: BoxDecoration(
          color: kWhite(), borderRadius: BorderRadius.vertical(top: 20.radius)),
      padding: EdgeInsets.only(
          left: 16.w, right: 16.w, bottom: 16.w + safeAreaBottom, top: 16.w),
      child: Column(
        children: [
          SizedBox(
            width: 343.w,
            height: 28.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(() {
                  return MyText(
                    '已选择${logic.currentDir.value?.subs?.where((element) => element.selected == true).length ?? 0}项',
                    size: 15.sp,
                    color: k3(),
                  );
                }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () {
                        pop(context: context);
                      },
                      child: Image.asset(
                        R.assetsDialogClose,
                        width: 28.w,
                        height: 28.w,
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyButton(
                    width: 52.w,
                    height: 28.w,
                    onTap: () {
                      logic.selectedAll();
                    },
                    decoration: BoxDecoration(color: kWhite()),
                    child: Obx(() {
                      // final totalSelected = logic.currentDir.value?.subs?.isNotEmpty == true && logic.currentDir.value?.subs
                      //     ?.where((element) => element.selected != true)
                      //     .isEmpty == true;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            '全选',
                            color:
                                !logic.totalSelected.value ? k3() : k4A83FF(),
                            size: 14.w,
                          ),
                          CheckView(
                            size: 14.w,
                            selected: logic.totalSelected.value,
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                child: InkWell(
                  onTap: () {
                    if (logic.gradeList.length > 1) {
                      //返回上一级，则清除当前层级的所有选中状态
                      logic.currentDir.value?.subs?.forEach((element) {
                        element.selected = null;
                      });
                      logic.gradeList.removeLast();
                      logic.currentDir.value = logic.gradeList.lastOrNull;
                      logic.totalSelected.value = false;
                    }
                  },
                  child: Obx(() {
                    return Container(
                      height: 24.w,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (logic.currentDir.value?.id != null)
                            Image.asset(
                              R.assetsNavBack,
                              width: 24.w,
                              height: 24.w,
                            ),
                          MyText(
                            logic.currentDir.value?.title ?? '',
                            color: k3(),
                            size: 14.w,
                          )
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemBuilder: (context, index) {
                  var item = logic.currentDir.value?.subs?[index];
                  return GestureDetector(
                    onTap: () {
                      //如果这个层级有选中的，这无法进入下一级查看
                      if (logic.currentDir.value?.subs
                              ?.where((element) => element.selected == true)
                              .isNotEmpty ==
                          true) {
                        item?.selected = !(item.selected ?? false);
                        logic.currentDir.refresh();
                        logic.clickItemCheckSelectedAll();
                      } else {
                        //没有选中，如果选择文件夹，这进入下一级查看
                        if (item?.isDir == 1) {
                          logic.currentDir.value = item;
                          logic.gradeList.add(item!);
                          if (logic.currentDir.value?.subs?.isNotEmpty !=
                              true) {
                            find<TabCommandLogic>()
                                ?.getCommandFiles(file: logic.currentDir.value)
                                .then((value) => logic.currentDir.refresh());
                          }
                        } else {
                          //如果不是文件夹，则开始执行选中逻辑
                          item?.selected = !(item.selected ?? false);
                          logic.currentDir.refresh();
                          logic.clickItemCheckSelectedAll();
                        }
                      }
                    },
                    child: Container(
                      height: 60.w,
                      color: Colors.white,
                      child: Row(
                        children: [
                          // Image.asset(item?.fileType?.fileTypeIcon ?? '', width: 32.w, height: 32.w,),
                          (item?.fileType != 1 && item?.fileType != 2) ||
                                  item?.thumb == null ||
                                  item?.thumb == ''
                              ? Image.asset(item?.fileType?.fileTypeIcon ?? '',
                                  width: 32.w, height: 32.w)
                              : ClipRRect(
                                  borderRadius: 3.borderRadius,
                                  child: CachedNetworkImage(
                                    imageUrl: item?.thumb ?? '',
                                    width: 32.w,
                                    height: 32.w,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      R.assetsIcDefault,
                                      width: 32.w,
                                      height: 32.w,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
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
                                MyText(
                                  item?.title ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  color: k3(),
                                  size: 13.sp,
                                ),
                                spaceH(5),
                                // MyText(item?.createtime ?? '', color: k9(), size: 10.sp,)
                                Row(
                                  children: [
                                    MyText(
                                      item?.createtime ?? '',
                                      color: k9(),
                                      size: 10.sp,
                                    ),
                                    spaceW(8),
                                    item?.isDir == 0
                                        ? MyText(
                                            item?.size ?? '',
                                            color: k9(),
                                            size: 10.sp,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          MyGestureDetector(
                              onTap: () {
                                item?.selected = !(item.selected ?? false);
                                logic.currentDir.refresh();
                                logic.clickItemCheckSelectedAll();
                              },
                              child: Container(
                                width: 32.w,
                                height: 32.w,
                                color: Colors.transparent,
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 24.w,
                                  height: 24.w,
                                  alignment: Alignment.centerRight,
                                  child: CheckView(
                                    size: 14.w,
                                    selected: item?.selected ?? false,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
                itemCount: logic.currentDir.value?.subs?.length ?? 0,
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
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      var r = await showCommandTargetSheet();
                      if (r != null) {
                        logic.targetDir.value = r;
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyText(
                          '提取到：',
                          color: k3(),
                          size: 12.sp,
                        ),
                        Image.asset(
                          R.assetsTypeDir,
                          width: 20.w,
                          height: 20.w,
                        ),
                        spaceW(5),
                        Flexible(
                          child: Obx(() {
                            return MyText(
                              logic.targetDir.value?.title ?? '',
                              color: k6(),
                              size: 12.sp,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                        ),
                        spaceW(5)
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  return MyButton(
                    width: 95.w,
                    height: 36.w,
                    child: MyText(
                      '提取 (${logic.currentDir.value?.subs?.where((element) => element.selected == true).length ?? 0})',
                      color: kWhite(),
                      size: 12.sp,
                    ),
                    onTap: () {
                      logic.submit();
                    },
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  _CommandListLogic get initController => _CommandListLogic();
}

class _CommandListLogic extends BaseLogic {
  final currentDir = Rxn<DiskFileEntity>();
  final gradeList = <DiskFileEntity>[];
  final targetDir = Rxn<DiskDirEntity>();
  var totalSelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentDir.value = DiskFileEntity()
      ..title = '口令'
      ..subs = find<TabCommandLogic>()
          ?.codeDiskFileList
          .map((e) => DiskFileEntity.fromJson(e.toJson()))
          .toList();
    gradeList.add(currentDir.value!);
    targetDir.value = DiskDirEntity()
      ..title = '根目录'
      ..id = 0;
  }

  submit() async {
    if (targetDir.value == null) {
      showShortToast('请选择文件夹');
      return;
    }
    var list =
        currentDir.value?.subs?.where((element) => element.selected == true) ??
            [];
    if (list.isEmpty) {
      showShortToast('请选择提取的文件');
      return;
    }
    showLoading();
    try {
      await ApiNet.request(Api.diskCodeSave, data: {
        'ids': jsonEncode(list
            .map((e) => {'id': e.id, 'is_dir': e.isDir, 'name': e.title})
            .toList()),
        'dir_id': targetDir.value?.id ?? 0,
        'code': find<TabCommandLogic>()?.currentCode.value,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
      dismissLoading();
      showShortToast('正在保存中...');
      find<TabCommandLogic>()?.onRefresh();
      await user.getUserVip();
      tabParentLogic.refreshFileHome();
      pop(args: true);
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }

  selectedAll() {
    if ((currentDir.value?.subs?.length ?? 0) == 0) {
      showShortToast('暂无文件~');
      return;
    }
    if (totalSelected.value) {
      currentDir.value?.subs?.forEach((element) {
        element.selected = false;
      });
      totalSelected.value = false;
    } else {
      currentDir.value?.subs?.forEach((element) {
        element.selected = true;
      });
      totalSelected.value = true;
    }
    currentDir.refresh();
  }

  clickItemCheckSelectedAll() {
    totalSelected.value = currentDir.value?.subs?.isNotEmpty == true &&
        currentDir.value?.subs
                ?.where((element) => element.selected != true)
                .isEmpty ==
            true;
  }
}
