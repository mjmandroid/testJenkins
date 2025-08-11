import 'package:desk_cloud/content/file/file_home_sub_logic.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_list_refresh_view.dart';
import 'package:flutter/material.dart';

class FileHomeSubPart extends StatefulWidget {
  final dynamic args;

  const FileHomeSubPart(this.args, {super.key});

  @override
  State<FileHomeSubPart> createState() => _FileHomeSubPartState();
}

class _FileHomeSubPartState extends BaseXState<FileHomeSubLogic, FileHomeSubPart> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => FileListRefreshView(
      controller: logic.controller,
      onRefresh: logic.onRefresh,
      onLoading: logic.onLoading,
      rxFile: logic.rootDir,
      onSelectedChange: (v){
        logic.selectedChange();
      },
      onNext: (v){
        push(MyRouter.fileListNormal,args: FileNormalSearchEntity(v,searchMap: {'sort': 'desc', 'source': widget.args}));
      },
      emptyText: widget.args == 1 ? '没有找到上传记录' : widget.args == 2 ? '没有找到提取记录' : '没有任何文件(夹)哟~',
      onClickedPreview: (v) {
        tabParentLogic.getDiskDetail(v);
      },
      showBottomBarHeight: tabParentLogic.optionC?.showing.value ?? false ? 110.w : 0,
    ));
  }

  @override
  String? get tag => 'FileHomeSubLogic_${widget.args}';

  @override
  FileHomeSubLogic get initController => FileHomeSubLogic(widget.args);

  @override
  bool get wantKeepAlive => true;
}
