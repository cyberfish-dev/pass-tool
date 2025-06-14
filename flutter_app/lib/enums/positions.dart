enum PositionHorizontal {
  left,
  center,
  right,
}

enum PositionVertical {
  top,
  center,
  bottom,
}

enum Position {
  topLeft(PositionHorizontal.left, PositionVertical.top),
  topCenter(PositionHorizontal.center, PositionVertical.top),
  topRight(PositionHorizontal.right, PositionVertical.top),
  centerLeft(PositionHorizontal.left, PositionVertical.center),
  centerCenter(PositionHorizontal.center, PositionVertical.center),
  centerRight(PositionHorizontal.right, PositionVertical.center),
  bottomLeft(PositionHorizontal.left, PositionVertical.bottom),
  bottomCenter(PositionHorizontal.center, PositionVertical.bottom),
  bottomRight(PositionHorizontal.right, PositionVertical.bottom);

  final PositionHorizontal horizontal;
  final PositionVertical vertical;

  const Position(this.horizontal, this.vertical);
}