import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/login_add.dart';

class LoginAddAction extends BottomSheetAction<String, AddLoginFormState> {
  
  LoginAddAction() : super(title: 'Create Login', formKey: GlobalKey<AddLoginFormState>());

  @override
  Widget buildBody(BuildContext context) {
    return AddLoginForm(key: formKey,);
  }

  @override
  void onAction(BuildContext context, String data) {
    
  }
}
