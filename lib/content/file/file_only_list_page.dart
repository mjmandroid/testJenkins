import 'package:desk_cloud/alert/file_sort_type_sheet.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/file/file_only_list_logic.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_list_refresh_view.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FileOnlyListPage extends StatefulWidget {
  final DiskFileType type;
  const FileOnlyListPage(this.type,{super.key});

  @override
  State<FileOnlyListPage> createState() => _FileOnlyListPageState();
}

class _FileOnlyListPageState extends BaseXState<FileOnlyListLogic,FileOnlyListPage> {
  @override
  Widget build(BuildContext context) {
    return FileOptionContainer(
      onCreate: (v){
        logic.optionC = v;
        v.setMode(FileOptionMode.cloud);
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(widget.type.name ?? ''),
          backgroundColor: kWhite(),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: kF8(),
        body: Column(
          children: [
            widget.type.type == 8 ? _vipBar() : const SizedBox(),
            InkWell(
              onTap: ()async{
                var r = await showFileSortTypeSheet(type: logic.sortType.value, subType: logic.subSortType.value);
                if (r == null) return;
                logic.sortType.value = r[0];
                logic.subSortType.value = r[1];
                logic.onRefresh();
              },
              child: Container(
                height: 50.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kWhite(),
                ),
                child: Row(
                  children: [
                    Obx(() {
                      return MyText(
                        '按${logic.sortType.value.name}', 
                        color: k6(), 
                        size: 14.sp,
                        weight: FontWeight.normal,
                      );
                    }),
                    spaceW(8),
                    Obx(() {
                      return Transform.rotate(
                        angle: logic.subSortType.value == FileSortSubType.desc ? math.pi : 0,
                        child: Image.asset(R.assetsFileSort, width: 10.w, height: 16.w,)
                      );
                    })
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                  // borderRadius: BorderRadius.vertical(top: 20.radius),
                  child: Container(
                    color: kWhite(),
                    child: Obx(() => FileListRefreshView(
                      controller: logic.controller,
                      onRefresh: logic.onRefresh,
                      onLoading: logic.onLoading,
                      rxFile: logic.diskFile,
                      onSelectedChange: (v){
                        // logic.optionC?.show(logic.diskFile.value.subs?.where((element) => element.selected == true));
                        // logic.optionC?.totalSelected = logic.diskFile.value.subsTotalSelected;
                        // logic.diskFile.refresh();
                        logic.selectedChange();
                      },
                      onNext: (v){
                        
                      },
                      emptyText: '${widget.type.name ?? ''}是空的哟~',
                      onClickedPreview: (v) {
                        tabParentLogic.getDiskDetail(v);
                      },
                      showBottomBarHeight: logic.optionC?.showing.value ?? false ? 160.w : 0,
                    )),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vipBar() {
    return Obx(() => Opacity(
      opacity: logic.optionC?.showing.value ?? false ? .3 : 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        height: 28.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kFFF5EC(),
              kWhite()
            ],
            stops: const [0.0, .8]
          )
        ),
        child: user.memberEquity.value!.vipStatus == 1 ? Row(
          children: [
            Image.asset(
              R.assetsIoVip,
              width: 27.w,
              height: 15.w,
            ),
            spaceW(8),
            MyText(
              '会员尊享，无限制在线解压生效中',
              size: 11.sp,
              color: kE77700(),
              weight: FontWeight.normal,
            )
          ],
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              '开通会员，享无限制在线解压特权',
              size: 11.sp,
              color: kE77700(),
              weight: FontWeight.normal,
            ),
            MyButton(
              title: '马上开通',
              width: 52.w,
              height: 22.w,
              alignment: Alignment.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: k713801(),
                fontWeight: FontWeight.bold
              ),
              decoration: BoxDecoration(
                borderRadius: 6.borderRadius,
                color: kFFECDA()
              ),
              onTap: () {
                showOpenMemberSheet(openMemberType: OpenMemberType.extractZip);
              },
            )                    
          ],
        ),
      ),
    ));
  }

  @override
  FileOnlyListLogic get initController => FileOnlyListLogic(widget.type);
}
