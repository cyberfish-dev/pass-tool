import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/credit_card_add.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class CreditAddAction
    extends BottomSheetAction<String, AddCreditCardFormState> {
  CreditAddAction()
    : super(
        title: 'Create Credit Card',
        formKey: GlobalKey<AddCreditCardFormState>(),
      );

  @override
  Widget buildBody(BuildContext context, String? data) {
    return AddCreditCardForm(key: formKey);
  }

  @override
  void onAction(String? id, BuildContext context, String data) {}

  @override
  String? fetchData(VaultMetadataEntry? entry) {
    return null;
  }
}
