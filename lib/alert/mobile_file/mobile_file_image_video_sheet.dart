import 'dart:io';

import 'package:desk_cloud/alert/command_target_sheet.dart';
import 'package:desk_cloud/content/preview/video_page.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/entity/disk_dir_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

/// 在后台Isolate中对媒体文件进行分组，避免阻塞UI线程。
Map<String, GroupedItems> _groupMediaItemsForIsolate(
    Map<String, dynamic> params) {
  final List<Medium> items = params['items'];
  final bool isSelectedAll = params['isSelectedAll'];
  final Map<String, GroupedItems> newGroupedItems = {};
  var nowDate = DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd');

  for (var item in items) {
    var itemDate = DateUtil.formatDate(
        Platform.isAndroid ? item.modifiedDate : item.creationDate,
        format: 'yyyy-MM-dd');
    if (nowDate == itemDate) {
      itemDate = '今天';
    }
    if (newGroupedItems[itemDate] == null) {
      newGroupedItems[itemDate] =
          GroupedItems(isSelected: isSelectedAll, items: []);
    }
    newGroupedItems[itemDate]!
        .items
        .add(MediumItem(medium: item, isSelected: isSelectedAll));
  }
  return newGroupedItems;
}

/// 选择图片视频
Future<dynamic> showMobileImageVideoSheet({required MediumType mediumType}) {
  return showModalBottomSheet(
      context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _MobileImageVideoView(mediumType: mediumType);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}

class _MobileImageVideoView extends StatefulWidget {
  final MediumType mediumType;
  const _MobileImageVideoView({required this.mediumType});

  @override
  State<_MobileImageVideoView> createState() => _MobileImageVideoViewState();
}

class _MobileImageVideoViewState
    extends BaseXState<_MobileImageVideoLogin, _MobileImageVideoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h - 60.w,
      decoration: BoxDecoration(
          color: kWhite(), borderRadius: BorderRadius.vertical(top: 20.radius)),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (logic._currentPage?.isLast ?? false) {
            return false;
          }
          if (!logic.isLoading.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // 当滚动到底部时加载更多媒体
            logic.loadMoreMedia();
            return true;
          }
          return false;
        },
        child: Column(
          children: [
            _fileBar(),
            Expanded(child: Obx(() {
              if (logic.isLoading.value && logic.groupedItems.isEmpty) {
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
              } else if (logic.groupedItems.isEmpty) {
                return const Center(
                  child: EmptyView(title: '没有文件~'),
                );
              }
              return _fileContont();
            }))
          ],
        ),
      ),
    );
  }

  Widget _fileBar() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyButton(
            onTap: () => pop(),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Image.asset(
              R.assetsDialogClose,
              width: 28.w,
              height: 28.w,
            ),
          ),

          // 根据媒体类型决定是否显示相册切换功能
          if (widget.mediumType == MediumType.image)
            MyButton(
              onTap: () {
                logic.showAlbumSelectionSheet(context);
              },
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Obx(() => Row(
                    children: [
                      MyText(
                        logic.currentAlbumName.value,
                        size: 15.sp,
                      ),
                      Image.asset(
                        R.assetsIcDropDowne,
                        width: 24.w,
                        height: 24.w,
                      )
                    ],
                  )),
            )
          else
            MyText(
              '全部视频',
              size: 15.sp,
            ),

          MyButton(
            onTap: () {
              logic.selectFirstMaxItems();
            },
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              children: [
                MyText(
                  '全选',
                  size: 14.sp,
                  color: k4A83FF(),
                ),
                spaceW(5),
                Obx(() => Image.asset(
                      logic.isSelectedAll.value
                          ? R.assetsCheckRoundY
                          : R.assetsCheckRoundN,
                      width: 16.w,
                      height: 16.w,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _fileContont() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40.h + safeAreaBottom),
          child: Column(
            children: [
              ...logic.groupedItems.entries.map((item) {
                GroupedItems groupedItem = logic.groupedItems[item.key]!;
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16.w, right: 20.w),
                      height: 50.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            item.key,
                            size: 15.sp,
                          ),
                          MyButton(
                            onTap: () {
                              logic.clickGroupedItem(item.key);
                            },
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                groupedItem.isSelected
                                    ? R.assetsCheckRoundY
                                    : R.assetsIcPhotoCheckAllRoundN,
                                width: 16.w,
                                height: 16.w,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2.5.w,
                          crossAxisSpacing: 2.5.w,
                          childAspectRatio: 92 / 92),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            MyInkWell(
                              onTap: () async {
                                // File file = await groupedItem.items[index].medium.getFile();
                                File? file = await logic.getFileWithCache(
                                    groupedItem.items[index].medium);
                                if (groupedItem
                                        .items[index].medium.mediumType ==
                                    MediumType.image) {
                                  push(MyRouter.imagePreview, args: file?.path);
                                } else {
                                  // push(MyRouter.videoPreview, args: file?.path);
                                  // push(MyRouter.videoView, args: file?.path);
                                  showVideoPage(pathUrl: file?.path ?? '');
                                }
                              },
                              child: Image(
                                image: ThumbnailProvider(
                                  mediumId: groupedItem
                                      .items[index].medium.id, // 媒体的唯一 ID
                                  mediumType: widget.mediumType, // 媒体类型
                                  highQuality: true, // 是否为高质量图片
                                ),
                                fit: BoxFit.cover, // 充满方式
                                width: 92.w,
                                height: 92.w,
                              ),
                            ),
                            Positioned(
                                top: 3.w,
                                right: 3.w,
                                child: MyButton(
                                  onTap: () {
                                    logic.clickItem(item.key, index);
                                  },
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent),
                                  child: Container(
                                    width: 24.w,
                                    height: 24.w,
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      groupedItem.items[index].isSelected
                                          ? R.assetsCheckRoundY
                                          : R.assetsIcPhotoCheckRoundN,
                                      width: 16.w,
                                      height: 16.w,
                                    ),
                                  ),
                                ))
                          ],
                        );
                      },
                      itemCount: groupedItem.items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    )
                  ],
                );
              }).toList(),
              Obx(() {
                if (!logic.hasMoreMedia.value &&
                    logic.groupedItems.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Center(
                        child: MyText(
                      '没有更多了',
                      size: 14.sp,
                      color: k9(),
                    )),
                  );
                }
                if (logic.isLoading.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                        child: SizedBox(
                      width: 30.w,
                      height: 30.w,
                      child: CircularProgressIndicator(
                        color: k4A83FF(),
                        strokeWidth: 4.w,
                      ),
                    )),
                  );
                }
                return const SizedBox.shrink();
              })
            ],
          ),
        ),
        Positioned(
            bottom: 0 + safeAreaBottom,
            child: Container(
              height: 40.w,
              width: 375.w,
              // margin: EdgeInsets.only(bottom: safeAreaBottom),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.transparent,
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
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                          color: kWhite(), borderRadius: 10.borderRadius),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          MyText(
                            '上传到：',
                            size: 12.sp,
                          ),
                          Image.asset(
                            R.assetsTypeDir,
                            width: 20.w,
                            height: 20.w,
                          ),
                          spaceW(4.w),
                          Obx(() {
                            return MyText(
                              logic.targetDir.value.title ?? '',
                              size: 12.sp,
                              color: k6(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  MyButton(
                    title: '上传(${logic.selectedMediumArr.length})',
                    width: 95.w,
                    height: 36.h,
                    onTap: () async {
                      pop();
                      if (logic.selectedMediumArr.isEmpty) {
                        return;
                      }
                      // showLoading();
                      // var list = await Future.wait(logic.selectedMediumArr.map((element) => element.getFile()).toList());
                      // dismissLoading();
                      // oss.uploadFile(list.map((e) => e.path).toList(), logic.targetDir.value.id ?? 0);
                      showLoading();
                      // 并行获取文件信息，并组装成指定格式
                      var fileList = await Future.wait(
                          logic.selectedMediumArr.map((element) async {
                        var file = await element.getFile(); // 获取文件
                        return {
                          'path': file.path, // 文件路径
                          'id': element.id, // Medium 的 ID
                        };
                      }));
                      oss.uploadFile(fileList, logic.targetDir.value.id ?? 0);
                    },
                  )
                ],
              ),
            ))
      ],
    );
  }

  @override
  _MobileImageVideoLogin get initController =>
      _MobileImageVideoLogin(mediumType: widget.mediumType);
}

class _MobileImageVideoLogin extends BaseLogic {
  final MediumType mediumType;
  _MobileImageVideoLogin({required this.mediumType});
  final targetDir = Rx(DiskDirEntity()..title = '根目录');
  var isLoading = false.obs; // 是否正在加载
  Album? _currentAlbum; // 当前的相册
  final currentAlbumName = '最近项目'.obs;
  final currentAlbumId = ''.obs; // 添加一个用于UI显示的当前相册ID
  final hasMoreMedia = true.obs; // 是否有更多媒体可以加载
  MediaPage? _currentPage;
  final selectedMediumArr = <Medium>[].obs;
  final groupedItems = RxMap<String, GroupedItems>();
  var isSelectedAll = false.obs;
  // final int _maxItemsToSelect = 100;

  @override
  onInit() async {
    // var result = false;
    // if (Platform.isIOS) {
    //   result = await Permission.storage
    //       .request()
    //       .isGranted;
    // } else {
    //   var sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    //   if (sdkInt < 33) {
    //     result = await Permission.storage
    //         .request()
    //         .isGranted;
    //   }
    //   if (sdkInt >= 30) {
    //     result = await Permission.manageExternalStorage
    //         .request()
    //         .isGranted;
    //   }
    // }
    // if (!result) {
    //   showShortToast('权限未开');
    //   return;
    // }
    super.onInit();
    groupedItems.clear();
    // 延迟加载，以确保UI动画流畅
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAlbum(); // 加载相册
    });
  }

  // 切换相册
  Future<void> switchAlbum(Album album) async {
    if (_currentAlbum?.id == album.id) return;

    _currentAlbum = album;
    currentAlbumName.value = album.name ?? '最近项目';
    currentAlbumId.value = album.id; // 确保更新当前相册ID
    hasMoreMedia.value = true;
    // 清空当前数据
    groupedItems.clear();
    selectedMediumArr.clear();
    isSelectedAll.value = false;

    // 重新加载媒体
    await loadMedia();
  }

  // 加载相册
  Future<void> loadAlbum() async {
    // 获取所有相册
    List<Album> albums = await PhotoGallery.listAlbums(mediumType: mediumType);
    if (albums.isNotEmpty) {
      _currentAlbum = albums.first;
      currentAlbumName.value = albums.first.name ?? '最近项目';
      currentAlbumId.value = albums.first.id; // 初始化当前相册ID
      await loadMedia();
    }
  }

  // 分页加载媒体
  Future<void> loadMedia() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      _currentPage = await _currentAlbum!.listMedia(take: 30);
      await _getGroupedFiles(_currentPage?.items ?? []);
      hasMoreMedia.value = !(_currentPage?.isLast ?? true);
    } catch (e) {
      showShortToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  loadMoreMedia() async {
    if (isLoading.value ||
        !hasMoreMedia.value ||
        _currentAlbum == null ||
        (_currentPage?.isLast ?? true)) {
      return;
    }
    isLoading.value = true;
    try {
      _currentPage = await _currentPage!.nextPage();
      await _getGroupedFiles(_currentPage?.items ?? [], isLoadMore: true);
      hasMoreMedia.value = !(_currentPage?.isLast ?? true);
    } catch (e) {
      showShortToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getGroupedFiles(List<Medium> items,
      {bool isLoadMore = false}) async {
    if (items.isEmpty) return;

    if (!isLoadMore) {
      groupedItems.clear();
    }

    // 使用compute将耗时的分组操作移到后台Isolate
    final newGroups = await compute(_groupMediaItemsForIsolate, {
      'items': items,
      'isSelectedAll': isSelectedAll.value,
    });

    // 在主线程中安全地合并结果
    if (isSelectedAll.value) {
      selectedMediumArr.addAll(items);
    }

    newGroups.forEach((date, newGroup) {
      if (groupedItems.containsKey(date)) {
        groupedItems[date]!.items.addAll(newGroup.items);
      } else {
        groupedItems[date] = newGroup;
      }
    });

    groupedItems.refresh();
  }

  clickItem(String date, int index) {
    // 如果组内的所有项目都选中了，就选中该组
    var medium = groupedItems[date]!.items[index].medium;
    if (selectedMediumArr.contains(medium)) {
      selectedMediumArr.remove(medium);
    } else {
      selectedMediumArr.add(medium);
    }
    groupedItems[date]!.items[index].isSelected =
        !groupedItems[date]!.items[index].isSelected;
    groupedItems[date]!.isSelected =
        groupedItems[date]!.items.every((item) => item.isSelected);
    isSelectedAll.value =
        groupedItems.entries.every((item) => item.value.isSelected);
    groupedItems.refresh();
  }

  clickGroupedItem(String date) {
    var value = !groupedItems[date]!.isSelected;
    for (var item in groupedItems[date]!.items) {
      item.isSelected = value;
      if (item.isSelected && !selectedMediumArr.contains(item.medium)) {
        selectedMediumArr.add(item.medium);
      } else if (!item.isSelected && selectedMediumArr.contains(item.medium)) {
        selectedMediumArr.remove(item.medium);
      }
    }
    // 如果组内的所有项目都选中了，就选中该组
    groupedItems[date]!.isSelected =
        groupedItems[date]!.items.every((item) => item.isSelected);
    isSelectedAll.value =
        groupedItems.entries.every((item) => item.value.isSelected);
    groupedItems.refresh();
  }

  // 全选
  selectFirstMaxItems() {
    selectedMediumArr.clear();
    isSelectedAll.value = !isSelectedAll.value;
    // int selectedCount = 0;
    groupedItems.forEach((date, grouped) {
      for (var item in grouped.items) {
        // if (selectedCount < _maxItemsToSelect) {
        //   item.isSelected = true;
        //   selectedCount++;
        //   selectedMediumArr.add(item.medium);
        // } else {
        //   item.isSelected = false;
        // }
        item.isSelected = isSelectedAll.value;
        if (isSelectedAll.value) {
          selectedMediumArr.add(item.medium);
        }
      }
      // 如果组内的所有项目都选中了，就选中该组
      grouped.isSelected = grouped.items.every((item) => item.isSelected);
    });
    groupedItems.refresh();
  }

  // 添加文件缓存
  final Map<String, File> _fileCache = {};

  // 获取文件的方法（供外部调用）
  Future<File?> getFileWithCache(Medium medium) async {
    try {
      // 如果缓存中存在，直接返回
      if (_fileCache.containsKey(medium.id)) {
        return _fileCache[medium.id];
      }
      showLoading();
      // 获取并缓存文件
      final file = await medium.getFile();
      _fileCache[medium.id] = file;
      dismissLoading();
      return file;
    } catch (e) {
      debugPrint('获取文件失败: ${e.toString()}');
      return null;
    }
  }

  @override
  onClose() {
    _fileCache.clear();
    super.onClose();
  }

  Future<void> showAlbumSelectionSheet(BuildContext context) async {
    final albums = await PhotoGallery.listAlbums(mediumType: mediumType);
    final Album? selectedAlbum = await showModalBottomSheet<Album>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _AlbumSelectionSheet(
          albums: albums,
          currentAlbum: _currentAlbum!,
        );
      },
    );

    if (selectedAlbum != null) {
      await switchAlbum(selectedAlbum);
    }
  }
}

// 定义项目类，包含标题、日期和选中状态
class MediumItem {
  Medium medium;
  bool isSelected; // 是否选中

  MediumItem({
    required this.medium,
    this.isSelected = false,
  });
}

// 定义分组类，包含项目列表和分组的选中状态
class GroupedItems {
  bool isSelected; // 是否选中该日期下的所有项目
  List<MediumItem> items;

  GroupedItems({
    required this.isSelected,
    required this.items,
  });
}

class _AlbumSelectionSheet extends StatelessWidget {
  final List<Album> albums;
  final Album currentAlbum;

  const _AlbumSelectionSheet(
      {Key? key, required this.albums, required this.currentAlbum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
          color: kWhite(),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.w),
            child: MyText('选择相册', size: 16.sp, bold: true),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                final isSelected = album.id == currentAlbum.id;
                return ListTile(
                  leading: SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        image: AlbumThumbnailProvider(
                          album: album,
                          highQuality: true,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    album.name ?? "全部",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "${album.count} 项",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: k4A83FF())
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(album);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
