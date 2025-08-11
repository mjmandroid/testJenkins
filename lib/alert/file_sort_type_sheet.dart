import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

enum FileSortType {
  normal('综合排序', ''),
  createTime('创建日期', 'createtime'),
  filename('文件名称', 'name'),
  fileSize('文件大小', 'size'),
  ;
  const FileSortType(this.name, this.value);

  final String name;
  final String value;
}

enum FileSortSubType {
  desc('降序', 'desc'),
  asc('升序', 'asc'),
  ;
  const FileSortSubType(this.name, this.value);

  final String name;
  final String value;
}

Future<dynamic> showFileSortTypeSheet({required FileSortType type, required FileSortSubType subType}) {
  return showModalBottomSheet(context: CustomNavigatorObserver().navigator!.context,
      builder: (context) {
        return _FileSortTypeView(type, subType);
      },
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true);
}


class _FileSortTypeView extends StatefulWidget {
  final FileSortType type;
  final FileSortSubType subType;

  const _FileSortTypeView(this.type, this.subType, {super.key});

  @override
  State<_FileSortTypeView> createState() => _FileSortTypeViewState();
}

class _FileSortTypeViewState extends BaseXState<_FileSortTypeLogic, _FileSortTypeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 363.w + safeAreaBottom,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: 20.radius),
          color: kWhite()
      ),
      padding: EdgeInsets.all(16.w),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                pop(context: context);
              },
              child: Image.asset(R.assetsDialogClose, width: 28.w, height: 28.w,),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText('排序设置', color: k3(), size: 18.sp,)
                  ],
                ),
                spaceH(15),
                ListView.separated(
                  itemBuilder: (context, index) {
                    final type = FileSortType.values[index];
                    return Obx(() {
                      final selected = type == logic.type.value;
                      return InkWell(
                        onTap: () {
                          if (logic.type.value == type) {
                            logic.subType.value = logic.subType.value == FileSortSubType.desc ? FileSortSubType.asc : FileSortSubType.desc;
                          } else {
                            logic.type.value = type;
                          }
                        },
                        child: Container(
                          width: 327.w,
                          height: 48.w,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    MyText('按${type.name}', color: selected ? k4A83FF() : k6(), size: 14.sp, weight: FontWeight.normal),
                                    spaceW(8),
                                    if (selected)
                                      Obx(() {
                                        return Transform.rotate(
                                          angle: logic.subType.value == FileSortSubType.desc ? math.pi : 0,
                                          child: Image.asset(R.assetsSortBlue, width: 10.w, height: 16.w,),
                                        );
                                      })
                                  ],
                                )
                              ),
                              if (selected)
                               MyText('${logic.subType.value.name}排序', color: k9(), size: 11.sp, weight: FontWeight.normal,)
                            ],
                          ),
                        ),
                      );
                    });
                  },
                  separatorBuilder: (context, index) {
                    return spaceH(5);
                  },
                  itemCount: FileSortType.values.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                ),
                MyButton(
                  width: 327.w,
                  height: 44.w,
                  margin: EdgeInsets.only(top: 20.w),
                  title: '确认',
                  onTap: (){
                    pop(context: context,args: [logic.type.value,logic.subType.value]);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  _FileSortTypeLogic get initController => _FileSortTypeLogic(widget.type, widget.subType);
}

class _FileSortTypeLogic extends BaseLogic {
  final type = Rx(FileSortType.normal);
  final subType = Rx(FileSortSubType.desc);

  _FileSortTypeLogic(FileSortType type, FileSortSubType subType) {
    this.type.value = type;
    this.subType.value = subType;
  }

}
