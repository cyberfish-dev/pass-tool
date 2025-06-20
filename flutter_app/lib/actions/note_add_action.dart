import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/note_add.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class NoteAddAction
    extends BottomSheetAction<RecordBase<SecureNoteRecord>, AddNoteFormState> {
  NoteAddAction()
    : super(
        title: 'Create Secure Note',
        formKey: GlobalKey<AddNoteFormState>(),
      );

  @override
  Widget buildBody(BuildContext context) {
    return AddNoteForm(key: formKey);
  }

  @override
  void onAction(BuildContext context, RecordBase<SecureNoteRecord> data) {
    VaultService.addSecureNote(data);

    Navigator.pop(context);
    
    ScreenUpdater.updateFolderList();
    ScreenUpdater.updateCategoryList();
    ScreenUpdater.updateNoFolderList();
  }
}
