import 'package:desk_cloud/alert/command_add_edit_sheet.dart';
import 'package:desk_cloud/entity/code_list_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCommandSheet(List<DiskFileEntity> files) {
  return showModalBottomSheet(
      context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _CommandSheetView(files: files);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.transparent);
}

class _CommandSheetView extends StatefulWidget {

  final List<DiskFileEntity> files;
  const _CommandSheetView({ required this.files });
  @override
  State<_CommandSheetView> createState() => _CommandSheetViewState();
}

class _CommandSheetViewState extends BaseXState<_CommandSheetLogic, _CommandSheetView> {

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
            color: kWhite()
          ),
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: maxHeight,
          ),
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
                      MyButton(
                        title: '编辑',
                        style: TextStyle(
                          color: k4A83FF(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.transparent
                        ),
                        onTap: () async {
                          var r = await showCommandAddEditSheet(widget.files, logic.codeListEntity);
                          if (r == null || !r) return;
                          logic.getCodeList();
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() => Column(
                      children: logic.codeListEntity.asMap().keys.map((index) {
                        var item = logic.codeListEntity[index];
                        return MyInkWell(
                          onTap: () {
                            logic.selectedCodeIndex.value = index;
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  item.code ?? '',
                                  size: 13.sp,
                                ),
                                Image.asset(
                                  logic.selectedCodeIndex.value == index ?  R.assetsCheckRoundY : R.assetsCheckRoundN,
                                  width: 14.w,
                                  height: 14.w,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
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
                            pop(context: context, args: false);
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
                          onTap: () {
                            pop(args: logic.codeListEntity[logic.selectedCodeIndex.value].code);
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
  
  @override
  _CommandSheetLogic get initController => _CommandSheetLogic(widget.files);
}

class _CommandSheetLogic extends BaseLogic {

  List<DiskFileEntity> files;
  _CommandSheetLogic(this.files);
  var codeListEntity = <CodeListEntity>[].obs;
  var selectedCodeIndex = 0.obs;

  @override
  onInit() {
    super.onInit();
    getCodeList();
  }

  getCodeList() async {
    codeListEntity.clear();
    var ids = '';
    for (var i = 0; i < files.length; i++) {
      var item = files[i];
      if (i > 0) {
        ids += ',';
      }
      ids += '${item.id}';
    }
    try {
      var base = await ApiNet.request(Api.getCodeList, data: {
        'ids': ids
      });
      codeListEntity.addAll(jsonConvert.convertListNotNull<CodeListEntity>(base.data ?? []) ?? []);
      if (selectedCodeIndex.value + 1 > codeListEntity.length) {
        selectedCodeIndex.value = 0;
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }

}