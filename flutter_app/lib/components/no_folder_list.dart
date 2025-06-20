import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoFolderList extends StatefulWidget {
  const NoFolderList({super.key});

  @override
  State<NoFolderList> createState() => NoFolderListState();
}

class NoFolderListState extends State<NoFolderList> {
  List<ListItemModel> _items = [];

  void update() {
    final metadata = VaultService.fetchMeta();

    setState(() {
      final items = metadata.entries
          .where((item) => item.folder == null)
          .toList();

      _items = items.map((item) {
        return ListItemModel(
          item.name,
          PhosphorIcons.globe(PhosphorIconsStyle.thin),
          null,
          (ctx) => {},
          item.id,
        );
      }).toList();
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
        SectionHeader(title: 'NO FOLDER', count: _items.length),
        ListItems(items: _items),
      ],
    );
  }
}
