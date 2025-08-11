import 'package:flutter/material.dart';

class KeyboardUtils {
  // 保存键盘高度
  double _keyboardHeight = 0.0;

  // 获取键盘高度
  double get keyboardHeight => _keyboardHeight;

  // 更新键盘高度
  void updateKeyboardHeight(BuildContext context, Function(double) onHeightChanged) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (_keyboardHeight != bottomInset) {
      _keyboardHeight = bottomInset;
      onHeightChanged(_keyboardHeight); // 回调通知变化
    }
  }
}