import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/store/store_facade.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FolderList extends StatefulWidget {
  const FolderList({super.key});

  @override
  State<FolderList> createState() => FolderListState();
}

class FolderListState extends State<FolderList> {
  late final store = StoreFacade();
  List<ListItemModel> _folders = [];

  void update() {
    setState(() {
      _folders = store
          .listFolders()
          .map(
            (el) => ListItemModel(
              el,
              PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
              null,
              (ctx) {
                store.removeFolder(el);
                update();
              },
            ),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'FOLDERS', count: _folders.length),
        if (_folders.isNotEmpty) ListItems(items: _folders),
      ],
    );
  }
}
