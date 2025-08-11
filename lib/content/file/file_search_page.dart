import 'package:desk_cloud/content/file/file_search_logic.dart';
import 'package:desk_cloud/content/file/file_search_result_page.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

showFileSearch(String text) {
  CustomNavigatorObserver().navigator?.push(PageRouteBuilder(pageBuilder: (context, a1, a2) {
    return FileSearchPage(text);
  }, transitionDuration: Duration.zero));
}

class FileSearchPage extends StatefulWidget {
  final String text;

  const FileSearchPage(this.text, {super.key});

  @override
  State<FileSearchPage> createState() => _FileSearchPageState();
}

class _FileSearchPageState extends BaseXState<FileSearchLogic, FileSearchPage> {

  @override
  void initState() {
    super.initState();
    logic.textC.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: MyText('搜索', color: k3(), size: 16.sp,),
        backgroundColor: kF8(),
      ),
      backgroundColor: kF8(),
      body: Column(
        children: [
          Container(
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
                    focusNode: logic.focus,
                    onSubmitted: (v) {
                      if (logic.textC.text.isEmpty) return;
                      logic.addSearchRecord();
                      closeEdit();
                      showFileSearchResult(logic.textC.text);
                    },
                    textInputAction: TextInputAction.search,
                  ),
                ),
                Obx(() {
                  if (!logic.canClear.value) return Container();
                  return SizedBox(
                    width: 40.w,
                    child: IconButton(onPressed: () {
                      closeEdit();
                      logic.textC.clear();
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
                    if (logic.textC.text.isEmpty) return;
                    logic.addSearchRecord();
                    closeEdit();
                    showFileSearchResult(logic.textC.text);
                  }, child: MyText('搜索', color: k4A83FF(), size: 13.sp,)),
                )
              ],
            ),
          ),
          spaceH(22),
          Row(
            children: [
              spaceW(16),
              MyText('搜索历史', color: k3(), size: 14.sp,),
              const Spacer(),
              MyButton(
                onTap: () {
                  logic.cleanSearchRecord();
                },
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),
                child: Image.asset(
                  R.assetsOptionDelete,
                  width: 16.w,
                  height: 16.w,
                ),
              ),
              spaceW(16),
            ],
          ),
          Obx(() {
            return Container(
              width: 396.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 14.w),
              child: Wrap(
                runSpacing: 10.w,
                spacing: 10.w,
                children: [
                  ...logic.searchRecord.map((e) {
                    return GestureDetector(
                      onTap: () {
                        logic.textC.text = e;
                        logic.addSearchRecord();
                        closeEdit();
                        showFileSearchResult(logic.textC.text);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8.w, right: 8.w),
                            height: 28.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: kBlack(0.04),
                                borderRadius: 8.borderRadius
                            ),
                            child: MyText(e, color: k3(), size: 12.sp,),
                          )
                        ],
                      ),
                    );
                  })
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  @override
  FileSearchLogic get initController => FileSearchLogic();
}
