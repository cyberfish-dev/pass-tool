import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/screens/records_screen.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FolderList extends StatefulWidget {
  const FolderList({super.key});

  @override
  State<FolderList> createState() => FolderListState();
}

class FolderListState extends State<FolderList> {
  List<ListItemModel> _folders = [];

  void update() {
    final metadata = VaultService.fetchMeta();

    setState(() {
      _folders = metadata.folders
          .map(
            (el) => ListItemModel(
              el.name,
              PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
              (metadata.folderCounts[el.id] ?? BigInt.zero).toInt(),
              (ctx) {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (context) => RecordsScreen(
                      showTrash: false,
                      category: null,
                      folderId: el.id,
                      title: el.name,
                    ),
                  ),
                );
              },
              el.id,
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
    if (_folders.isEmpty) {
      // return some empty space here
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'FOLDERS', count: _folders.length),
        ListItems(items: _folders),
        const SizedBox(height: 24),
      ],
    );
  }
}
