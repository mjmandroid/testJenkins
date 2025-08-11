import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/cupertino.dart';

class FileSearchLogic extends BaseLogic{
  final textC = TextEditingController();
  final canClear = false.obs;
  final focus = FocusNode();
  var searchRecord = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    user.initSearchData();
    getSearchRecord();
    textC.addListener(() {
      canClear.value = textC.text.trim().isNotEmpty;
    });
    0.2.delay().then((value) => focus.requestFocus());
  }

  /// 获取搜索记录
  getSearchRecord() {
    searchRecord.value = SP.searchRecord;
  }

  /// 添加搜索记录
  addSearchRecord() {
    if (textC.value.text.isEmpty) return;
    searchRecord.remove(textC.value.text);
    if (searchRecord.length >= 10) {
      searchRecord.removeLast();
    }
    searchRecord.insert(0, textC.value.text);
    SP.searchRecord = searchRecord;
  }

  /// 清空搜索记录
  cleanSearchRecord() async {
    var res = await showNormalDialog(title: '清空提示', message: '确定清空搜索历史吗？');
    if (res == null || !res) return;
    searchRecord.clear();
    SP.searchRecord = searchRecord;
  }
}