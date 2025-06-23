import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecordsList extends StatefulWidget {
  
  final String? searchText;
  final EntryCategory? category;
  final String? folderId;
  final bool showTrash;
  final String title;

  const RecordsList({super.key, this.searchText, this.category, this.folderId, required this.showTrash, required this.title});

  @override
  State<RecordsList> createState() => RecordsListState();
}

class RecordsListState extends State<RecordsList> {
  List<ListItemModel> _items = [];

  void update() {
    final metadata = VaultService.fetchMeta();

    setState(() {
      final items = metadata.entries
          .where((item) => item.folder == widget.folderId && 
                          (widget.category == null || item.category == widget.category) &&
                          (widget.showTrash ? item.isTrashed : true) &&
                          (widget.searchText == null || widget.searchText!.isEmpty || item.name.toLowerCase().contains(widget.searchText!.toLowerCase())))
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
        SectionHeader(title: widget.title, count: _items.length),
        ListItems(items: _items),
      ],
    );
  }
}
