import 'package:flutter/material.dart';
import 'package:flutter_app/models/folder_model.dart';
import 'package:flutter_app/models/form_base.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

abstract class FormBaseState<W extends StatefulWidget, T> extends State<W>
    implements FormBase<T> {
  
  FolderModel? selectedFolder;
  List<ListItemModel> folders = [];

  void initFolders() {
    setState(() {
      folders = VaultService.fetchMeta()
          .folders
          .map(
            (el) => ListItemModel(
              el.name,
              PhosphorIcons.folderSimple(PhosphorIconsStyle.thin),
              null,
              (ctx) {
                Navigator.pop(ctx, el);
              },
              el.id,
            ),
          )
          .toList();
    });
  }
}
