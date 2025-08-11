import 'dart:async';

import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future showGoToSeeDialog({ int type = 0, bool dismissible = true}){
  return showDialog(context: globalContext, builder: (context){
    return _GoToSeeDialogView(type: type);
  },
  barrierDismissible: dismissible,
  barrierColor: Colors.transparent);
}

class _GoToSeeDialogView extends StatefulWidget {
  /// 状态：0下载，1上传
  final int type;
  const _GoToSeeDialogView({ required this.type});

  @override
  State<_GoToSeeDialogView> createState() => _GoToSeeDialogViewState();
}

class _GoToSeeDialogViewState extends State<_GoToSeeDialogView> {

  bool isPopPage = false;
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted && Navigator.of(context).canPop() && !isPopPage) {
        pop(); 
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: Container(
          height: 32.w,
          padding: EdgeInsets.only(top: 4.w, right: 4.w, bottom: 4.w, left: 13.w),
          decoration: BoxDecoration(
            color: kBlack(),
            borderRadius: 10.borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Center(
                child: MyText(
                  widget.type == 0 ? '已添加至下载列表' : '已添加至上传列表',
                  size: 12.sp,
                  weight: FontWeight.normal,
                  color: kWhite(),
                ),
              )),
              spaceW(8),
              MyButton(
                title: '去看看',
                width: 48.w,
                height: 24.w,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal
                ),
                decoration: BoxDecoration(
                  color: k4A83FF(),
                  borderRadius: 8.borderRadius
                ),
                onTap: () {
                  if (!isPopPage) {
                    pop();
                  }
                  isPopPage = true;
                  tabParentLogic.jumpToPage(2);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ioLogic.pageC.animateToPage(
                      widget.type,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                    );
                  });
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  
}