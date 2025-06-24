import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/enums/action.dart';
import 'package:flutter_app/forms/note_form.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class NoteAction
    extends BottomSheetAction<RecordBase<SecureNoteRecord>, NoteFormState> {

  final RecordAction action;

  NoteAction(this.action)
    : super(
        title: _getActionTitle(action),
        formKey: GlobalKey<NoteFormState>(),
      );

  static String _getActionTitle(RecordAction action) {
    switch (action) {
      case RecordAction.add:
        return 'Create Secure Note';
      case RecordAction.update:
        return 'Update Secure Note';
    }
  }

  @override
  Widget buildBody(BuildContext context, RecordBase<SecureNoteRecord>? record) {
    return NoteForm(key: formKey, record: record,);
  }

  @override
  void onAction(String? id, BuildContext context, RecordBase<SecureNoteRecord> data) {
    switch (action) {
      case RecordAction.add:
        VaultService.addSecureNote(data);
      case RecordAction.update:
        VaultService.updateSecureNote(id!, data);
    }

    Navigator.pop(context);

    ScreenUpdater.updateFolderList();
    ScreenUpdater.updateCategoryList();
    ScreenUpdater.updateNoFolderList();
  }
  
  @override
  RecordBase<SecureNoteRecord>? fetchData(VaultMetadataEntry? entry) {
   
   if (action == RecordAction.update && entry != null) {
    final record = VaultService.getSecureNote(entry.id);
    return RecordBase(itemName: entry.name, folder: entry.folder, data: record, icon: entry.icon, isTrashed: entry.isTrashed);
   }
   
   return null;
  }
}
