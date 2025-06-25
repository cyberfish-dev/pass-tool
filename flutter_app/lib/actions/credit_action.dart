import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/enums/action.dart';
import 'package:flutter_app/forms/credit_card_form.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class CreditAction
    extends
        BottomSheetAction<RecordBase<CreditCardRecord>, CreditCardFormState> {
  final RecordAction action;

  CreditAction(this.action)
    : super(
        title: _getActionTitle(action),
        formKey: GlobalKey<CreditCardFormState>(),
      );

  static String _getActionTitle(RecordAction action) {
    switch (action) {
      case RecordAction.add:
        return 'Create Creadit Card';
      case RecordAction.update:
        return 'Update Credit Card';
    }
  }

  @override
  Widget buildBody(BuildContext context, RecordBase<CreditCardRecord>? record) {
    return CreditCardForm(key: formKey, record: record);
  }

  @override
  void onAction(
    String? id,
    BuildContext context,
    RecordBase<CreditCardRecord> data,
  ) {
    switch (action) {
      case RecordAction.add:
        VaultService.addCreditCard(data);
      case RecordAction.update:
        VaultService.updateCreditCard(id!, data);
    }

    Navigator.pop(context);

    ScreenUpdater.updateFolderList();
    ScreenUpdater.updateCategoryList();
    ScreenUpdater.updateNoFolderList();
    ScreenUpdater.upateRecordsList();
  }

  @override
  RecordBase<CreditCardRecord>? fetchData(VaultMetadataEntry? entry) {
    if (action == RecordAction.update && entry != null) {
      final record = VaultService.getCreditCard(entry.id);
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
