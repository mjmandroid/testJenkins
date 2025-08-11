import 'package:desk_cloud/alert/file_upload_sheet.dart';
import 'package:desk_cloud/content/file/file_list_normal_logic.dart';
import 'package:desk_cloud/content/file/file_search_page.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_list_refresh_view.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:flutter/material.dart';

class FileListNormalPage extends StatefulWidget {
  final FileNormalSearchEntity diskFileSearch;
  const FileListNormalPage(this.diskFileSearch,{super.key});

  @override
  State<FileListNormalPage> createState() => _FileListNormalPageState();
}

class _FileListNormalPageState extends BaseXState<FileListNormalLogic,FileListNormalPage> {
  @override
  Widget build(BuildContext context) {
    return FileOptionContainer(
      onCreate: (v){
        logic.optionC = v;
        v.setMode(FileOptionMode.cloud);
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: MyText(widget.diskFileSearch.diskFile.title ?? ''),
          backgroundColor: kWhite(),
          actions: [
            IconButton(onPressed: (){
              showFileSearch('');
            }, icon: Image.asset(R.assetsFileSearch, width: 24.w, height: 24.w,))
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: kWhite(),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: 20.radius),
                    child: Container(
                      color: kWhite(),
                      child: Obx(() => FileListRefreshView(
                        controller: logic.controller,
                        onRefresh: logic.onRefresh,
                        onLoading: logic.onLoading,
                        rxFile: logic.diskFile,
                        onSelectedChange: (v){
                          logic.selectedChange();
                        },
                        onNext: (v){
                          push(MyRouter.fileListNormal,args: FileNormalSearchEntity(v,searchMap: widget.diskFileSearch.searchMap));
                        },
                        emptyText: '文件夹是空的哟~',
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
            Positioned(
              right: 10.w,
              bottom: 57.w + safeAreaBottom,
              child: GestureDetector(
                onTap: () async {
                  var res = await showFileUploadSheet(dirId: widget.diskFileSearch.diskFile.id ?? 0);
                  if (res == null || res == false) return;
                  Get.find<FileListNormalLogic>(tag: 'FileListNormalLogic_${widget.diskFileSearch.diskFile.id}').requestForDataList();
                },
                child: Image.asset(R.assetsFileAdd, width: 61.w, height: 61.w,),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  String? get tag => 'FileListNormalLogic_${widget.diskFileSearch.diskFile.id}';

  @override
  FileListNormalLogic get initController => FileListNormalLogic(widget.diskFileSearch);
}
