import 'package:flutter/material.dart';

class NotchedBorder extends ShapeBorder {
  final NotchedShape notch;
  final Rect? guest;       // the FAB’s rect in the same coords as the bar
  final double borderWidth;
  final Color borderColor;

  const NotchedBorder({
    required this.notch,
    this.guest,
    this.borderWidth = 1,
    this.borderColor = Colors.white,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderWidth);

  Path _buildPath(Rect rect) => notch.getOuterPath(rect, guest);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // inset so the stroke doesn’t get clipped
    return _buildPath(rect.deflate(borderWidth));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // stroke the same path
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;
    canvas.drawPath(_buildPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
