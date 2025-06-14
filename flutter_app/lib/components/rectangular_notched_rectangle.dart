import 'package:flutter/material.dart';

class RectangularNotchedRectangle extends NotchedShape {
  final double notchWidth;
  final double notchHeight;
  final double notchRadius;
  final bool ignore;

  const RectangularNotchedRectangle({
    required this.notchWidth,
    required this.notchHeight,
    required this.ignore,
    this.notchRadius = 0,
  });

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    final Path p = Path()..addRect(host);

    if (guest == null || !host.overlaps(guest)) {
      return p;
    }

    // Centered on the FAB
    final cx    = guest.center.dx;
    final halfW = notchWidth / 2;
    final nl    = cx - halfW;
    final nr    = cx + halfW;
    final nh    = host.top + notchHeight;
    final r     = notchRadius;

    if(ignore) {
       return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(host.right, host.top);
    }

    // Carve out an inner rounded notch
    final notch = Path()
      ..moveTo(nl - r, host.top)
      ..arcToPoint(Offset(nl, host.top + r),
                    radius: Radius.circular(r),
                    clockwise: true)
      ..lineTo(nl, nh - r)

      ..arcToPoint(Offset(nl + r, nh),
                    radius: Radius.circular(r),
                    clockwise: false)
      ..lineTo(nr - r, nh)
      ..arcToPoint(Offset(nr, nh - r),
                    radius: Radius.circular(r),
                    clockwise: false)
      ..lineTo(nr, host.top + r)
      ..arcToPoint(Offset(nr + r, host.top),
                    radius: Radius.circular(r),
                    clockwise: true)
      ..close();

    return Path.combine(PathOperation.difference, p, notch);
  }
}
