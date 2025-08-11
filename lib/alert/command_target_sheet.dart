import 'package:desk_cloud/alert/normal_input_sheet.dart';
import 'package:desk_cloud/entity/disk_dir_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

/// 文件夹列表
Future<dynamic> showCommandTargetSheet({ bool isMove = false, List<DiskFileEntity>? dataList}) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _CommandTargetView(isMove: isMove, dataList: dataList);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}

class _CommandTargetView extends StatefulWidget {
  final bool isMove;
  final List<DiskFileEntity>? dataList;
  const _CommandTargetView({ required this.isMove, required this.dataList});

  @override
  State<_CommandTargetView> createState() => _CommandTargetViewState();
}

class _CommandTargetViewState extends BaseXState<_CommandTargetLogic, _CommandTargetView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h - 60.w,
      decoration: BoxDecoration(
          color: kF8(),
          borderRadius: BorderRadius.vertical(top: 20.radius)
      ),
      padding: EdgeInsets.only(top: 16.w, bottom: 16.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: 343.w,
              height: 28.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(() {
                    if (widget.isMove) {
                      return MyText('移动到“${logic.currentDir.value?.title ?? ''}”', size: 15.sp, color: k3(),);
                    }
                    return MyText(logic.currentDir.value?.title ?? '', size: 15.sp, color: k3(),);
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(() {
                      if (logic.gradeList.length < 2) return Container();
                      return GestureDetector(
                          onTap: () {
                            if (logic.gradeList.length > 1) {
                              //返回上一级，则清除当前层级的所有选中状态
                              logic.currentDir.value?.subs?.forEach((element) {
                                element.selected = null;
                              });
                              logic.gradeList.removeLast();
                              logic.currentDir.value = logic.gradeList.lastOrNull;
                            }
                          },
                          child: Image.asset(R.assetsNavBack, width: 24.w, height: 24.w,)
                      );
                    }),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        pop(context: context);
                      },
                      child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isMove)
            _selectedDataBar(),
          Expanded(
            child: Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ListView.builder(
                  itemBuilder: (context, index) {
                    var item = logic.currentDir.value?.subs?[index];
                    return GestureDetector(
                      onTap: () {
                        logic.currentDir.value = item;
                        logic.gradeList.add(item!);
                        if (logic.currentDir.value?.subs?.isNotEmpty != true) {
                          logic.requestForDirList(item);
                        }
                      },
                      child: Container(
                        height: 60.w,
                        color: kF8(),
                        child: Row(
                          children: [
                            Image.asset(R.assetsTypeDir, width: 32.w, height: 32.w,),
                            spaceW(16),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(item?.title ?? '', color: k3(), size: 13.sp,),
                                  spaceH(5),
                                  MyText(item?.createtime ?? '', color: k9(), size: 10.sp,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: logic.currentDir.value?.subs?.length ?? 0,
                ),
              );
            }),
          ),
          Container(
            width: 343.w,
            height: 40.w,
            color: kF8(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                  width: 95.w,
                  height: 20.w,
                  decoration: const BoxDecoration(),
                  onTap: (){
                    logic.createDir();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(R.assetsAddDir,width: 20.w,height: 20.w,),
                      MyText('新建文件夹',color: k3(),size: 13.sp,)
                    ],
                  ),
                ),
                MyButton(
                  width: 95.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: k4A83FF(),
                    borderRadius: 8.borderRadius
                  ),
                  child: MyText('移动到此',color: kWhite(),size: 12.sp,),
                  onTap: (){
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

  Widget _selectedDataBar() {
    List<DiskFileEntity> arr = widget.dataList!.take(5).toList().reversed.toList();
    return Container(
      height: 48.w,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kE(),
            width: .5
          )
        )
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none, // 允许溢出，防止图标被裁剪
            children: List.generate(arr.length, (index) {
              if (index == arr.length - 1) {
                return Container(
                  width: 28.w,
                  height: 28.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kWhite(),
                    borderRadius: 6.borderRadius
                  ),
                  child: Image.asset(
                    arr[index].fileType?.fileTypeIcon ?? '',
                    width: 24.w,
                    height: 24.w,
                  ),
                );
              } else {
                return Positioned(
                  left: ((arr.length - 1 - index) * 12).w,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kWhite(),
                      borderRadius: 6.borderRadius
                    ),
                    child: Image.asset(
                      arr[index].fileType?.fileTypeIcon ?? '',
                      width: 24.w,
                      height: 24.w,
                    ),
                  )
                );
              }
            }),
          ),
          spaceW((arr.length - 1) * 12 + 10),
          MyText(
            '已选择${widget.dataList?.length}个文件',
            size: 13.sp,
            weight: FontWeight.normal,
            color: kBlack(),
          )
        ],
      ),
    );
  }

  @override
  _CommandTargetLogic get initController => _CommandTargetLogic(isMove: widget.isMove, dataList: widget.dataList ?? []);
}

class _CommandTargetLogic extends BaseLogic {
  final currentDir = Rxn<DiskDirEntity>();
  final gradeList = <DiskDirEntity>[].obs;
  final bool isMove;
  final List<DiskFileEntity> dataList;
  _CommandTargetLogic({ required this.isMove, required this.dataList});

  @override
  void onInit() {
    super.onInit();
    requestForDirList();
  }

  requestForDirList([DiskDirEntity? dir]) async {
    try {
      var excIds = '';
      for (var i = 0; i < dataList.length; i++) {
        if (dataList[i].isDir == 1) {
          var item = dataList[i];
          if (i > 0) {
            excIds += ',';
          }
          excIds += '${item.id}';
        }
      }
      var base = await ApiNet.request<List<DiskDirEntity>>(Api.dirList, data: {'dir_id': dir?.id ?? 0, 'exc_id': excIds});
      if (dir == null) {
        currentDir.value = DiskDirEntity()
          ..title = isMove ? '根目录' : '请选择'
          ..subs = base.data;
        gradeList.add(currentDir.value!);
      }else{
        dir.subs = base.data;
        currentDir.refresh();
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  createDir()async{
    var r = await showNormalInputSheet(title: '新建文件夹',hint: '请输入文件名');
    if (r == null) return;
    if (r.isEmpty) return;
    try{
      showLoading();
      var base = await ApiNet.request(Api.addDir,data: {
        'pid': currentDir.value?.id ?? 0,
        'name': r
      });
      if (base.code == 200) {
        showShortToast('新建成功');
      }
      dismissLoading();
      currentDir.value?.subs ??= [];
      currentDir.value?.subs?.add(
          DiskDirEntity()
              ..title = r
              ..id = int.tryParse(base.data?['dir_id']) ?? 0
              ..createtime = DateUtil.formatDate(DateTime.now(),format: 'yyyy-MM-dd HH:mm:ss')
      );
      currentDir.refresh();
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
    }
  }

  submit(){
    var dir = currentDir.value;
    if (dir == null){
      showShortToast('请选择文件夹');
      return;
    }
    pop(context: context,args: dir);
  }
}
