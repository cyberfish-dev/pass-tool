import 'package:flutter/material.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddFolderForm extends StatefulWidget {
  const AddFolderForm({super.key});

  @override
  AddFolderFormState createState() => AddFolderFormState();
}

class AddFolderFormState extends FormBaseState<AddFolderForm, String> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  bool validate() => _formKey.currentState?.validate() ?? false;

  @override
  String getFormData() => _controller.text.trim();

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Folder name is required.';
    }
    if (value.trim().length < 3) {
      return 'Must be at least 3 characters.';
    }
    if (value.trim().length > 50) {
      return 'Must be less than 50 characters.';
    }
    final invalidChars = RegExp(r'[\\/:*?"<>|]');
    if (invalidChars.hasMatch(value)) {
      return 'Contains invalid characters.';
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Folder Name',
                prefixIcon: Icon(
                  PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
                  size: 20,
                ),
              ),
              validator: _validateName,
              onChanged: (_) => { validate() },
            ),
          ],
        ),
      ),
    );
  }
}
