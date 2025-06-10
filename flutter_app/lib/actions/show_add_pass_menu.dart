import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/menu/action_items.dart';

void showAddMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListItems(items: actions)
    ),
  );
}
