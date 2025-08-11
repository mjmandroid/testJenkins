import 'dart:io';

import 'package:desk_cloud/alert/file_info_sheet.dart';
import 'package:desk_cloud/alert/file_share_sheet.dart';
import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/content/user/local_file_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

class IoOptionContainer extends StatefulWidget {
  final Widget child;
  final Function(IoOptionController controller)? onCreate;
  const IoOptionContainer({ required this.child, this.onCreate, super.key});

  @override
  State<IoOptionContainer> createState() => _IoOptionContainerState();
}

class _IoOptionContainerState extends State<IoOptionContainer> with TickerProviderStateMixin  {

  final logic = IoOptionController._();
  @override
  void initState() {
    super.initState();
    logic.provider = this;
    logic.addListener(_listener);
    logic.initAnimationController();
    widget.onCreate?.call(logic);
  }

   _listener() {
    if (mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite(),
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          () {
            if (logic._topAnima == null) return Container();
            return AnimatedBuilder(animation: logic._topAnima!, builder: (context, child) {
              return Positioned(
                top: logic._topAnima!.value,
                child: Container(
                  width: 375.w,
                  height: 50 + safeAreaTop,
                  color: kWhite(),
                  padding: EdgeInsets.only(top: safeAreaTop,left: 16.w,right: 16.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      MyText('已选择${logic.dataList.length}项', size: 15.sp, color: k3(),),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            onTap: () {
                              logic._onHidden?.call();
                              logic.hidden();
                            },
                            child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyButton(
                          width: 52.w,
                          height: 28.w,
                          onTap: () {
                            logic._onTotalSelected?.call(logic,!logic._totalSelected);
                          },
                          decoration: BoxDecoration(
                              color: kWhite()
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText('全选', color: !logic._totalSelected ? k3() : k4A83FF(), size: 14.w,),
                              CheckView(size: 14.w, selected: logic._totalSelected,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }(),
          () {
            if (logic._bottomAnima == null) return Container();
            return AnimatedBuilder(animation: logic._bottomAnima!, builder: (context, child) {
              return Positioned(
                bottom: logic._bottomAnima!.value,
                child: SizedBox(
                  width: 375.w,
                  height: safeAreaBottom + 93.w,
                  child: Stack(
                    children: [
                      Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [kWhite(0),kWhite(),kWhite()],begin: Alignment.topCenter,end: Alignment.bottomCenter),),)),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 343.w,
                          decoration: BoxDecoration(
                              borderRadius: 16.borderRadius,
                              color: kWhite(),
                              border: Border.all(color: kE(),width: 0.5.w),
                              boxShadow: [
                                BoxShadow(color: k3(0.16),offset: Offset(0, -2.5.w),blurRadius: 16.w)
                              ]
                          ),
                          padding: EdgeInsets.only(top: 16.w,bottom: 16.w),
                          child: MasonryGridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: logic._typeList.length,
                            mainAxisSpacing: 10.w,
                            itemBuilder: (context,index){
                              var canClick = logic.dataList.canOption(logic._typeList[index]);
                              // var canClick = true;
                              return InkWell(
                                onTap: (){
                                  if (!canClick) return;
                                  logic.handlerFile(logic._typeList[index]);
                                },
                                child: Opacity(
                                  opacity: canClick ? 1 : 0.3,
                                  child: SizedBox(
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(logic._typeList[index].icon,width: 18.w,height: 18.w,),
                                          spaceH(8),
                                          MyText(logic._typeList[index].name,color: k3(),size: 11.sp,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: logic._typeList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
          }(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    logic.removeListener(_listener);
    super.dispose();
  }

}

typedef IoTotalSelectedCallback = Function(IoOptionController controller,bool hasTotal);
typedef HiddenSelectedCallback = Function();
typedef IoClickCallback = Function(FileOptionType type,List<dynamic> fileList);

class IoOptionController extends ChangeNotifier {

  IoOptionController._();
  AnimationController? _animaC;
  TickerProvider? provider;
  Animation<double>? _topAnima;
  Animation<double>? _bottomAnima;
  final dataList = <IoDataResoult>[];
  var _totalSelected = false;
  var showing = false.obs;
  IoTotalSelectedCallback? _onTotalSelected;
  HiddenSelectedCallback? _onHidden;
  var allowSelected = false.obs;
  // 定义图像和视频的后缀集合
  // final List<String> imageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  // final List<String> videoFormats = ['mp4', 'mov', 'avi', 'mkv'];

  final _typeList = [
    FileOptionType.save,
    FileOptionType.share,
    FileOptionType.delete,
    FileOptionType.detail,
    FileOptionType.other
  ];

  // bool get showing => _showing;
  set totalSelected(bool value){
    _totalSelected = value;
    if (hasListeners){
      notifyListeners();
    }
  }

  initAnimationController() {
    showing.value = false;
    // _typeList.clear();
    _animaC?.reset();
    _animaC?.dispose();
    _animaC = AnimationController(duration: 0.18.seconds, vsync: provider!);
    _topAnima = Tween<double>(begin: -(safeAreaTop + 50),end: 0).animate(_animaC!);
    _bottomAnima = Tween<double>(begin: -(safeAreaBottom + 93.w),end: 0).animate(_animaC!);
  }

  show(Iterable<IoDataResoult>? list) {
    dataList.clear();
    dataList.addAll(list ?? []);
    if (hasListeners){
      notifyListeners();
    }
    /// 选中数据为空时，隐藏下方操作栏
    // if (dataList.isEmpty){
    //   hidden();
    //   return;
    // }
    if (!showing.value) {
      _animaC?.forward();
      showing.value = true;
    }
  }

  hidden() {
    _animaC?.reverse();
    showing.value = false;
    for (var value in dataList) {
      value.isSelected = false;
    }
    _onTotalSelected = null;
    _onHidden = null;
    allowSelected.value = false;
  }

  addSelectedCallback(IoTotalSelectedCallback? callback) {
    _onTotalSelected = callback;
  }

  addHiddenCallback(HiddenSelectedCallback? callback) {
    _onHidden = callback;
  }

  handlerFile(FileOptionType type)async{
    switch(type){
      case FileOptionType.save:
        // List<XFile> arr = [];
        // for(var item in dataList) {
        //   final cacheFile = File(item.item.localPath ?? '');
        //   arr.add(XFile(cacheFile.path));
        // }
        // if (Platform.isIOS) {
        //   await Share.shareXFiles(
        //     arr,
        //   );
        //   return;
        // }
        if (Platform.isAndroid) {
          _saveFileToAndroid();
        } else {
          _saveFileToIOS();
        }
        _onHidden?.call();
        hidden();
        break;
      case FileOptionType.share:
        var tempDataList = <DiskFileEntity>[];
        for (var item in dataList) {
          var itemEntity = DiskFileEntity()
                            ..id = item.item.dirId
                            ..isDir = 0
                            ..title = item.item.fileName;
          tempDataList.add(itemEntity);
        }
        await showFileShareSheet(tempDataList);
        // _onHidden?.call();
        // hidden();
        break;
      case FileOptionType.delete:
        var res = await showNormalDialog(
          title: '删除记录',
          message: '确定要删除所选下载记录吗？'
        );
        if (!res) return;

        _onHidden?.call();
        hidden();
        oss.realm.write(() {
          for (var element in dataList) {
            var itemToDelete = oss.downloadTaskList.value.firstWhere((item) => item.taskId == element.item.taskId);
            oss.realm.delete(itemToDelete);
          }
        });
        oss.downloadTaskList.refresh();
        showShortToast('删除成功');
        break;  
      case FileOptionType.detail:
        _onHidden?.call();
        hidden();
        showFileInfoSheet(dataList.firstOrNull?.item.dirId ?? 0, dataList: dataList);
        break;
      case FileOptionType.other:
        localFileLogic.openOtherApplications(dataList.firstOrNull?.item.localPath ?? '');
        _onHidden?.call();
        hidden();
        break;
      default:
        hidden();
        break;
    }
    // _onClick?.call(type, List.from(dataList));
  }

  // 检查是否为图像或视频文件
  bool _isMediaFile(String? fileName) {
    final extension = fileName?.split('.').lastOrNull;
    return extension != null && (imageFormats.contains(extension) || videoFormats.contains(extension));
  }

  // 保存文件到 Android
  Future<void> _saveFileToAndroid() async {
    int successCount = 0;
    int failCount = 0;
    var res = await requestMyPhotosPermission(androidPermission: Permission.manageExternalStorage);
    if (!res) return;
    for (var item in dataList) {
      final cacheFile = await localFileLogic.getLocalFile(item.item.localPath ?? '');
      if (cacheFile == null) {
        showShortToast('${item.item.fileName} 文件已失效，请重新下载');
        continue;
      }
      try {
        if (_isMediaFile(item.item.fileName)) {
          await cacheFile.setLastModified(DateTime.now());
          // await ImageGallerySaver.saveFile(cacheFile.path);
          final extension = item.item.fileName?.split('.').lastOrNull;
          // 保存图片
          if (imageFormats.contains(extension)) {
            AssetEntity? assetEntity = await PhotoManager.editor.saveImageWithPath(cacheFile.path, title: item.item.fileName ?? '');
            if (assetEntity != null) {
              successCount++;
            } else {
              failCount++;
            }
          } else {
            AssetEntity? assetEntity = await PhotoManager.editor.saveVideo(File(cacheFile.path), title: item.item.fileName ?? '');
            if (assetEntity != null) {
              successCount++;
            } else {
              failCount++;
            }
          }
        } else {
          successCount++;
        }
      } catch (e) {
        failCount++;
        debugPrint('保存文件失败: ${e.toString()}');
        showShortToast('保存文件失败: ${e.toString()}');
      }
    }
    if (failCount > 0) {
      if (successCount > 0) {
        showShortToast('成功保存$successCount个，失败$failCount个');
      } else {
        showShortToast('保存失败');
      }
    } else {
      showShortToast('保存成功');
    }
  }

  /// 保存文件到 iOS 设备
  /// 支持将媒体文件保存到相册，非媒体文件通过系统分享功能处理
  Future<void> _saveFileToIOS() async {
    var res = await requestMyPhotosPermission(androidPermission: Permission.manageExternalStorage);
    if (!res) return;
    try {
      final (successCount, failCount) = await _processSaveFiles();
      if (failCount > 0) {
        if (successCount > 0) {
          showShortToast('成功保存$successCount个，失败$failCount个');
        } else {
          showShortToast('保存失败');
        }
      } else {
        showShortToast('保存成功');
      }
    } catch (e) {
      showShortToast('文件保存失败: ${e.toString()}');
    }
  }

  /// 处理文件保存逻辑
  /// 此处两种保存方式，第一种：保存到相册（图片，视频），第二种：使用系统弹窗的方式进行保存
  /// int、int 代表成功数量、失败数量
  Future<(int, int)> _processSaveFiles() async {
    int successCount = 0;
    int failCount = 0;
    final List<XFile> filesToShare = [];

    for (final item in dataList) {
      final cacheFile = await localFileLogic.getLocalFile(item.item.localPath ?? '');
      if (cacheFile == null) {
        showShortToast('${item.item.fileName} 文件已失效，请重新下载');
        continue;
      }

      if (_isMediaFile(item.item.fileName)) {

        // final result = await ImageGallerySaver.saveFile(cacheFile.path);
        // savedToGallery = result != null && result['isSuccess'] == true; 


        final extension = item.item.fileName?.split('.').lastOrNull;
        // 保存图片
        if (imageFormats.contains(extension)) {
          AssetEntity? assetEntity = await PhotoManager.editor.saveImageWithPath(cacheFile.path, title: item.item.fileName ?? '');
          if (assetEntity != null) {
            successCount++;
          } else {
            failCount++;
          }
        } else {
          AssetEntity? assetEntity = await PhotoManager.editor.saveVideo(File(cacheFile.path), title: item.item.fileName ?? '');
          if (assetEntity != null) {
            successCount++;
          } else {
            failCount++;
          }
        }
      } else {
        filesToShare.add(XFile(cacheFile.path));
      }
    }

    if (filesToShare.isNotEmpty) {
      final res = await Share.shareXFiles(
        filesToShare,
        subject: filesToShare.first.name,
      );
      if (res.status == ShareResultStatus.success) {
        successCount++;
      } else {
        failCount++;
      }
    }

    return (successCount, failCount);
  }

}

class IoDataResoult {
  FileIoDataRM item;
  bool isSelected;

  IoDataResoult(this.item, {this.isSelected = false});
}
// 定义图像和视频的后缀集合
final List<String> imageFormats = ['jpg', 'jpeg', 'png', 'gif'];
final List<String> videoFormats = ['mp4', 'mov', 'mkv'];

extension CheckDiskFileType on Iterable<IoDataResoult>{
  bool canOption(FileOptionType option){
    if (length > 1){
      switch(option){
        case FileOptionType.detail:
        case FileOptionType.other:
          return false;
        case FileOptionType.save:

          // 先检查是否有任何项的 status != 3
          bool anyStatusNotThree = any((item) => item.item.isValid && item.item.status != 3);
          if (anyStatusNotThree) return false;

          bool allDownloadSuccess = every((item) => item.item.isValid && item.item.status == 3);
          if (!allDownloadSuccess) return false;

          bool allImageOrVideo = every((item) {
            String extension = item.item.fileName?.split('.').last.toLowerCase() ?? '';
            return imageFormats.contains(extension) || videoFormats.contains(extension);
          });

          // 检查文件是否都属于其他格式
          bool allOtherFormats = every((item) {
            String extension = item.item.fileName?.split('.').last.toLowerCase() ?? '';
            return !imageFormats.contains(extension) && !videoFormats.contains(extension);
          });

          // 满足其中一个条件返回 true，否则返回 false
          return allImageOrVideo || allOtherFormats;
        case FileOptionType.share:
          bool allDownloadSuccess = every((item) => item.item.isValid && item.item.status == 3);
          if (!allDownloadSuccess) return false;
          return true;
        case FileOptionType.delete:
          bool allDownloadSuccess = every((item) => item.item.isValid && (item.item.status == 3 || item.item.status == 2 || item.item.status == 5));
          if (!allDownloadSuccess) return false;
          return true;
        default:
          return true;
      }
    }else if (isEmpty){
      return false;
    }else{
      switch(option){
        case FileOptionType.detail:
          return true;
        case FileOptionType.save:

          // 先检查是否有任何项的 status != 3
          bool anyStatusNotThree = any((item) => item.item.isValid && item.item.status != 3);
          if (anyStatusNotThree) return false;

          bool allDownloadSuccess = every((item) => item.item.isValid && item.item.status == 3);
          if (!allDownloadSuccess) return false;

          bool allImageOrVideo = every((item) {
            String extension = item.item.fileName?.split('.').last.toLowerCase() ?? '';
            return imageFormats.contains(extension) || videoFormats.contains(extension);
          });

          // 检查文件是否都属于其他格式
          bool allOtherFormats = every((item) {
            String extension = item.item.fileName?.split('.').last.toLowerCase() ?? '';
            return !imageFormats.contains(extension) && !videoFormats.contains(extension);
          });

          // 满足其中一个条件返回 true，否则返回 false
          return allImageOrVideo || allOtherFormats;
        case FileOptionType.share:
        case FileOptionType.other:
          bool allDownloadSuccess = every((item) => item.item.isValid && item.item.status == 3);
          if (!allDownloadSuccess) return false;
          return true;
        case FileOptionType.delete:
          bool allDownloadSuccess = every((item) => item.item.isValid && (item.item.status == 3 || item.item.status == 2 || item.item.status == 5));
          if (!allDownloadSuccess) return false;
          return true;
        default:
          return true;
      }
    }
  }
}