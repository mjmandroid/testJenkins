import 'dart:async';

import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future showUnzipProgressDialog({required String taskId}){
  return showDialog(context: globalContext, builder: (context){
    return _UnzipProgressDialogView(taskId: taskId);
  },barrierDismissible: false);
}

class _UnzipProgressDialogView extends StatefulWidget {
  
  final String taskId;
  const _UnzipProgressDialogView({required this.taskId});

  @override
  State<_UnzipProgressDialogView> createState() => _UnzipProgressDialogViewState();
}

class _UnzipProgressDialogViewState extends BaseXState<_UnzipProgressDialogLogic, _UnzipProgressDialogView> {
  
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
        child: Obx(() => TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 100000),
          curve: Curves.easeInOut,
          tween: Tween<double>(
            begin: 0,
            end: (ioLogic.unzipProgressMap[widget.taskId] ?? 0) / 100,
          ),
          builder: (context, value, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText('正在解压',color: k3(),size: 18.sp,textAlign: TextAlign.center,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    '正在解压，请稍候…',
                    size: 12.sp,
                    weight: FontWeight.normal,
                    color: k3(),
                  ),
                  MyText(
                    '完成${(value * 100).toInt()}%',
                    size: 10.sp,
                    weight: FontWeight.normal,
                    color: k6(),
                  )
                ],
              ),
              spaceH(8),
              ClipRRect(
                borderRadius: 3.borderRadius,
                child: SizedBox(
                  height: 5.w,
                  child: LinearProgressIndicator(
                    backgroundColor: kE(),
                    valueColor: AlwaysStoppedAnimation(
                        k4A83FF()
                    ),
                    value: value,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 28.w),
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
                              child: MyText('后台解压',color: kWhite(),size: 15.sp,),
                              onTap: (){
                                ioLogic.unzipIsPopPage = true;
                                pop(context: context,args: true);
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
        )),
      ),
    );
  }
  
  @override
  _UnzipProgressDialogLogic get initController => _UnzipProgressDialogLogic(taskId: widget.taskId);

}


class _UnzipProgressDialogLogic extends BaseLogic {
  final String taskId;
  _UnzipProgressDialogLogic({required this.taskId});

  @override
  onInit() {
    super.onInit();
    ioLogic.unzipIsPopPage = false;
    ioLogic.getTaskDetail(taskId);
  }
}