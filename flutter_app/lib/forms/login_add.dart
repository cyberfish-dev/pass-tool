import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_dropdown.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/folder_model.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:flutter_app/preferences/password_prefs.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddLoginForm extends StatefulWidget {
  const AddLoginForm({super.key});

  @override
  AddLoginFormState createState() => AddLoginFormState();
}

class AddLoginFormState extends FormBaseState<AddLoginForm, String> {
  late PasswordPrefs _prefs;

  final _formKey = GlobalKey<FormState>();
  bool _submitCalled = false;

  // Controllers
  final _itemNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authKeyCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

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
  void initState() {
    super.initState();
    initFolders();

    PasswordPrefs.loadPrefs().then((p) {
      setState(() {
        _prefs = p;
      });
      _generatePassword();
    });
  }

  void _generatePassword() {
    final password = generatePassword(
      includeDigits: _prefs.useDigits,
      includeLower: _prefs.useLower,
      includeSymbols: _prefs.useSymbols,
      includeUpper: _prefs.useUpper,
      length: BigInt.from(_prefs.length.toInt()),
      minDigits: BigInt.from(_prefs.minDigits),
      minSymbols: BigInt.from(_prefs.minSymbols),
    );

    setState(() {
      _passwordCtrl.text = password;
    });
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

          SizedBox(height: 24),

          // LOGIN CREDENTIALS
          SectionHeader(title: 'LOGIN CREDENTIALS'),
          SizedBox(height: 8),

          // Username
          TextFormField(
            controller: _usernameCtrl,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(
                PhosphorIcons.user(PhosphorIconsStyle.thin),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.thin),
                  size: 20,
                ),
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
              labelText: 'Password',
              prefixIcon: Icon(
                PhosphorIcons.password(PhosphorIconsStyle.thin),
                size: 20,
              ),
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
                    icon: Icon(
                      PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.thin),
                      size: 20,
                    ),
                    onPressed: () {
                      _generatePassword();
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

          SizedBox(height: 24),

          // AUTHENTICATOR KEY
          SectionHeader(title: 'AUTHENTICATOR KEY'),
          SizedBox(height: 8),

          TextFormField(
            controller: _authKeyCtrl,
            obscureText: _obscureAuthKey,
            decoration: InputDecoration(
              labelText: 'Authenticator key',
              prefixIcon: Icon(
                PhosphorIcons.lockSimple(PhosphorIconsStyle.thin),
                size: 20,
              ),
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
            icon: Icon(
              PhosphorIcons.camera(PhosphorIconsStyle.duotone),
              size: 20,
            ),
            label: Text('Set up authenticator key'),
          ),

          SizedBox(height: 24),

          SectionHeader(title: 'AUTOFILL OPTIONS'),
          SizedBox(height: 8),

          TextFormField(
            controller: _websiteCtrl,
            decoration: InputDecoration(
              labelText: 'Website (URI)',
              prefixIcon: Icon(
                PhosphorIcons.globe(PhosphorIconsStyle.thin),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  PhosphorIcons.gear(PhosphorIconsStyle.thin),
                  size: 20,
                ),
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
    return '';
  }

  @override
  bool validate() {
    _submitCalled = true;
    return _formKey.currentState?.validate() ?? false;
  }
}
