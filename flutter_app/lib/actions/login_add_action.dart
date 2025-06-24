import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/login_add.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class LoginAddAction extends BottomSheetAction<String, AddLoginFormState> {
  
  LoginAddAction() : super(title: 'Create Login', formKey: GlobalKey<AddLoginFormState>());

  @override
  Widget buildBody(BuildContext context, String? data) {
    return AddLoginForm(key: formKey,);
  }

  @override
  void onAction(String? id, BuildContext context, String data) { 
  }

  @override
  String? fetchData(VaultMetadataEntry? entry) {
    return null;
  }
}
