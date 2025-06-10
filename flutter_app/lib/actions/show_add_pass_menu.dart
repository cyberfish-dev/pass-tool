import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/menu/action_items.dart';

void showAddMenu(BuildContext context, GlobalKey itemKey) {
  _openPopupAboveFab(context, itemKey);
}

void _openPopupAboveFab(BuildContext context, GlobalKey itemKey) {
  // 1) Grab the Overlay’s RenderBox
  final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

  // 2) Grab the FAB’s RenderBox
  final fabBox = itemKey.currentContext!.findRenderObject() as RenderBox;

  // 3) Convert FAB’s top-left into the Overlay’s coordinate space
  final fabTopLeft = fabBox.localToGlobal(Offset.zero, ancestor: overlay);

  // 4) Define how big your popup will be
  const popupWidth = 168.0;
  const popupHeight = 293.0;

  // 5) Build a Rect where you want your popup to appear
  final popupRect = Rect.fromLTWH(
    fabTopLeft.dx + (fabBox.size.width  - popupWidth ) / 2,   // center under FAB
    fabTopLeft.dy - popupHeight - 8,                          // above FAB + 8px gap
    popupWidth,
    popupHeight,
  );

  // 6) Compute the RelativeRect automatically
  final position = RelativeRect.fromRect(popupRect, Offset.zero & overlay.size);

  // 3. Show a popup menu at that position
  showMenu(
    context: context,
    position: position,
    menuPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      
    ),
    elevation: 65,
    shadowColor: Theme.of(context).colorScheme.secondary.withAlpha(130),
    items: [
      PopupMenuItem(
        padding: EdgeInsets.zero,
        enabled: false,
        child: ListItems(items: actions),
      ),
    ],
  );
}
