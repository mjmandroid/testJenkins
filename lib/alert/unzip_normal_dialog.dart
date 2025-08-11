import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future showUnzipNormalDialog(){
  return showDialog(context: globalContext, builder: (context){
    return const UnzipNormalDialogView();
  },barrierDismissible: false);
}

class UnzipNormalDialogView extends StatefulWidget {
  const UnzipNormalDialogView({super.key});

  @override
  State<UnzipNormalDialogView> createState() => _UnzipNormalDialogViewState();
}

class _UnzipNormalDialogViewState extends BaseXState<UnzipNormalDialogLogic, UnzipNormalDialogView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
            color: kWhite(),
            borderRadius: 20.borderRadius
        ),
        padding: EdgeInsets.only(left: 24.w,right: 24.w,top: 24.w,bottom: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText('文件解压',color: k3(),size: 18.sp,textAlign: TextAlign.center,),
            Obx(() => Padding(
              padding: EdgeInsets.only(top: 15.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 20.w,  // 最小高度
                  maxHeight: 200.w,  // 最大高度，超出后可滚动
                ),
                child: SingleChildScrollView(
                  child: MyText(
                    '${logic.title}文件解压成功，是否查看？',
                    color: k3(),
                    size: 12.sp,
                    lineHeight: 1.3,
                    textAlign: TextAlign.center,
                    weight: FontWeight.normal
                  ),
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: 30.w),
              child: SizedBox(
                height: 44.w,
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context,constrains){
                          return MyButton(
                            width: constrains.maxWidth,
                            height: constrains.maxHeight,
                            decoration: BoxDecoration(
                                color: kBlack(0.04),
                                borderRadius: 12.borderRadius
                            ),
                            child: MyText('稍后查看',color: k3(),size: 15.sp,),
                            onTap: (){
                              ioLogic.isShowUnzipNormalDialog = false;
                              pop(context: context,args: false);
                            },
                          );
                        },
                      ),
                    ),
                    spaceW(8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context,constrains){
                          return MyButton(
                            width: constrains.maxWidth,
                            height: constrains.maxHeight,
                            decoration: BoxDecoration(
                              color: k4A83FF(),
                              borderRadius: 12.borderRadius
                            ),
                            child: MyText(
                              '立即查看',
                              color: kWhite(),
                              size: 15.sp
                            ),
                            onTap: (){
                              ioLogic.isShowUnzipNormalDialog = false;
                              pop(context: context,args: true);
                              push(MyRouter.fileListNormal,args: FileNormalSearchEntity(
                                DiskFileEntity()
                                ..id = logic.relationDirId.value
                                ..title = logic.title.value,
                                searchMap: {})
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  UnzipNormalDialogLogic get initController => UnzipNormalDialogLogic();
}

class UnzipNormalDialogLogic extends BaseLogic {

  var title = ''.obs;

  var relationDirId = 0.obs;

  setData(String title, int relationDirId){
    this.title.value = title;
    this.relationDirId.value = relationDirId;
  }  

}

UnzipNormalDialogLogic get unzipNormalDialogLogic {
  if (Get.isRegistered<UnzipNormalDialogLogic>()){
    return Get.find<UnzipNormalDialogLogic>();
  }
  return Get.put(UnzipNormalDialogLogic());
}