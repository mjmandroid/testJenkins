import 'dart:io';

import 'package:desk_cloud/alert/command_target_sheet.dart';
import 'package:desk_cloud/alert/mobile_file/mobile_sub_file_view.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/entity/disk_dir_entity.dart';
import 'package:desk_cloud/entity/mobile_file_entity.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/gradient_tab_indicator.dart';
import 'package:flutter/material.dart';

/// 文件
Future<dynamic> showMobileFileSheet() {
  return showModalBottomSheet(
      context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return const _MobileFileView();
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}

class _MobileFileView extends StatefulWidget {
  const _MobileFileView({super.key});

  @override
  State<_MobileFileView> createState() => _MobileFileViewState();
}

class _MobileFileViewState
    extends BaseXState<MobileFileLogic, _MobileFileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h - 60.w,
      decoration: BoxDecoration(
          color: kWhite(), borderRadius: BorderRadius.vertical(top: 20.radius)),
      // padding: EdgeInsets.symmetric(vertical: 16.w),
      padding: EdgeInsets.only(top: 16.w, bottom: safeAreaBottom),
      child: Column(
        children: [
          SizedBox(
            width: 343.w,
            height: 28.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MyText(
                  '选择文件',
                  size: 15.sp,
                  color: k3(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyButton(
                    width: 30.w,
                    height: 28.w,
                    onTap: () {
                      if (!logic.isDialogClosing) {
                        logic.isDialogClosing = true;
                        pop(context: context);
                      }
                    },
                    decoration: BoxDecoration(color: kWhite()),
                    child: Image.asset(
                      R.assetsDialogClose,
                      width: 28.w,
                      height: 28.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (logic.loading.value) return Container();
            return SizedBox(
              height: 60.w,
              child: TabBar(
                controller: logic.tabC,
                tabs: logic.fileTypeList
                    .map((e) => Tab(
                          text: e.title,
                        ))
                    .toList(),
                isScrollable: true,
                labelStyle: TextStyle(
                    color: k4A83FF(),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(
                    color: k3(), fontSize: 12.sp, fontWeight: FontWeight.w600),
                labelColor: k4A83FF(),
                unselectedLabelColor: k3(),
                indicator: GradientTabIndicator(
                    gradient: LinearGradient(colors: [k4A83FF(), k4A83FF()]),
                    borderSide: BorderSide(width: 4.w)),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                labelPadding: EdgeInsets.symmetric(horizontal: 11.w),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (logic.loading.value) {
                return Center(
                  child: SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: CircularProgressIndicator(
                      color: k4A83FF(),
                      strokeWidth: 4.w,
                    ),
                  ),
                );
              }
              return TabBarView(
                controller: logic.tabC,
                children: logic.fileTypeList.map((e) {
                  return MobileSubFileView(e.value, e.count!);
                }).toList(),
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
                        '上传到：',
                        color: k3(),
                        size: 12.sp,
                      ),
                      Image.asset(
                        R.assetsTypeDir,
                        width: 20.w,
                        height: 20.w,
                      ),
                      spaceW(5),
                      Obx(() {
                        return MyText(
                          logic.targetDir.value.title ?? '',
                          color: k6(),
                          size: 12.sp,
                        );
                      })
                    ],
                  ),
                ),
                MyButton(
                  width: 95.w,
                  height: 36.w,
                  child: MyText(
                    '上传',
                    color: kWhite(),
                    size: 12.sp,
                  ),
                  onTap: () {
                    logic.submit();
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
  MobileFileLogic get initController => MobileFileLogic();
}

class MobileFileLogic extends BaseLogic with GetTickerProviderStateMixin {
  final targetDir = Rx(DiskDirEntity()..title = '根目录');
  final loading = true.obs;
  final dataList = <MobileFileEntity>[].obs;
  var currentIndex = 0;
  late final tabC = TabController(length: fileTypeList.length, vsync: this);
  bool isDialogClosing = false; // 新增关闭状态标志
  final fileTypeList = [
    OptionEntity()
      ..title = '全部'
      ..count = 0
      ..value = [
        RegExp(r'^[^.]+\.txt$'),
        RegExp(r'^[^.]+\.pdf$'),
        RegExp(r'^[^.]+\.html$'),
        RegExp(r'^[^.]+\.iso$'),
        RegExp(r'^[^.]+\.rar$'),
        RegExp(r'^[^.]+\.exe$'),
        RegExp(r'^[^.]+\.apk$'),
        RegExp(r'^[^.]+\.zip$'),
        RegExp(r'^[^.]+\.doc$'),
        RegExp(r'^[^.]+\.docx$'),
        RegExp(r'^[^.]+\.xls$'),
        RegExp(r'^[^.]+\.xlsx$'),
        RegExp(r'^[^.]+\.ppt$'),
        RegExp(r'^[^.]+\.pptx$'),
        RegExp(r'^[^.]+\.tar$'),
        RegExp(r'^[^.]+\.7z$'),
        RegExp(r'^[^.]+\.csv$')
      ],
    OptionEntity()
      ..title = 'PDF'
      ..count = 1
      ..value = [RegExp(r'^[^.]+\.pdf$')],
    OptionEntity()
      ..title = '文字'
      ..count = 2
      ..value = [RegExp(r'^[^.]+\.doc$'), RegExp(r'^[^.]+\.docx$')],
    OptionEntity()
      ..title = '表格'
      ..count = 3
      ..value = [
        RegExp(r'^[^.]+\.xls$'),
        RegExp(r'^[^.]+\.xlsx$'),
        RegExp(r'^[^.]+\.csv$')
      ],
    OptionEntity()
      ..title = '演示'
      ..count = 4
      ..value = [RegExp(r'^[^.]+\.ppt$'), RegExp(r'^[^.]+\.pptx$')],
    OptionEntity()
      ..title = 'TXT'
      ..count = 5
      ..value = [RegExp(r'^[^.]+\.txt$')],
    OptionEntity()
      ..title = '压缩包'
      ..count = 6
      ..value = [
        RegExp(r'^[^.]+\.rar$'),
        RegExp(r'^[^.]+\.zip$'),
        RegExp(r'^[^.]+\.tar$'),
        RegExp(r'^[^.]+\.7z$')
      ],
    OptionEntity()
      ..title = '其他'
      ..count = 7
      ..value = [
        RegExp(r'^[^.]+\.html$'),
        RegExp(r'^[^.]+\.iso$'),
        RegExp(r'^[^.]+\.exe$'),
        RegExp(r'^[^.]+\.apk$')
      ],
  ];

  // 定义需要跳过的目录
  final skipDirs = [
    '/storage/emulated/0/Android/obb',
    '/storage/emulated/0/Android/data',
    '/storage/emulated/0/Android/media'
  ];

  @override
  void onInit() async {
    super.onInit();
    tabC.addListener(() {
      for (var element in dataList) {
        element.selected = false;
      }
      find<MobileSubFileLogic>(tag: 'MobileSubFileLogic_$currentIndex')
          ?.dataList
          .refresh();
      find<MobileSubFileLogic>(tag: 'MobileSubFileLogic_${tabC.index}')
          ?.dataList
          .refresh();
      currentIndex = tabC.index;
    });
    // var sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    // if (sdkInt < 33) {
    //   var result = await Permission.storage
    //       .request()
    //       .isGranted;
    //   if (!result) {
    //     showShortToast('权限未开');
    //     return;
    //   }
    // }
    // if (sdkInt >= 30) {
    //   var result = await Permission.manageExternalStorage
    //       .request()
    //       .isGranted;
    //   if (!result) {
    //     showShortToast('管理权限未开');
    //     return;
    //   }
    // }
    getTotalList().then((value) {
      value.sort((a, b) =>
          a.time.millisecondsSinceEpoch < b.time.millisecondsSinceEpoch
              ? 1
              : -1);
      dataList.addAll(value);
      loading.value = false;
    });
  }

  Future<List<MobileFileEntity>> getTotalList() async {
    var dir = Directory('/storage/emulated/0');
    var items = <MobileFileEntity>[];
    final list = await dir.list(followLinks: false).toList();
    var taskList = <Future<List<MobileFileEntity>>>[];
    for (var value in list) {
      final type = await FileSystemEntity.type(value.path);
      if (type == FileSystemEntityType.file) {
        for (var reg in fileTypeList[0].value) {
          if (reg.hasMatch(value.path)) {
            final time = (await value.stat()).changed;
            items.add(MobileFileEntity(path: value.path, time: time));
            break;
          }
        }
      } else if (type == FileSystemEntityType.directory) {
        taskList.add(handler(value));
      }
    }
    var temps = await Future.wait(taskList);
    for (var value in temps) {
      items.addAll(value);
    }
    return items;
  }

  Future<List<MobileFileEntity>> handler(
      FileSystemEntity fileSystemEntity) async {
    try {
      var items = <MobileFileEntity>[];
      var taskList = <Future<List<MobileFileEntity>>>[];
      var list = await Directory(fileSystemEntity.path)
          .list(recursive: false, followLinks: false)
          .toList();
      for (var value in list) {
        // 打印当前处理的路径
        // debugPrint('正在处理路径: ${value.path}');
        // 检查是否是需要跳过的目录
        if (skipDirs.any((skipDir) => value.path.startsWith(skipDir))) {
          continue; // 跳过这个目录
        }
        final type = await FileSystemEntity.type(value.path);
        if (type == FileSystemEntityType.directory) {
          taskList.add(handler(value));
        } else if (type == FileSystemEntityType.file) {
          for (var reg in fileTypeList[0].value) {
            if (reg.hasMatch(value.path)) {
              final time = (await value.stat()).changed;
              items.add(MobileFileEntity(path: value.path, time: time));
              break;
            }
          }
        }
      }
      var temps = await Future.wait(taskList);
      for (var value in temps) {
        items.addAll(value);
      }
      return items;
    } catch (e) {
      //某些私有文件夹不允许访问，会报错，则抛弃
      // print(e);
      // print(fileSystemEntity.path);
      showShortToast(e.toString());
      return [];
    }
  }

  submit() async {
    var list = find<MobileSubFileLogic>(tag: 'MobileSubFileLogic_$currentIndex')
            ?.dataList
            .where((p0) => p0.selected)
            .toList() ??
        [];
    if (list.isEmpty) {
      showShortToast('请选择文件');
      return;
    }
    if (!isDialogClosing) {
      isDialogClosing = true;
      pop();
    }
    var fileList = list.map((e) {
      return {
        'path': e.path, // 文件路径
        'id': '0', // 文件的 ID，如果没有则默认 0
      };
    }).toList();
    await oss.uploadFile(fileList, targetDir.value.id ?? 0);
  }
}
