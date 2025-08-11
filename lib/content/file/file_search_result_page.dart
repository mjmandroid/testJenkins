import 'package:desk_cloud/content/file/file_search_page.dart';
import 'package:desk_cloud/content/file/file_search_result_logic.dart';
import 'package:desk_cloud/content/file/file_search_result_sub_page.dart';
import 'package:desk_cloud/entity/search_result_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:flutter/material.dart';

showFileSearchResult(String text) {
  CustomNavigatorObserver().navigator?.pushAndRemoveUntil(PageRouteBuilder(pageBuilder: (context, a1, a2) {
    return FileSearchResultPage(text);
  }, transitionDuration: Duration.zero), (route) => route.settings.name != null);
}


class FileSearchResultPage extends StatefulWidget {
  final String text;

  const FileSearchResultPage(this.text, {super.key});

  @override
  State<FileSearchResultPage> createState() => _FileSearchResultPageState();
}

class _FileSearchResultPageState extends BaseXState<FileSearchResultLogic, FileSearchResultPage> {
  @override
  void initState() {
    super.initState();
    logic.textC.text = widget.text;
    logic.search();
  }

  @override
  Widget build(BuildContext context) {
    return FileOptionContainer(
      onCreate: (v){
        logic.optionC = v;
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: MyText('搜索', color: k3(), size: 16.sp,),
          backgroundColor: kF8(),
        ),
        backgroundColor: kF8(),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                showFileSearch(logic.textC.text);
              },
              child: Container(
                width: 343.w,
                height: 44.w,
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 3.w),
                decoration: BoxDecoration(
                    color: kWhite(),
                    borderRadius: 14.borderRadius
                ),
                padding: EdgeInsets.only(left: 10.w),
                child: Row(
                  children: [
                    Image.asset(R.assetsFileSearch, width: 24.w, height: 24.w,),
                    spaceW(6),
                    Expanded(
                      child: MyTextField(
                        hintText: '搜索网盘文件',
                        hintStyle: TextStyle(fontSize: 13.sp, color: k9(), fontWeight: FontWeight.w600),
                        style: TextStyle(fontSize: 13.sp, color: k3(), fontWeight: FontWeight.w600),
                        controller: logic.textC,
                        enabled: false,
                      ),
                    ),
                    Obx(() {
                      if (!logic.canClear.value) return Container();
                      return SizedBox(
                        width: 40.w,
                        child: IconButton(onPressed: () {
                          closeEdit();
                          logic.textC.clear();
                          showFileSearch(logic.textC.text);
                        }, icon: Image.asset(R.assetsSearchClear, width: 24.w, height: 24.w,)),
                      );
                    }),
                    Container(
                      width: 0.5.w,
                      height: 24.w,
                      color: hexColor('#dddddd'),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: TextButton(onPressed: () {
                        showFileSearch(logic.textC.text);
                      }, child: MyText('搜索', color: k4A83FF(), size: 13.sp,)),
                    )
                  ],
                ),
              ),
            ),
            spaceH(22),
            SizedBox(
              height: 30.w,
              child: Obx(() {
                if (logic.tabC.value == null) return Container();
                return TabBar(
                  controller: logic.tabC.value,
                  tabs: () {
                    var list = <Widget>[];
                    for (var item in user.searchEnumType.value ?? <SearchResultEnumDataType>[]) {
                      list.add(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() {
                                final selected = (user.searchEnumType.value?.indexOf(item) ?? 0) == logic.currentIndex.value;
                                return Container(
                                  height: 24.w,
                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                  decoration: BoxDecoration(
                                    color: selected ? hexColor('#EDF3FF') : kBlack(0.03),
                                    borderRadius: 8.borderRadius
                                  ),
                                  alignment: Alignment.center,
                                  child: MyText(item.value ?? '',color: selected ? k4A83FF() : kB3(),size: 11.sp,),
                                );
                              })
                            ],
                          )
                      );
                    }
                    return list;
                  }(),
                  indicator: const BoxDecoration(),
                  isScrollable: true,
                  padding: EdgeInsets.only(left: 11.w,right: 11.w),
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                if (logic.tabC.value == null) return Container();
                return TabBarView(
                  controller: logic.tabC.value,
                  children: () {
                    var list = <Widget>[];
                    for (var item in user.searchEnumType.value?? <SearchResultEnumDataType>[]) {
                      list.add(
                          FileSearchResultSubPage(logic.textC.text, _time, item, logic.optionC?.showing.value ?? false)
                      );
                    }
                    return list;
                  }(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  late final _time = DateTime
      .now()
      .millisecondsSinceEpoch;

  @override
  String? get tag => 'FileSearchResultLogic_$_time';

  @override
  FileSearchResultLogic get initController => FileSearchResultLogic(_time);
}
