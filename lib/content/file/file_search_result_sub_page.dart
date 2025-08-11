import 'package:desk_cloud/content/file/file_search_result_sub_logic.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/entity/search_result_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_list_refresh_view.dart';
import 'package:flutter/material.dart';

class FileSearchResultSubPage extends StatefulWidget {
  final int timeTag;
  final String text;
  final SearchResultEnumDataType type;
  final bool showBottomBar;
  const FileSearchResultSubPage(this.text,this.timeTag,this.type,this.showBottomBar,{super.key});

  @override
  State<FileSearchResultSubPage> createState() => _FileSearchResultSubPageState();
}

class _FileSearchResultSubPageState extends BaseXState<FileSearchResultSubLogic,FileSearchResultSubPage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FileListRefreshView(
      controller: logic.controller,
      onRefresh: logic.onRefresh,
      onLoading: logic.onLoading,
      rxFile: logic.rxFile,
      onSelectedChange: (v){
        logic.selectedChange();
      },
      onNext: (v){
        push(MyRouter.fileListNormal,args: FileNormalSearchEntity(v,searchMap: {}));
      },
      emptyText: '${widget.type.value ?? ''}是空的哟~',
      onClickedPreview: (v) {
        tabParentLogic.getDiskDetail(v);
      },
      showBottomBarHeight: widget.showBottomBar ? 160.w : 0,
    );
  }

  @override
  String? get tag => 'FileSearchResultSubLogic_${widget.timeTag}_${widget.type.value}';

  @override
  FileSearchResultSubLogic get initController => FileSearchResultSubLogic(widget.text,widget.timeTag,widget.type);

  @override
  bool get wantKeepAlive => true;
}
