import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/key_board_observer.dart';
import 'package:desk_cloud/utils/key_board_utils.dart';
import 'package:flutter/material.dart';

Future<String?> showNormalInputSheet({String? title,String? hint}) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _NormalInputView(title: title,hint: hint,);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}

class _NormalInputView extends StatefulWidget {
  final String? title;
  final String? hint;
  const _NormalInputView({this.title,this.hint});

  @override
  State<_NormalInputView> createState() => _NormalInputViewState();
}

class _NormalInputViewState extends State<_NormalInputView> {
  final textC = TextEditingController();
  final focus = FocusNode();

  // var _height = 0.0;
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(KeyBoardObserver.instance);
  //   KeyBoardObserver.instance.addListener(keyBorderListener);
  //   0.3.delay().then((value) => focus.requestFocus());
  // }
  // keyBorderListener(isKeyboardShow) {
  //   print('----$isKeyboardShow--${KeyBoardObserver.instance.keyboardHeight}');
  //   if (isKeyboardShow){
  //     _height = KeyBoardObserver.instance.keyboardHeight;
  //     setState(() {
  //     });
  //   }
  // }

  final KeyboardUtils _keyboardUtils = KeyboardUtils();
  double _keyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    0.3.delay().then((value) => focus.requestFocus());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在组件初始化时添加监听
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取键盘高度并监听变化
      _keyboardUtils.updateKeyboardHeight(context, (double height) {
        setState(() {
          _keyboardHeight = height;
        });
      });
    });
  }  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 812.h,
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 375.w,
            decoration: BoxDecoration(
              color: kF8(),
              borderRadius: BorderRadius.vertical(top: 20.radius)
            ),
            margin: EdgeInsets.only(bottom: _keyboardHeight <= 0 ? (_keyboardHeight + safeAreaBottom) : _keyboardHeight),
            padding: EdgeInsets.only(top: 20.w,left: 24.w,right: 24.w,bottom: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(widget.title ?? '文件重命名',color: k3(),size: 18.sp,),
                spaceH(20),
                Container(
                  width: 327.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: kWhite(),
                    borderRadius: 14.borderRadius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.center,
                  child: MyTextField(
                    controller: textC,
                    focusNode: focus,
                    hintText: widget.hint,
                    onSubmitted: (v){
                      pop(context: context,args: textC.text.trim());
                    },
                  ),
                ),
                spaceH(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      width: 158.w,
                      height: 44.w,
                      onTap: (){
                        pop(context: context);
                      },
                      decoration: BoxDecoration(
                        color: kBlack(0.04),
                        borderRadius: 12.borderRadius
                      ),
                      alignment: Alignment.center,
                      child: MyText('取消',color: k3(),size: 15.sp,),
                    ),
                    MyButton(
                      width: 158.w,
                      height: 44.w,
                      onTap: (){
                        if (textC.text.trim().isNotEmpty != true) {
                          showShortToast(widget.hint ?? '请输入内容');
                          return;
                        }
                        pop(context: context,args: textC.text.trim());
                      },
                      decoration: BoxDecoration(
                          color: k4A83FF(),
                          borderRadius: 12.borderRadius
                      ),
                      alignment: Alignment.center,
                      child: MyText('确定',color: kWhite(),size: 15.sp,),
                    )
                  ],
                )
              ],
            ),
          )

        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    KeyBoardObserver.instance.listener = null;
  }
}
