import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/enums/action.dart';
import 'package:flutter_app/forms/login_form.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class LoginAction
    extends BottomSheetAction<RecordBase<LoginRecord>, LoginFormState> {
  final RecordAction action;
  LoginAction(this.action)
    : super(
        title: _getActionTitle(action),
        formKey: GlobalKey<LoginFormState>(),
      );

  @override
  Widget buildBody(BuildContext context, RecordBase<LoginRecord>? data) {
    return LoginForm(key: formKey, record: data);
  }

  static String _getActionTitle(RecordAction action) {
    switch (action) {
      case RecordAction.add:
        return 'Create Login';
      case RecordAction.update:
        return 'Update Login';
    }
  }

  @override
  void onAction(
    String? id,
    BuildContext context,
    RecordBase<LoginRecord> data,
  ) {
    switch (action) {
      case RecordAction.add:
        VaultService.addLogin(data);
      case RecordAction.update:
        VaultService.updateLogin(id!, data);
    }

    Navigator.pop(context);

    ScreenUpdater.updateFolderList();
    ScreenUpdater.updateCategoryList();
    ScreenUpdater.updateNoFolderList();
    ScreenUpdater.upateRecordsList();
  }

  @override
  RecordBase<LoginRecord>? fetchData(VaultMetadataEntry? entry) {
    if (action == RecordAction.update && entry != null) {
      final record = VaultService.getLogin(entry.id);
      return RecordBase(
        itemName: entry.name,
        folder: entry.folder,
        data: record,
        icon: entry.icon,
        isTrashed: entry.isTrashed,
      );
    }

    return null;
  }
}
