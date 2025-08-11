import 'package:desk_cloud/content/file/file_search_result_logic.dart';
import 'package:desk_cloud/entity/base_list_entity.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/search_result_entity.dart';
import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:desk_cloud/widgets/file_option/disk_file_type.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';

class FileSearchResultSubLogic extends BaseLogic with RefreshHelper{
  final int timeTag;
  final String text;
  final SearchResultEnumDataType type;
  final rxFile = Rx(DiskFileEntity());
  late final pLogic = find<FileSearchResultLogic>(tag: 'FileSearchResultLogic_$timeTag');

  FileSearchResultSubLogic(this.text,this.timeTag,this.type);

  @override
  void onInit() {
    super.onInit();
    requestForDataList();
    pLogic?.optionC?.hidden();
  }

  selectedChange()async{
    pLogic?.optionC?.addNeedRefreshRx(rxFile);
    pLogic?.optionC?.addSelectedCallback(_totalSelectedCallback);
    pLogic?.optionC?.addClickCallback(_optionTypeCallback);
    pLogic?.optionC?.show(rxFile.value.subs?.where((element) => element.selected == true));
    pLogic?.optionC?.totalSelected = rxFile.value.subsTotalSelected;
    rxFile.refresh();
  }

  _optionTypeCallback(type,list)async{
    switch(type){
      case FileOptionType.delete:
        onRefresh();
        break;
      case FileOptionType.move:
        rxFile.refresh();
        break;
      case FileOptionType.rename:
        rxFile.refresh();
        break;
    }
  }

  _totalSelectedCallback(FileOptionController control,bool isTotal){
    rxFile.value.subs?.forEach((element) {element.selected = isTotal;});
    control.totalSelected = isTotal;
    rxFile.refresh();
    selectedChange();
  }

  requestForDataList()async{
    try{
      var base = await ApiNet.request<BaseListEntity>(Api.diskSearch,data: {
        'word': text,
        'type': type.key,
        'page': page,
        'size': pageSize
      });
      if (page == 1){
        rxFile.value.subs = null;
        pLogic?.optionC?.hidden();
      }
      rxFile.value.subs ??= [];
      // rxFile.value.subs?.addAll(jsonConvert.convertListNotNull<DiskFileEntity>(base.data?.list ?? []) ?? []);
      List<DiskFileEntity>? tempArr = jsonConvert.convertListNotNull<DiskFileEntity>(base.data?.list ?? []);
      if (tempArr != null) {
        for (var tempItem in tempArr) {
          tempItem.selected =  pLogic?.optionC?.totalSelected;
        }
      }  
      rxFile.value.subs?.addAll(tempArr ?? []);
      selectedChange();

      controller.refreshCompleted();
      if ((rxFile.value.subs?.length ?? 0) >= (base.data?.total ?? 0)){
        controller.loadNoData();
      }else{
        controller.loadComplete();
      }
      rxFile.refresh();
    }catch(e){
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

}