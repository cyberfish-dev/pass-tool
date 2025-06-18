import 'package:flutter/material.dart';
import 'package:flutter_app/components/item_row.dart';
import 'package:flutter_app/models/list_item_model.dart';

class ListItems extends StatelessWidget {
  final List<ListItemModel> items;

  const ListItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items.map((cat) {
              var isLast = items.last == cat;
              return ItemRow(
                icon: cat.icon,
                title: cat.title,
                count: cat.count,
                onTap: () {
                   cat.onTap(context);
                },
                isLast: isLast,
              );
            }).toList(),
          ),
        
      ),
    );
  }
}
