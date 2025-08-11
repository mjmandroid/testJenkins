import 'dart:io';

import 'package:desk_cloud/alert/command_target_sheet.dart';
import 'package:desk_cloud/alert/file_info_sheet.dart';
import 'package:desk_cloud/alert/file_share_sheet.dart';
import 'package:desk_cloud/alert/go_to_see_dialog.dart';
import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/alert/normal_input_sheet.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/user/local_notifications_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';

class FileOptionContainer extends StatefulWidget {
  final Widget child;
  final Function(FileOptionController controller)? onCreate;
  const FileOptionContainer({super.key, required this.child,this.onCreate});

  @override
  State<FileOptionContainer> createState() => _FileOptionContainerState();
}

class _FileOptionContainerState extends State<FileOptionContainer> with TickerProviderStateMixin{
  final logic = FileOptionController._();
  @override
  void initState() {
    super.initState();
    logic.provider = this;
    logic.addListener(_listener);
    logic.setMode(FileOptionMode.cloud);
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
                  height: logic._bottomHeight,
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
                            crossAxisCount: logic._mode!.count,
                            mainAxisSpacing: 10.w,
                            itemBuilder: (context,index){
                              var canClick = logic.dataList.canOption(logic._typeList[index]);
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

typedef FileTotalSelectedCallback = Function(FileOptionController controller,bool hasTotal);
typedef FileClickCallback = Function(FileOptionType type,List<DiskFileEntity> fileList);

class FileOptionController extends ChangeNotifier {
  FileOptionController._();
  AnimationController? _animaC;
  TickerProvider? provider;
  Animation<double>? _topAnima;
  Animation<double>? _bottomAnima;
  var _totalSelected = false;
  FileTotalSelectedCallback? _onTotalSelected;
  FileClickCallback? _onClick;
  FileOptionMode? _mode;
  Rx? _needRefreshRx;
  final _typeList = <FileOptionType>[].obs;
  double _bottomHeight = .0;
  var showing = false.obs;
  final dataList = <DiskFileEntity>[];

  // bool get showing => _showing;
  bool get totalSelected => _totalSelected;
  set totalSelected(bool value){
    _totalSelected = value;
    if (hasListeners){
      notifyListeners();
    }
  }

  setMode(FileOptionMode mode) {
    if (_mode == mode) return;
    showing.value = false;
    _mode = mode;
    _typeList.clear();
    _animaC?.reset();
    _animaC?.dispose();
    _animaC = AnimationController(duration: 0.18.seconds, vsync: provider!);
    switch (mode) {
      case FileOptionMode.cloud:
        _typeList.addAll([
          FileOptionType.download,
          FileOptionType.share,
          FileOptionType.unzip,
          FileOptionType.rename,
          FileOptionType.delete,
          FileOptionType.move,
          FileOptionType.detail
        ]);
        _topAnima = Tween<double>(begin: -(safeAreaTop + 50),end: 0).animate(CurvedAnimation(parent: _animaC!, curve: Curves.easeInOut));
        // _bottomAnima = Tween<double>(begin: -(safeAreaBottom + 150.w),end: 0).animate(CurvedAnimation(parent: _animaC!, curve: Curves.easeInOut));
        _bottomAnima = Tween<double>(begin: -(safeAreaBottom + 160.w),end: 0).animate(CurvedAnimation(parent: _animaC!, curve: Curves.easeInOut));
        _bottomHeight = safeAreaBottom + 160.w;
        break;
      case FileOptionMode.local:
        _typeList.addAll([
          FileOptionType.save,
          FileOptionType.share,
          FileOptionType.delete,
          FileOptionType.detail
        ]);
        _topAnima = Tween<double>(begin: -(safeAreaTop + 50),end: 0).animate(_animaC!);
        _bottomAnima = Tween<double>(begin: -(safeAreaBottom + 93.w),end: 0).animate(_animaC!);
        _bottomHeight = safeAreaBottom + 93.w;
        break;
      case FileOptionMode.recycle:
        _typeList.addAll([
          FileOptionType.restore,
          FileOptionType.delete
        ]);
        _bottomAnima = Tween<double>(begin: -(safeAreaBottom + 93.w),end: 0).animate(_animaC!);
        _bottomHeight = safeAreaBottom + 93.w;
        break;
    }
    if (hasListeners){
      notifyListeners();
    }
  }

  show(Iterable<DiskFileEntity>? list) {
    dataList.clear();
    dataList.addAll(list ?? []);
    if (hasListeners){
      notifyListeners();
    }
    if (dataList.isEmpty){
      hidden();
      return;
    }
    if (!showing.value) {
      _animaC?.forward();
      showing.value = true;
    }
  }

  hidden() {
    _animaC?.reverse();
    showing.value = false;
    for (var value in dataList) {
      value.selected = null;
    }
    _onTotalSelected = null;
    _onClick = null;
    _needRefreshRx?.refresh();
    _needRefreshRx = null;
    _totalSelected = false;
  }

  addSelectedCallback(FileTotalSelectedCallback? callback) {
    _onTotalSelected = callback;
  }

  addClickCallback(FileClickCallback? callback) {
    _onClick = callback;
  }

  addNeedRefreshRx(Rx? rx){
    _needRefreshRx = rx;
  }

  handlerFile(FileOptionType type)async{
    switch(type){
      case FileOptionType.detail:
        showFileInfoSheet(dataList.firstOrNull?.id);
        break;
      case FileOptionType.share:
        await showFileShareSheet(dataList);
        // user.diskCodeCreate(control.dataList, day: '10');
        // hidden();
        break;
      case FileOptionType.delete:
        var result = await showNormalDialog(title: '提醒',message: '确定要删除选中内容吗？');
        if (result != true) return;
        var r = await user.deleteFile(dataList);
        if (r != true) return;

        tabParentLogic.refreshFileHome();

        _onClick?.call(type,List.from(dataList));
        
        hidden();
        break;
      case FileOptionType.download:

        if (Platform.isAndroid) {
          // 请求存储权限
          var storagePermission = await requestMyPhotosPermission(androidPermission: Permission.manageExternalStorage, title: '存储权限', message: '存储权限未开启，允许访问所有相册可以享受更好的上传、下载服务，请在设置中开启');
          if (!storagePermission) return;
        }
        
        // 显示下载通知
        var res = await localNotificationsLogic.showDownloadNotification();
        if (res == null) {
          return;
        } 
        
        showLoading();
        var donwloadCount = 0;
        for (var element in dataList) {
          if (element.isDir == 1) {
            donwloadCount += element.fileCount ?? 0;
          } else {
            donwloadCount++;
          }
        }
        if (donwloadCount <= 0) {
          showShortToast('不支持空文件下载');
          dismissLoading();
          return;
        }
        List<int> ids = [];
        List<Future<void>> futures = [];

        for (var item in dataList) {
          if (item.isDir == 1) {
            futures.add(() async {
              try {
                var base = await ApiNet.request<List<DiskFileEntity>>(Api.getDirFiles, data: {
                  'dir_ids': item.id
                });
                base.data?.forEach((dirFileItem) {
                  ids.add(dirFileItem.id ?? 0);
                });
              } catch (e) {
                showShortToast(e.toString());
              }
            }());
          } else {
            ids.add(item.id ?? 0);
          }
        }

        // 等待所有异步操作完成
        await Future.wait(futures);
        var showGoToSee = false;
        // // 下载所有文件
        // await Future.wait(ids.map((id) => oss.download(id))).then((value) {
        //   if (value.any((result) => result == true)) {
        //     showGoToSee = true;
        //   }
        // });
        // 顺序下载所有文件
        for (final id in ids) {
          final result = await oss.download(id);
          if (result == true) {
            showGoToSee = true;
          }
        }
        dismissLoading();
        hidden();
        if (showGoToSee) {
          showGoToSeeDialog(type: 0);
        }
        break;
      case FileOptionType.move:
        var dir = await showCommandTargetSheet(isMove: true, dataList: dataList);
        if (dir == null) return;
        var r = await user.diskMove(dataList, targetDirId: dir.id ?? 0);
        if (r != true) return;

        // if (Get.isRegistered<FileHomeSubLogic>(tag: 'FileHomeSubLogic_')) {
        //   FileHomeSubLogic fileHomeSubLogic = Get.find<FileHomeSubLogic>(tag: 'FileHomeSubLogic_');
        //   fileHomeSubLogic.requestForDataList();
        // }
        // if (Get.isRegistered<FileHomeSubLogic>(tag: 'FileHomeSubLogic_1')) {
        //   FileHomeSubLogic fileHomeSubLogic1 = Get.find<FileHomeSubLogic>(tag: 'FileHomeSubLogic_1');
        //   fileHomeSubLogic1.requestForDataList();
        // }
        // if (Get.isRegistered<FileHomeSubLogic>(tag: 'FileHomeSubLogic_2')) {
        //   FileHomeSubLogic fileHomeSubLogic2 = Get.find<FileHomeSubLogic>(tag: 'FileHomeSubLogic_2');       
        //   fileHomeSubLogic2.requestForDataList();
        // }
        _onClick?.call(type,List.from(dataList));
        tabParentLogic.refreshFileHome();

        hidden();
        break;
      case FileOptionType.rename:
        var input = await showNormalInputSheet(title: '重命名',hint: '请输入文件(夹)名');
        if (input?.isNotEmpty != true) {
          return;
        }
        var r = await user.renameFile(dataList.first,name: input);
        if (r != true) return;
        hidden();
        dataList.first.title = input;
        break;
      case FileOptionType.save:
        break;
      case FileOptionType.unzip:
        oss.checkFile(dataList);
        hidden();
        break;
      case FileOptionType.restore:
        break;
      case FileOptionType.other:
        break;
    }
    _onClick?.call(type,List.from(dataList));
  }
}