import 'package:desk_cloud/entity/search_result_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:flutter/material.dart';

class FileSearchResultLogic extends BaseLogic with GetTickerProviderStateMixin{
  final textC = TextEditingController();
  final currentIndex = 0.obs;
  final tabC = Rxn<TabController>();
  final canClear = false.obs;
  final int timeTag;
  FileSearchResultLogic(this.timeTag);
  FileOptionController? optionC;

  final searchResultEntity = Rxn<SearchResultEntity>();

  @override
  void onInit() {
    super.onInit();
    tabC.value = TabController(length: user.searchEnumType.value?.length ?? 0, vsync: this);
    tabC.value?.addListener(() {
      if (currentIndex.value != tabC.value!.index){
        currentIndex.value = tabC.value!.index;
        optionC?.hidden();
      }
    });
    textC.addListener(() {
      canClear.value = textC.text.trim().isNotEmpty;
    });
  }

  search() async {
    showLoading();
    try {
      var base = await ApiNet.request<SearchResultEntity>(Api.diskSearchInit, method: 'POST', data: {
        'word': textC.value.text
      }); 
      searchResultEntity.value = base.data;
      dismissLoading();
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
  }

}