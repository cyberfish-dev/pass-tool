import 'package:flutter/material.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddLoginForm extends StatefulWidget {
  const AddLoginForm({super.key});

  @override
  AddLoginFormState createState() => AddLoginFormState();
}

class AddLoginFormState extends FormBaseState<AddLoginForm, String> {
  final _formKey = GlobalKey<FormState>();
  bool _submitCalled = false;

  // Controllers
  final _itemNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authKeyCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  // Dropdown
  String _selectedFolder = 'No Folder';
  final _folders = ['No Folder', 'Work', 'Personal'];

  // Toggles
  bool _obscurePassword = true;
  bool _obscureAuthKey = true;

  @override
  void dispose() {
    _itemNameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _authKeyCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    return null;
  }

  String? _urlValidator(String? v) {
    if (v == null || v.isEmpty) return null;
    final uri = Uri.tryParse(v);
    if (uri == null || (!uri.hasScheme || !uri.hasAuthority)) {
      return 'Enter a valid URL';
    }
    return null;
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
          SectionHeader(title: 'ITEM DETAILS', count: 0),
          SizedBox(height: 8),
        
          // Item Name
          TextFormField(
            controller: _itemNameCtrl,
            decoration: InputDecoration(
              labelText: 'Item name',
              prefixIcon: Icon(PhosphorIcons.record(PhosphorIconsStyle.thin), size: 20),
            ),
            validator: _requiredValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),
          SizedBox(height: 16),
        
          // Folder dropdown
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Folder',
              prefixIcon: Icon(PhosphorIcons.folderOpen(PhosphorIconsStyle.thin), size: 20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFolder,
                isExpanded: true,
                items: _folders
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedFolder = v!;
                    if (_submitCalled) _formKey.currentState!.validate();
                  });
                },
              ),
            ),
          ),
        
          SizedBox(height: 24),
        
          // LOGIN CREDENTIALS
          SectionHeader(title: 'LOGIN CREDENTIALS', count: 0),
          SizedBox(height: 8),
        
          // Username
          TextFormField(
            controller: _usernameCtrl,
            decoration: InputDecoration(
              hintText: 'Username',
              prefixIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.thin), size: 20),
              suffixIcon: IconButton(
                icon: Icon(PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.thin), size: 20),
                onPressed: () {
                  // generate or suggest username
                },
              ),
            ),
            validator: _requiredValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),
          SizedBox(height: 12),
        
          // Password
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(PhosphorIcons.password(PhosphorIconsStyle.thin), size: 20),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? PhosphorIcons.eye(PhosphorIconsStyle.thin)
                          : PhosphorIcons.eyeSlash(PhosphorIconsStyle.thin),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  IconButton(
                    icon: Icon(PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.thin), size: 20),
                    onPressed: () {
                      // generate password
                    },
                  ),
                ],
              ),
            ),
            validator: _requiredValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),
          SizedBox(height: 8),
        
          // Breach check link
          TextButton(
            onPressed: () {
              // check for breaches
            },
            child: Text('Check password for data breaches'),
          ),
        
          SizedBox(height: 24),
        
          // AUTHENTICATOR KEY
          SectionHeader(title: 'AUTHENTICATOR KEY', count: 0),
          SizedBox(height: 8),
        
          TextFormField(
            controller: _authKeyCtrl,
            obscureText: _obscureAuthKey,
            decoration: InputDecoration(
              hintText: 'Authenticator key',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureAuthKey
                      ? PhosphorIcons.eye(PhosphorIconsStyle.thin)
                      : PhosphorIcons.eyeSlash(PhosphorIconsStyle.thin),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscureAuthKey = !_obscureAuthKey);
                },
              ),
            ),
            onChanged: (_) {},
          ),
          SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              // launch setup flow
            },
            icon: Icon(PhosphorIcons.camera(PhosphorIconsStyle.thin), size: 20),
            label: Text('Set up authenticator key'),
          ),
        
          SizedBox(height: 24),
        
          SizedBox(height: 8),
          SectionHeader(title: 'AUTOFILL OPTIONS', count: 0),
        
          TextFormField(
            controller: _websiteCtrl,
            decoration: InputDecoration(
              hintText: 'Website (URI)',
              prefixIcon: Icon(PhosphorIcons.globe(PhosphorIconsStyle.thin), size: 20),
              suffixIcon: IconButton(
                icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.thin), size: 20),
                onPressed: () {
                  // open domain settings
                },
              ),
            ),
            validator: _urlValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),
        
          SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  String getFormData() {
    // TODO: implement getFormData
    throw UnimplementedError();
  }

  @override
  bool validate() {
    // TODO: implement validate
    throw UnimplementedError();
  }
}
