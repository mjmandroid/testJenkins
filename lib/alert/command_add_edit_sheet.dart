import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/entity/code_list_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/share_data_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/key_board_utils.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCommandAddEditSheet(List<DiskFileEntity> files, List<CodeListEntity> codes) {
  return showModalBottomSheet(
      context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _CommandAddEditSheetView(files: files, codes: codes);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.transparent);
}

class _CommandAddEditSheetView extends StatefulWidget {

  final List<DiskFileEntity> files;
  final List<CodeListEntity> codes;
  const _CommandAddEditSheetView({ required this.files, required this.codes });
  @override
  State<_CommandAddEditSheetView> createState() => _CommandAddEditSheetViewState();
}

class _CommandAddEditSheetViewState extends BaseXState<_CommandAddEditSheetLogic, _CommandAddEditSheetView> {

  final textC = TextEditingController();
  final focus = FocusNode();
  final KeyboardUtils _keyboardUtils = KeyboardUtils();
  double _keyboardHeight = 0.0;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // 获取屏幕的最大高度
        double maxHeight = MediaQuery.of(context).size.height * 0.9; // 最大高度为屏幕的 90%
        double minHeight = 444.w + safeAreaBottom;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: 20.radius),
            color: kF8()
          ),
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: maxHeight,
          ),
          margin: EdgeInsets.only(bottom: _keyboardHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  height: 69.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        '口令',
                        size: 18.sp,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          Column(
                            children: widget.codes.asMap().keys.map((index) {
                              var codeItem = widget.codes[index];
                              return _commandItem(
                                      child: MyText(
                                        '${codeItem.code}',
                                        size: 13.sp,
                                        color: k4A83FF(),
                                      ),
                                      index: index
                                    );
                            }).toList(),
                          ),
                          Obx(() => logic.checkAddCommand.value == false ? Row(
                            children: [
                              MyButton(
                                onTap: () {
                                  logic.checkAddCommand.value = true;
                                },
                                width: 293.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: kWhite(),
                                  borderRadius: 14.borderRadius,
                                  border: Border.all(
                                    width: .5.w,
                                    color: k9()
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      R.assetsIcCommandAdd,
                                      width: 16.w,
                                      height: 16.w,
                                    ),
                                    spaceW(8),
                                    MyText(
                                      '添加',
                                      size: 15.sp,
                                      color: kBlack(),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ) : _commandItem(child: MyTextField(
                            align: TextAlign.center,
                            hintText: '输入口令',
                            controller: textC,
                          ),
                          isInput: true,
                          index: -1))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 69.w + safeAreaBottom,
                  width: 376.w,
                  padding: EdgeInsets.only(bottom: safeAreaBottom, left: 24.w, right: 24.w),
                  child: SizedBox(
                    height: 69.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          title: '取消',
                          height: 44.w,
                          width: 157.w,
                          style: TextStyle(
                            color: kBlack(),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold
                          ),
                          decoration: BoxDecoration(
                            color: kBlack(.04),
                            borderRadius: 12.borderRadius
                          ),
                          onTap: () {
                            pop(context: context);
                          },
                        ),
                        MyButton(
                          title: '确认',
                          height: 44.w,
                          width: 157.w,
                          style: TextStyle(
                            color: kWhite(),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold
                          ),
                          onTap: () async {
                            var r = await logic.submitCodeCreate(codeText: textC.text);
                            if (!r) return;
                            .5.delay().then((value) => pop(args: true));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          )
        );
      },
    );
  }

  Widget _commandItem({required Widget child, required int index, bool isInput = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 298.w,
          height: 50.h,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: kWhite(),
            borderRadius: 14.borderRadius
          ),
          child: child,
        ),
        MyButton(
          child: Image.asset(
            R.assetsIcDel,
            width: 16.w,
            height: 16.w,
          ),
          onTap: () async {
            if (isInput) {
              logic.checkAddCommand.value = false;
              textC.text = '';
              return;
            }
            var r = await showNormalDialog(title: '删除确认', message: '确定删除此口令吗？');
            if (r == null || r == false) return;
            logic.delCode(index: index);
          },
        )
      ],
    );
  }
  
  @override
  _CommandAddEditSheetLogic get initController => _CommandAddEditSheetLogic(widget.files, widget.codes);
}

class _CommandAddEditSheetLogic extends BaseLogic {

  final List<DiskFileEntity> files;
  final List<CodeListEntity> codes;
  _CommandAddEditSheetLogic(this.files, this.codes);
  var checkAddCommand = false.obs;

  delCode({required int index}) async {
    try {
      var base = await ApiNet.request(Api.delCode, data: {'code_id': '${codes[index].id??0.toInt()}'});
      if (base.code == 200) {
        codes.removeAt(index);
        pop(args: true);
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  submitCodeCreate({required String codeText}) async {
    if (codeText.isEmpty) {
      showShortToast('请输入口令');
      return false;
    }
    ShareDataEntity? shareDataEntity = await user.diskCodeCreate(files, day: '0',codes: codeText, codeType: '1');
    if (shareDataEntity == null) return false;

    return true;
  }

}