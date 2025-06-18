import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/folder_add.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:flutter_app/vault/vault_service.dart';

class FolderAddAction extends BottomSheetAction<String, AddFolderFormState> {
  
  FolderAddAction() : super(title: 'Create Folder', formKey: GlobalKey<AddFolderFormState>());

  @override
  Widget buildBody(BuildContext context) {
    return AddFolderForm(key: formKey,);
  }

  @override
  void onAction(BuildContext context, String data) {
    VaultService.addFolder(data);

    Navigator.pop(context);
    ScreenUpdater.updateFolderList();
  }
}
