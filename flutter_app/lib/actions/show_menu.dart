import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/enums/positions.dart';
import 'package:flutter_app/models/list_item_model.dart';

Future<T?> showCustomMenu<T>(
  BuildContext context,
  GlobalKey itemKey,
  List<ListItemModel> items,
  double popupWidth, {
  Position pos = Position.bottomLeft,
  double gap = 4.0,
  int maxPopupElements = 5,
}) {

  var popupHeight = items.length * 49.0 - 1;
  
  if (items.length > maxPopupElements) {
    popupHeight = maxPopupElements * 49.0 - 1;
  }

  final position = computeMenuPosition(
    context: context,
    anchorKey: itemKey,
    popupWidth: popupWidth,
    popupHeight: popupHeight,
    position: pos,
    gap: gap,
  );

  return showMenu<T>(
    context: context,
    position: position,
    menuPadding: EdgeInsets.zero,
    constraints: BoxConstraints.tightFor(width: popupWidth, height: popupHeight),
    items: [
      PopupMenuItem(
        padding: EdgeInsets.zero,
        enabled: false,
        child: SizedBox(
          height: popupHeight,
          child: ListItems(items: items)),
      ),
    ],
  );
}

RelativeRect computeMenuPosition({
  required BuildContext context,
  required GlobalKey anchorKey,
  required double popupWidth,
  required double popupHeight,
  required Position position,
  required double gap,
}) {
  // 1) Grab the overlay & anchor boxes
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final anchor = anchorKey.currentContext!.findRenderObject() as RenderBox;
  final anchorTopLeft = anchor.localToGlobal(Offset.zero, ancestor: overlay);
  final aW = anchor.size.width;
  final aH = anchor.size.height;

  // 2) Horizontal offset within anchor
  double dx;
  switch (position.horizontal) {
    case PositionHorizontal.left:
      dx = anchorTopLeft.dx;
      break;
    case PositionHorizontal.center:
      dx = anchorTopLeft.dx + (aW - popupWidth) / 2;
      break;
    case PositionHorizontal.right:
      dx = anchorTopLeft.dx + (aW - popupWidth);
      break;
  }

  // 3) Vertical offset relative to anchor
  double dy;
  switch (position.vertical) {
    case PositionVertical.top:
      // place popup above
      dy = anchorTopLeft.dy - popupHeight - gap;
      break;
    case PositionVertical.center:
      // center vertically on anchor
      dy = anchorTopLeft.dy + (aH - popupHeight) / 2;
      break;
    case PositionVertical.bottom:
      // place popup below
      dy = anchorTopLeft.dy + aH + gap;
      break;
  }

  // 4) Build and return the RelativeRect
  final rect = Rect.fromLTWH(dx, dy, popupWidth, popupHeight);
  return RelativeRect.fromRect(rect, Offset.zero & overlay.size);
}
