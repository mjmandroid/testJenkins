import 'package:desk_cloud/utils/base_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseXState<T extends BaseLogic, W extends StatefulWidget> extends State<W> {

  @override
  void initState() {
    super.initState();
    //默认的调用logic进行初始化
    logic;
  }

  T? _logic;

  bool get autoDispose => true;

  T get initController;

  T get logic {
    if (_logic == null) {
      if (Get.isRegistered<T>(tag: tag)) {
        _logic = Get.find<T>(tag: tag);
      } else {
        final logic = Get.put<T>(initController, tag: tag);
        logic.context = context;
        _logic = logic;
      }
    }
    return _logic!;
  }

  String? get tag => null;

  @override
  void dispose() {
    if (autoDispose) {
      Get.delete<T>(tag: tag);
    }
    super.dispose();
  }
}

T? find<T extends BaseLogic>({String? tag}) {
  if (Get.isRegistered<T>(tag: tag)) {
    return Get.find<T>(tag: tag);
  }
  return null;
}
