import 'package:desk_cloud/alert/file_sort_type_sheet.dart';
import 'package:desk_cloud/entity/base_list_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';

class FileOnlyListLogic extends BaseLogic with RefreshHelper{
  final sortType = FileSortType.normal.obs;
  final subSortType = FileSortSubType.desc.obs;
  final DiskFileType type;
  final diskFile = Rx(DiskFileEntity()
    ..id = -1);
  FileOnlyListLogic(this.type);

  FileOptionController? optionC;

  @override
  void onInit() {
    super.onInit();
    requestForDataList(loading: true);
  }

  requestForDataList({ bool loading = false })async{
    try{
      if (loading) {
        showLoading();
      }
      var base = await ApiNet.request<BaseListEntity>(Api.diskIndex,data: {
        'dir_id': diskFile.value.id,
        'page': page,
        'pagesize': pageSize,
        'type': type.type,
        'sort': subSortType.value.value,
        'orderby': sortType.value.value
      });
      if (loading) {
        dismissLoading();
      }
      if (page == 1){
        diskFile.value.subs = null;
        optionC?.hidden();
      }
      diskFile.value.subs ??= [];
      // diskFile.value.subs?.addAll(jsonConvert.convertListNotNull<DiskFileEntity>(base.data?.list ?? []) ?? []);
      List<DiskFileEntity>? tempArr = jsonConvert.convertListNotNull<DiskFileEntity>(base.data?.list ?? []);
      if (tempArr != null) {
        for (var tempItem in tempArr) {
          tempItem.selected =  optionC?.totalSelected;
        }
      }  
      diskFile.value.subs?.addAll(tempArr ?? []);
      selectedChange();
      
      controller.refreshCompleted();
      if ((diskFile.value.subs?.length ?? 0) >= (base.data?.total ?? 0)){
        controller.loadNoData();
      }else{
        controller.loadComplete();
      }
      diskFile.refresh();
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

  selectedChange()async{
    optionC?.addNeedRefreshRx(diskFile);
    optionC?.addSelectedCallback(_totalSelectedCallback);
    optionC?.addClickCallback(_optionTypeCallback);
    optionC?.show(diskFile.value.subs?.where((element) => element.selected == true));
    optionC?.totalSelected = diskFile.value.subsTotalSelected;
    diskFile.refresh();
  }

  _totalSelectedCallback(FileOptionController control,bool isTotal) {
    diskFile.value.subs?.forEach((element) {element.selected = isTotal;});
    control.totalSelected = isTotal;
    diskFile.refresh();
    selectedChange();
  }

  _optionTypeCallback(type,list)async{
    switch(type){
      case FileOptionType.delete:
        onRefresh();
        break;
      case FileOptionType.move:
        diskFile.refresh();
        break;
      case FileOptionType.rename:
        diskFile.refresh();
        break;
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
}