import 'package:flutter/material.dart';

class ArrowView extends StatelessWidget {
  final double size;
  final Color? color;
  const ArrowView({Key? key,required this.size,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ArrowClipper(),
      child: Container(
        width: size,
        height: size,
        color: color ?? Colors.white,
      ),
    );
  }
}


class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}