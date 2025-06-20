import 'package:flutter/material.dart';

class ListItemModel {
  final String id;
  final String title;
  final IconData icon;
  int? count;
  final void Function(BuildContext) onTap;
  
  ListItemModel(this.title, this.icon, this.count, this.onTap, this.id);
}
