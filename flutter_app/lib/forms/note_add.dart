import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_dropdown.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  AddNoteFormState createState() => AddNoteFormState();
}

class AddNoteFormState
    extends FormBaseState<AddNoteForm, RecordBase<SecureNoteRecord>> {
  final _formKey = GlobalKey<FormState>();
  bool _submitCalled = false;

  // Controllers
  final _itemNameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _itemNameCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    return null;
  }

  @override
  void initState() {
    super.initState();
    initFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _submitCalled
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ITEM DETAILS
          SectionHeader(title: 'ITEM DETAILS'),
          SizedBox(height: 8),

          // Item Name
          TextFormField(
            controller: _itemNameCtrl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Item name',
              prefixIcon: Icon(
                PhosphorIcons.record(PhosphorIconsStyle.thin),
              ),
            ),
            validator: _requiredValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),

          SizedBox(height: 16),

          // Folder dropdown
          CustomDropdown<Folder>(
            value: selectedFolder?.name ?? 'No Folder',
            options: folders,
            onChanged: (selected) {
              setState(() {
                selectedFolder = selected;
              });
            },
            title: 'Folder',
            icon: PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
            validator: (value) => null,
          ),

          SizedBox(height: 16),

          TextFormField(
            controller: _noteCtrl,
            decoration: InputDecoration(
              labelText: 'Secure Note',
              prefixIcon: Icon(
                PhosphorIcons.note(PhosphorIconsStyle.thin),
              ),
            ),
            validator: _requiredValidator,
            maxLines: 10,
            minLines: 3,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),
        ],
      ),
    );
  }

  @override
  RecordBase<SecureNoteRecord> getFormData() {
    // TODO: handle icons
    return RecordBase<SecureNoteRecord>(
      data: SecureNoteRecord(note: _noteCtrl.text),
      itemName: _itemNameCtrl.text,
      folder: selectedFolder?.id,
      icon: null,
    );
  }

  @override
  bool validate() {
    _submitCalled = true;
    return _formKey.currentState?.validate() ?? false;
  }
}
