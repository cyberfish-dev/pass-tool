import 'package:flutter/material.dart';

class ListItemModel {
  
  final String title;
  final IconData icon;
  final int? count;
  final void Function(BuildContext) onTap;

  const ListItemModel(this.title, this.icon, this.count, this.onTap);
}