import 'package:flutter/material.dart';

class MaskText extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Axis axis;
  const MaskText({Key? key,required this.child,required this.colors,this.axis = Axis.horizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds){
        return LinearGradient(
          colors: colors,
          begin: axis == Axis.horizontal ? Alignment.centerLeft : Alignment.topCenter,
          end: axis == Axis.horizontal ? Alignment.centerRight : Alignment.bottomCenter
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Center(
        child: child,
      ),
    );
  }
}
