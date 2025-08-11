import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_file_logic.dart';
import 'package:desk_cloud/entity/base_list_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';

class FileHomeSubLogic extends BaseLogic with RefreshHelper{
  final dynamic source;
  FileHomeSubLogic(this.source);
  final rootDir = Rx(DiskFileEntity()
    ..id = 0
    ..title = '根目录');

  @override
  void onInit() {
    super.onInit();
    requestForDataList(loading: true);
  }

  selectedChange()async{
    find<TabParentLogic>()?.optionC?.addNeedRefreshRx(rootDir);
    find<TabParentLogic>()?.optionC?.addSelectedCallback(_totalSelectedCallback);
    find<TabParentLogic>()?.optionC?.addClickCallback(_optionTypeCallback);
    find<TabParentLogic>()?.optionC?.show(rootDir.value.subs?.where((element) => element.selected == true));
    find<TabParentLogic>()?.optionC?.totalSelected = rootDir.value.subsTotalSelected;
    rootDir.refresh();
  }

  _optionTypeCallback(type,list)async{
    switch(type){
      case FileOptionType.delete:
        onRefresh();
        break;
      case FileOptionType.move:
        rootDir.refresh();
        break;
      case FileOptionType.rename:
        rootDir.refresh();
        break;
    }
  }

  _totalSelectedCallback(FileOptionController control,bool isTotal){
    rootDir.value.subs?.forEach((element) {element.selected = isTotal;});
    control.totalSelected = isTotal;
    rootDir.refresh();
    selectedChange();
  }

  requestForDataList({ bool loading = false })async{
    try{
      if (loading) {
        showLoading();
      }
      var base = await ApiNet.request<BaseListEntity>(Api.diskIndex,data: {
        'dir_id': rootDir.value.id,
        'page': page,
        'pagesize': pageSize,
        'orderby': fileLogic.sortType.value.value,
        'sort': fileLogic.subSortType.value.value,
        'source': source
      });
      if (loading) {
        dismissLoading();
      }
      if (page == 1){
        rootDir.value.subs = null;
        find<TabParentLogic>()?.optionC?.hidden();
      }
      rootDir.value.subs ??= [];
      // rootDir.value.subs?.addAll(jsonConvert.convertListNotNull<DiskFileEntity>(base.data?.list ?? []) ?? []);
      
      List<DiskFileEntity>? tempArr = jsonConvert.convertListNotNull<DiskFileEntity>(base.data?.list ?? []);
      if (tempArr != null) {
        for (var tempItem in tempArr) {
          tempItem.selected =  find<TabParentLogic>()?.optionC?.totalSelected;
        }
      }  
      rootDir.value.subs?.addAll(tempArr ?? []);
      selectedChange();
      
      controller.refreshCompleted();
      if ((rootDir.value.subs?.length ?? 0) >= (base.data?.total ?? 0)){
        controller.loadNoData();
      }else{
        controller.loadComplete();
      }
      rootDir.refresh();
    }catch(e){
      if (loading) {
        dismissLoading();
      }
      if (page > 1){
        page--;
        controller.loadFailed();
      }else{
        controller.refreshFailed();
      }
      showShortToast(e.toString());
    }
  }

  @override
  void onRefresh() {
    page = 1;
    requestForDataList();
  }

  @override
  void onLoading() {
    page++;
    requestForDataList();
  }

  createAction()async{
    var r = await user.createDir(rootDir.value.id ?? 0);
    if (r == true){
      onRefresh();
    }
  }
}