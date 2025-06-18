import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_dropdown.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/folder_model.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/store/store_facade.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  AddNoteFormState createState() => AddNoteFormState();
}

class AddNoteFormState extends FormBaseState<AddNoteForm, String> {
  late final store = StoreFacade();

  final _formKey = GlobalKey<FormState>();
  bool _submitCalled = false;

  // Controllers
  final _itemNameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  // Dropdown
  FolderModel? _selectedFolder;
  List<ListItemModel> _folders = [];

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

  void initFolders() {
    setState(() {
      _folders = store
          .listFolders()
          .map(
            (el) => ListItemModel(
              el.name,
              PhosphorIcons.folderSimple(PhosphorIconsStyle.thin),
              null,
              (ctx) {
                Navigator.pop(ctx, el);
              },
              el.id,
            ),
          )
          .toList();
    });
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
                size: 20,
              ),
            ),
            validator: _requiredValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),

          SizedBox(height: 16),

          // Folder dropdown
          CustomDropdown<FolderModel>(
            value: _selectedFolder?.name ?? 'No Folder',
            options: _folders,
            onChanged: (selected) {
              setState(() {
                _selectedFolder = selected;
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
                size: 20,
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
  String getFormData() {
    return '';
  }

  @override
  bool validate() {
    _submitCalled = true;
    return _formKey.currentState?.validate() ?? false;
  }
}
