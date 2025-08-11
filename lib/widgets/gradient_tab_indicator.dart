import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientTabIndicator extends Decoration {
  final LinearGradient gradient;
  const GradientTabIndicator({
    required this.gradient,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is GradientTabIndicator) {
      return GradientTabIndicator(
        gradient: const LinearGradient(
          colors: [Color(0xff29E8FF), Color(0xff4D75FF), Color(0xffA647F5), Color(0xffFF3BAD), Color(0xffFFFC66)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is GradientTabIndicator) {
      return GradientTabIndicator(
        gradient: const LinearGradient(
          colors: [Color(0xff29E8FF), Color(0xff4D75FF), Color(0xffA647F5), Color(0xffFF3BAD), Color(0xffFFFC66)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      (indicator.left + indicator.right) / 2 - 30.w / 2,
      indicator.bottom - borderSide.width,
      // indicator.width,
      30.w,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, gradient, onChanged);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, this.gradient, VoidCallback? onChanged) : super(onChanged);

  final GradientTabIndicator decoration;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    // final Rect indicator = decoration._indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    final Rect indicator = decoration._indicatorRectFor(rect, textDirection).deflate(20.w);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(indicator);
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
