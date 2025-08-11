
import 'package:desk_cloud/alert/mobile_file/mobile_file_sheet.dart';
import 'package:desk_cloud/entity/mobile_file_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/check_view.dart';
import 'package:desk_cloud/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class MobileSubFileView extends StatefulWidget {
  final List<RegExp> regExpList;
  final int count;

  const MobileSubFileView(this.regExpList, this.count, {super.key});

  @override
  State<MobileSubFileView> createState() => _MobileSubFileViewState();
}

class _MobileSubFileViewState extends BaseXState<MobileSubFileLogic, MobileSubFileView> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (logic.dataList.isEmpty) {
      return const Center(child: EmptyView(title: '暂无数据'));
    }
    return Obx(() {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          var item = logic.dataList[index];
          return GestureDetector(
            onTap: () {
              item.selected = !item.selected;
              logic.dataList.refresh();
            },
            child: Container(
              height: 60.w,
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(item.fileExtension.fileIcon, width: 32.w, height: 32.w,),
                  spaceW(16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(item.name, color: k3(), size: 13.sp,maxLines: 1,overflow: TextOverflow.ellipsis,),
                        spaceH(5),
                        MyText(DateUtil.formatDate(item.time,format: 'yyyy-MM-dd HH:mm:ss'), color: k9(), size: 10.sp,)
                      ],
                    ),
                  ),
                  CheckView(size: 14.w, selected: item.selected,)
                ],
              ),
            ),
          );
        },
        itemCount: logic.dataList.length,
      );
    });
  }

  @override
  String? get tag => 'MobileSubFileLogic_${widget.count}';

  @override
  MobileSubFileLogic get initController => MobileSubFileLogic(widget.regExpList,widget.count);

  @override
  bool get wantKeepAlive => true;
}

class MobileSubFileLogic extends BaseLogic {
  final List<RegExp> regExpList;
  final int count;
  final dataList = <MobileFileEntity>[].obs;

  MobileSubFileLogic(this.regExpList,this.count);

  @override
  void onInit() async {
    super.onInit();
    if (count == 0){
      dataList.addAll(find<MobileFileLogic>()?.dataList ?? []);
    }else{
      dataList.addAll(find<MobileFileLogic>()?.dataList.where((p0){
        for (var reg in regExpList) {
          if (reg.hasMatch(p0.path)) {
            return true;
          }
        }
        return false;
      }) ?? []);
    }
  }
}
