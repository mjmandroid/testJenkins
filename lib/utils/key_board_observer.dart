import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// initState中添加 WidgetsBinding.instance.addObserver(KeyBoardObserver.instance);
/// dispose中添加 WidgetsBinding.instance.removeObserver(KeyBoardObserver.instance);
/// 这个是实时变化的键盘高度
typedef FunctionType = void Function(bool isKeyboardShow);

class KeyBoardObserver extends WidgetsBindingObserver {
  double keyboardHeight = 0;
  bool? isKeyboardShow;
  bool? _preKeyboardShow;
  bool? isOpening;
  static const KEYBOARD_MAX_HEIGHT = "keyboard_max_height";
  double preBottom = -1;

  double lastBottom = -1;

  ///计算回调次数
  int times = 0;

  KeyBoardObserver._() {
    _getHeightToSp();
  }

  static final KeyBoardObserver _instance = KeyBoardObserver._();

  static KeyBoardObserver get instance => _instance;

  FunctionType? listener;

  void addListener(FunctionType listener) {
    this.listener = listener;
  }

  @override
  void didChangeMetrics() {
    times++;
    debugPrint("didChangeMetrics times $times");

    final bottom = MediaQueryData.fromWindow(window).viewInsets.bottom;
    if (times == 1) {
      Future.delayed(const Duration(milliseconds: 50), () {
        ///重点检测键盘变手写
        if (bottom != 0 && times < 3 && bottom == preBottom) {
          keyboardHeight = bottom;
          listener?.call(bottom == 0);
          saveHeightToSp();
          debugPrint("didChangeMetrics 键盘直走一次的时候记录高度 keyboardHeight:$keyboardHeight");
          times = 0;
          // state.setState(() {});
        }
      });
    }
    // 键盘存在中间态，回调是键盘冒出来的高度
    keyboardHeight = max(keyboardHeight, bottom);

    if (bottom == 0 && keyboardHeight != 0) {
      debugPrint("didChangeMetrics bottom == 0 keyboardHeight $keyboardHeight");
      isKeyboardShow = false;
    } else if (bottom == keyboardHeight) {
      debugPrint("didChangeMetrics bottom == keyboardHeight bottom $bottom keyboardHeight $keyboardHeight");
      isKeyboardShow = true;
    } else {
      ///键盘打开和收起，都会走这里。
      debugPrint("didChangeMetrics isKeyboardShow == null  _preKeyboardShow $_preKeyboardShow bottom $bottom keyboardHeight $keyboardHeight");
      isKeyboardShow = null;

      if (_preKeyboardShow == false) {
        isOpening = true;
        debugPrint("didChangeMetrics 键盘正在打开");
      }
      if (_preKeyboardShow == true) {
        isOpening = false;
        debugPrint("didChangeMetrics 键盘正在关闭");
      }

      ///当键盘正在打开的时候才需要
      if (isOpening == true) {
        ///记住当前值，如果大于250，延时50ms，如果当前值和之前值是一样的，则表示键盘最大值，
        if (bottom > 250) {
          lastBottom = bottom;
          Future.delayed(const Duration(milliseconds: 100), () {
            final bottom = MediaQueryData.fromWindow(window).viewInsets.bottom;
            if (lastBottom == bottom && isKeyboardShow == null) {
              keyboardHeight = bottom;
              debugPrint("didChangeMetrics 键盘展开 preBottom == bottom keyboardHeight $keyboardHeight");
              isKeyboardShow = true;
            }
          });
        }
      }
    }

    ///展开和收起   第一次
    if (isKeyboardShow != null && _preKeyboardShow != isKeyboardShow && keyboardHeight != 0) {

      ///改变键盘为手写模式也会走这里，但是如果是手写改成9按键（键盘由高变小），不会走这里。
      debugPrint("didChangeMetrics 键盘完全收起或展开再刷新页面 bottom $bottom keyboardHeight $keyboardHeight isKeyboardShow $isKeyboardShow _preKeyboardShow $_preKeyboardShow");
      times = 0;
      // listener?.call(bottom == 0);
      listener?.call(isKeyboardShow == true);

      ///收起时候保存键盘高度
      if (bottom == 0 && keyboardHeight != 0) {
        saveHeightToSp();
      }
    }
    _preKeyboardShow = isKeyboardShow;
    preBottom = bottom;
  }

  Future<void> saveHeightToSp() async {
    final instance = await SharedPreferences.getInstance();
    instance.setDouble(KEYBOARD_MAX_HEIGHT, keyboardHeight);
  }

  void _getHeightToSp() async {
    if (keyboardHeight == 0) {
      final instance = await SharedPreferences.getInstance();
      keyboardHeight = instance.getDouble(KEYBOARD_MAX_HEIGHT) ?? 0;
      debugPrint(" KeyBoardObserver._() keyboardHeight : $keyboardHeight ");
    }
  }

  ///提供给布局直接使用 虽然你不是实时高度，但是不会出现抖动问题
  Future<double> getKeyBordHeight() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getDouble(KEYBOARD_MAX_HEIGHT) ?? 0;
  }
}