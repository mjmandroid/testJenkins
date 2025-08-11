// import 'package:desk_cloud/content/user/oss_logic.dart';
// import 'package:desk_cloud/entity/disk_dir_entity.dart';
// import 'package:desk_cloud/utils/export.dart';
// import 'package:desk_cloud/widgets/empty_view.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';

// /// 选择图片视频 （未完成、、、建议将 showMobileImageVideoSheet 替换成 showMobileFileAssetSheet，修改使用 photo_manager 这个插件）
// Future<dynamic> showMobileFileAssetSheet({required RequestType requestType}) {
//   return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
//     builder: (context) {
//       return _MobileFileAssetView(requestType: requestType);
//     },
//     backgroundColor: Colors.transparent,
//     isDismissible: false,
//     isScrollControlled: true
//   );
// }

// class _MobileFileAssetView extends StatefulWidget {

//   final RequestType requestType;
//   const _MobileFileAssetView({required this.requestType});

//   @override
//   State<_MobileFileAssetView> createState() => _MobileFileAssetViewState();
// }

// class _MobileFileAssetViewState extends BaseXState<_MobileFileAssetViewLogic, _MobileFileAssetView> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 812.h - 60.w,
//       decoration: BoxDecoration(
//         color: kWhite(),
//         borderRadius: BorderRadius.vertical(top: 20.radius)
//       ),
//       child: NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollInfo) {
//           return true;
//         },
//         child: Column(
//           children: [
//             _fileBar(),
//             // Expanded(
//             //   child: const Center(
//             //     child: EmptyView(title: '没有文件~'),
//             //   ),
//             // )
//             // Expanded(child: Obx(() => logic.assets.isEmpty ? const Center(
//             //     child: EmptyView(title: '没有文件~'),
//             //   ) : ListView.builder(
//             //     itemCount: logic.assets.length,
//             //     itemBuilder: (context, index) {
//             //       return AssetEntityImage(
//             //         logic.assets[index],
//             //         isOriginal: false,
//             //         thumbnailSize: const ThumbnailSize.square(200),
//             //         thumbnailFormat: ThumbnailFormat.jpeg,
//             //       );
//             //   })
//             // ))
            
            
//             // Expanded(child: Obx(() => GridView.builder(
//             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //     crossAxisCount: 4,
//             //     mainAxisSpacing: 2.5.w,
//             //     crossAxisSpacing: 2.5.w,
//             //     childAspectRatio: 92 / 92
//             //   ),
//             //   itemBuilder: (context, index) {
//             //     return Stack(
//             //       children: [
//             //         // MyInkWell(
//             //         //   onTap: () async {
//             //         //     // File file = await groupedItem.items[index].medium.getFile();
//             //         //     File? file = await logic.getFileWithCache(groupedItem.items[index].medium);
//             //         //     if (groupedItem.items[index].medium.mediumType == MediumType.image) {
//             //         //       push(MyRouter.imagePreview, args: file?.path);
//             //         //     } else {
//             //         //       // push(MyRouter.videoPreview, args: file?.path);
//             //         //       // push(MyRouter.videoView, args: file?.path);
//             //         //       showVideoPage(pathUrl: file?.path ?? '');
//             //         //     }
//             //         //   },
//             //         //   child: Image(
//             //         //     image: ThumbnailProvider(
//             //         //       mediumId: groupedItem.items[index].medium.id, // 媒体的唯一 ID
//             //         //       mediumType: widget.mediumType, // 媒体类型
//             //         //       highQuality: true, // 是否为高质量图片
//             //         //     ),
//             //         //     fit: BoxFit.cover, // 充满方式
//             //         //     width: 92.w,
//             //         //     height: 92.w,
//             //         //   ),
//             //         // ),
//             //         AssetEntityImage(
//             //           logic.assets[index],
//             //           isOriginal: false,
//             //           thumbnailSize: const ThumbnailSize.square(200),
//             //           thumbnailFormat: ThumbnailFormat.jpeg,
//             //           width: 92.w,
//             //           height: 92.w,
//             //           fit: BoxFit.cover,
//             //         ),
//             //         Positioned(
//             //           top: 3.w,
//             //           right: 3.w,
//             //           child: MyButton(
//             //             onTap: () {
//             //               // logic.clickItem(item.key, index);
//             //             },
//             //             decoration: const BoxDecoration(
//             //               color: Colors.transparent
//             //             ),
//             //             child: Container(
//             //               width: 24.w,
//             //               height: 24.w,
//             //               alignment: Alignment.topRight,
//             //               child: Image.asset(
//             //                 // groupedItem.items[index].isSelected ? R.assetsCheckRoundY : R.assetsIcPhotoCheckRoundN,
//             //                 R.assetsIcPhotoCheckRoundN,
//             //                 width: 16.w,
//             //                 height: 16.w,
//             //               ),
//             //             ),
//             //           )
//             //         )
//             //       ],
//             //     );
//             //   },
//             //   itemCount: logic.assets.length,
//             //   shrinkWrap: true,
//             //   physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
//             // )))

//             Expanded(child: Obx(() {
//               if (logic.groupedItems.isEmpty) {
//                 return const Center(
//                   child: EmptyView(title: '没有文件~'),
//                 );
//               }
//               return _fileContont();
//             }))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _fileBar() {
//     return Container(
//       height: 50.h,
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           MyButton(
//             onTap: () => pop(),
//             decoration: const BoxDecoration(
//               color: Colors.transparent
//             ),
//             child: Image.asset(
//               R.assetsDialogClose,
//               width: 28.w,
//               height: 28.w,
//             ),
//           ),
//           MyButton(
//             decoration: const BoxDecoration(
//               color: Colors.transparent
//             ),
//             child: Row(
//               children: [
//                 MyText(
//                   '最近项目',
//                   size: 15.sp,
//                 ),
//                 Image.asset(
//                   R.assetsIcDropDowne,
//                   width: 24.w,
//                   height: 24.w,
//                 )
//               ],
//             ),
//           ),
//           MyButton(
//             onTap: () {
//               // logic.selectFirstMaxItems();
//             },
//             decoration: const BoxDecoration(
//               color: Colors.transparent
//             ),
//             child: Row(
//               children: [
//                 MyText(
//                   '全选',
//                   size: 14.sp,
//                   color: k4A83FF(),
//                 ),
//                 spaceW(5),
//                 Obx(() =>
//                   Image.asset(
//                     logic.isSelectedAll.value ? R.assetsCheckRoundY : R.assetsCheckRoundN,
//                     width: 16.w,
//                     height: 16.w,
//                   )
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _fileContont() {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: 40.h + safeAreaBottom),
//           child: Column(
//             children: logic.groupedItems.entries.map((item) {
//               GroupedItems groupedItem = logic.groupedItems[item.key]!;
//               return Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(left: 16.w, right: 20.w),
//                     height: 50.h,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         MyText(
//                           item.key,
//                           size: 15.sp,
//                         ),
//                         MyButton(
//                           onTap: () {
//                             logic.clickGroupedItem(item.key);
//                           },
//                           decoration: const BoxDecoration(
//                               color: Colors.transparent
//                           ),
//                           child: Container(
//                             width: 24.w,
//                             height: 24.w,
//                             alignment: Alignment.centerRight,
//                             child: Image.asset(
//                               groupedItem.isSelected ? R.assetsCheckRoundY : R.assetsIcPhotoCheckAllRoundN,
//                               width: 16.w,
//                               height: 16.w,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         mainAxisSpacing: 2.5.w,
//                         crossAxisSpacing: 2.5.w,
//                         childAspectRatio: 92 / 92
//                     ),
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         children: [
//                           MyInkWell(
//                             onTap: () async {
//                               // File file = await groupedItem.items[index].medium.getFile();
//                               File? file = await logic.getFileWithCache(groupedItem.items[index].medium);
//                               if (groupedItem.items[index].medium.mediumType == MediumType.image) {
//                                 push(MyRouter.imagePreview, args: file?.path);
//                               } else {
//                                 // push(MyRouter.videoPreview, args: file?.path);
//                                 // push(MyRouter.videoView, args: file?.path);
//                                 showVideoPage(pathUrl: file?.path ?? '');
//                               }
//                             },
//                             child: Image(
//                               image: ThumbnailProvider(
//                                 mediumId: groupedItem.items[index].medium.id, // 媒体的唯一 ID
//                                 mediumType: widget.mediumType, // 媒体类型
//                                 highQuality: true, // 是否为高质量图片
//                               ),
//                               fit: BoxFit.cover, // 充满方式
//                               width: 92.w,
//                               height: 92.w,
//                             ),
//                           ),
//                           Positioned(
//                             top: 3.w,
//                             right: 3.w,
//                             child: MyButton(
//                               onTap: () {
//                                 // logic.clickItem(item.key, index);
//                               },
//                               decoration: const BoxDecoration(
//                                 color: Colors.transparent
//                               ),
//                               child: Container(
//                                 width: 24.w,
//                                 height: 24.w,
//                                 alignment: Alignment.topRight,
//                                 child: Image.asset(
//                                   groupedItem.items[index].isSelected ? R.assetsCheckRoundY : R.assetsIcPhotoCheckRoundN,
//                                   width: 16.w,
//                                   height: 16.w,
//                                 ),
//                               ),
//                             )
//                           )
//                         ],
//                       );
//                     },
//                     itemCount: groupedItem.items.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
//                   )
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//         Positioned(
//             bottom: 0 + safeAreaBottom,
//             child: Container(
//               height: 40.w,
//               width: 375.w,
//               // margin: EdgeInsets.only(bottom: safeAreaBottom),
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               color: Colors.transparent,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       // var r = await showCommandTargetSheet();
//                       // if (r != null) {
//                       //   logic.targetDir.value = r;
//                       // }
//                     },
//                     child: Container(
//                       height: 36.h,
//                       decoration: BoxDecoration(
//                           color: kWhite(),
//                           borderRadius: 10.borderRadius
//                       ),
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: Row(
//                         children: [
//                           MyText(
//                             '上传到：',
//                             size: 12.sp,
//                           ),
//                           Image.asset(
//                             R.assetsTypeDir,
//                             width: 20.w,
//                             height: 20.w,
//                           ),
//                           spaceW(4.w),
//                           Obx(() {
//                             return MyText(
//                               logic.targetDir.value.title ?? '',
//                               size: 12.sp,
//                               color: k6(),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                   MyButton(
//                     title: '上传(${logic.selectedAssetArr.length})',
//                     width: 95.w,
//                     height: 36.h,
//                     onTap: ()async{
//                       pop();
//                       if (logic.selectedAssetArr.isEmpty){
//                         return;
//                       }
//                       // showLoading();
//                       // var list = await Future.wait(logic.selectedMediumArr.map((element) => element.getFile()).toList());
//                       // dismissLoading();
//                       // oss.uploadFile(list.map((e) => e.path).toList(), logic.targetDir.value.id ?? 0);
//                       showLoading();
//                       // 并行获取文件信息，并组装成指定格式
//                       var fileList = await Future.wait(logic.selectedAssetArr.map((element) async {
//                         var file = await element.file; // 获取文件
//                         return {
//                           'path': file!.path, // 文件路径
//                           'id': element.id,  // Medium 的 ID
//                         };
//                       }));
//                       oss.uploadFile(fileList, logic.targetDir.value.id ?? 0);
//                     },
//                   )
//                 ],
//               ),
//             )
//         )
//       ],
//     );
//   }
  
//   @override
//   _MobileFileAssetViewLogic get initController => _MobileFileAssetViewLogic(requestType: widget.requestType);
// }

// class _MobileFileAssetViewLogic extends BaseLogic {

//   final RequestType requestType;
//   _MobileFileAssetViewLogic({required this.requestType});

//   int page = 1;
//   int pageCount = 30;
//   int assetsCount = 0;
//   /// 是否全选
//   final isSelectedAll = false.obs;
//   /// 按日期分组
//   final groupedItems = RxMap<String, GroupedItems>();
//   /// 选中的文件
//   final selectedAssetArr = <AssetEntity>[].obs;
//   /// 上传到
//   final targetDir = Rx(DiskDirEntity()..title = '根目录');
//   var assets = <AssetEntity>[].obs;

//   @override
//   void onInit() async {
//     super.onInit();
//     // 0.5.delay(() {
//     //   loadAssets();
//     // });
//     groupedItems.clear();
//     page = 1;
//     assetsCount = 0;
//     assetsCount = await PhotoManager.getAssetCount(type: requestType);
//     loadAssets();
//   }

//   /// 加载相册文件
//   Future<void> loadAssets() async {
//     try {
//       showLoading();
//       await 0.5.delay(() {});
//       List<AssetEntity> list = await PhotoManager.getAssetListPaged(page: page, pageCount: pageCount, type: requestType);
//       _getGroupedFiles(list);
//       print('--------------------------------');
//       print(groupedItems.length);
//       print(groupedItems);
//       print('--------------------------------');
//       dismissLoading();
//     } catch (e) {
//       showShortToast(e.toString());
//     }
//   }

//   _getGroupedFiles(List<AssetEntity> list) {
//     var nowDate = DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd');
//     // 按日期分组并初始化选中状态
//     for (var item in list) {
//       var itemDate = DateUtil.formatDate(item.modifiedDateTime, format: 'yyyy-MM-dd');
//       if (nowDate == itemDate) {
//         itemDate = '今天';
//       }
//       if (groupedItems[itemDate] == null) {
//         groupedItems[itemDate] = GroupedItems(isSelected: isSelectedAll.value, items: []);
//       }
//       groupedItems[itemDate]!.items.add(AssetItem(asset: item, isSelected: isSelectedAll.value));
//       if (isSelectedAll.value) {
//         selectedAssetArr.add(item);
//       }
//     }
//   }
    
// }

// // 定义项目类，包含标题、日期和选中状态
// class AssetItem {
//   AssetEntity asset;
//   bool isSelected; // 是否选中

//   AssetItem({
//     required this.asset,
//     this.isSelected = false,
//   });
// }

// // 定义分组类，包含项目列表和分组的选中状态
// class GroupedItems {
//   bool isSelected; // 是否选中该日期下的所有项目
//   List<AssetItem> items;

//   GroupedItems({
//     required this.isSelected,
//     required this.items,
//   });
// }