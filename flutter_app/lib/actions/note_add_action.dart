import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_bottom_sheet.dart';
import 'package:flutter_app/forms/note_add.dart';

class NoteAddAction extends BottomSheetAction<String, AddNoteFormState> {
  
  NoteAddAction() : super(title: 'Create Secure Note', formKey: GlobalKey<AddNoteFormState>());

  @override
  Widget buildBody(BuildContext context) {
    return AddNoteForm(key: formKey,);
  }

  @override
  void onAction(BuildContext context, String data) {
    
  }
}
