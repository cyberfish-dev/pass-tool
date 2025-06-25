import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/custom_dropdown.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoteForm extends StatefulWidget {
  final RecordBase<SecureNoteRecord>? record;
  const NoteForm({super.key, this.record});

  @override
  NoteFormState createState() => NoteFormState();
}

class NoteFormState
    extends FormBaseState<NoteForm, RecordBase<SecureNoteRecord>> {
  final _formKey = GlobalKey<FormState>();
  bool _submitCalled = false;
  bool _obscureNote = false;

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

    final record = widget.record;
    if (record != null) {

      setState(() {
        _obscureNote = true;
      });
      
      _itemNameCtrl.text = record.itemName;
      _noteCtrl.text = record.data.note;

      if (record.folder != null) {
        final listFolderItem = folders
            .where((f) => f.id == record.folder)
            .firstOrNull;
        if (listFolderItem != null) {
          setState(() {
            selectedFolder = Folder(
              id: listFolderItem.id,
              name: listFolderItem.title,
            );
          });
        }
      }
    }
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
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            controller: _itemNameCtrl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Item name',
              prefixIcon: Icon(PhosphorIcons.record(PhosphorIconsStyle.thin)),
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

          _obscureNote
              ? TextFormField(
                  controller: TextEditingController(
                    text: '•' * _noteCtrl.text.length,
                  ),
                  readOnly: true,
                  maxLines: 10,
                  minLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Secure Note',
                    prefixIcon: Icon(
                      PhosphorIcons.note(PhosphorIconsStyle.thin),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            PhosphorIcons.copy(PhosphorIconsStyle.thin),
                          ),
                          tooltip: 'Copy',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _noteCtrl.text),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Note copied to clipboard'),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            PhosphorIcons.eyeSlash(PhosphorIconsStyle.thin),
                          ),
                          tooltip: 'Show',
                          onPressed: () => setState(() => _obscureNote = !_obscureNote),
                        ),
                      ],
                    ),
                  ),
                )
              : TextFormField(
                  controller: _noteCtrl,
                  maxLines: 10,
                  minLines: 3,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: 'Secure Note',
                    prefixIcon: Icon(
                      PhosphorIcons.note(PhosphorIconsStyle.thin),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            PhosphorIcons.copy(PhosphorIconsStyle.thin),
                          ),
                          tooltip: 'Copy',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _noteCtrl.text),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Note copied to clipboard'),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            PhosphorIcons.eyeSlash(PhosphorIconsStyle.thin),
                          ),
                          tooltip: 'Show',
                          onPressed: () => setState(() => _obscureNote = !_obscureNote),
                        ),
                      ],
                    ),
                  ),
                  validator: _requiredValidator,
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
    // TODO: handle icons and trash
    return RecordBase<SecureNoteRecord>(
      data: SecureNoteRecord(note: _noteCtrl.text),
      itemName: _itemNameCtrl.text,
      folder: selectedFolder?.id,
      icon: null,
      isTrashed: false,
    );
  }

  @override
  bool validate() {
    _submitCalled = true;
    return _formKey.currentState?.validate() ?? false;
  }
}
