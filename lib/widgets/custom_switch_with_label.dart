import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';

/// 带标注的自定义Switch组件
class CustomSwitchWithLabel extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  
  const CustomSwitchWithLabel({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },
      child: Stack(
        children: [
          Container(
            width: 27.w,  
            height: 17.w,
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: value ? k4A83FF() : kB(),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 14.w,
                height: 14.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}