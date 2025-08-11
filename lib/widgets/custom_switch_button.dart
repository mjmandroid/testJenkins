import 'package:flutter/material.dart';
import 'dart:math' as math;


class SwitchButton extends StatefulWidget {
  final double width;
  final double height;
  final double viewRadius;
  final Color pointColor; //开关圆点颜色
  final Color unSelectColor; //未选中底色
  final Color selectedColor; //选中时底色
  final List<Color>? selectedColors;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final bool enable;

  const SwitchButton({
    Key? key,
    this.width = 50.0,
    this.height = 30.0,
    this.viewRadius = 143,
    this.pointColor = Colors.white,
    this.unSelectColor = const Color(0xFFEAEAEA),
    this.selectedColor = Colors.black,
    this.selectedColors,
    this.isSelected = false,
    this.enable = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> with TickerProviderStateMixin{
  AnimationController? _animaController;
  Animation<double>? _align;
  bool? _currentStatus;
  @override
  Widget build(BuildContext context) {
    if (_currentStatus != widget.isSelected){
      _currentStatus = widget.isSelected;
      _animaController = AnimationController(vsync: this,duration: const Duration(milliseconds: 50));
      _align = Tween(begin: widget.isSelected ? -1.0 : 1.0 ,end: widget.isSelected ? 1.0 : -1.0).animate(_animaController!);
      _animaController!.forward();
    }
    return GestureDetector(
      onTap: () {
        if (widget.enable) {
          widget.onChanged?.call(!widget.isSelected);
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            _backgroundWidget(),
            if (_animaController != null)
              AnimatedBuilder(animation: _animaController!, builder: (context,value){
                return Align(
                  alignment: Alignment(_align?.value ?? -1, 1),
                  child: Padding(
                    padding: EdgeInsets.all(0.23 * math.min(widget.width, widget.height) / 2),
                    child: _pointWidget(),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: widget.isSelected ? (widget.selectedColors ?? [widget.selectedColor,widget.selectedColor]) : [widget.unSelectColor,widget.unSelectColor]), borderRadius: BorderRadius.circular(widget.viewRadius)),
    );
  }

  Widget _pointWidget() {
    return ClipOval(
      child: Container(
        width: math.min(widget.width, widget.height) * 0.77,
        height: math.min(widget.width, widget.height) * 0.77,
        color: widget.pointColor,
      ),
    );
  }
}
