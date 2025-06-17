import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/credit_card_add.dart';

class CreditAddAction
    extends BottomSheetAction<String, AddCreditCardFormState> {
  CreditAddAction()
    : super(
        title: 'Create Credit Card',
        formKey: GlobalKey<AddCreditCardFormState>(),
      );

  @override
  Widget buildBody(BuildContext context) {
    return AddCreditCardForm(key: formKey);
  }

  @override
  void onAction(BuildContext context, String data) {}
}
