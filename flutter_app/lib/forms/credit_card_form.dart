import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/custom_dropdown.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/models/record_base.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreditCardForm extends StatefulWidget {
  final RecordBase<CreditCardRecord>? record;

  const CreditCardForm({super.key, this.record});

  @override
  CreditCardFormState createState() => CreditCardFormState();
}

class CreditCardFormState
    extends FormBaseState<CreditCardForm, RecordBase<CreditCardRecord>> {
  final _formKey = GlobalKey<FormState>();
  bool _submitCalled = false;

  final _itemNameController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _numberController = TextEditingController();
  final _yearController = TextEditingController();
  final _codeController = TextEditingController();

  String? _brand;
  Map<String, String>? _expMonth;
  bool _showNumber = false;
  bool _showCode = false;

  static const List<String> _brands = [
    'Visa',
    'Mastercard',
    'American Express',
    'Discover',
    'Diners Club',
    'JCB',
    'Maestro',
    'UnionPay',
    'Other',
  ];

  static const List<Map<String, String>> _months = [
    {'value': '01', 'title': '01 - January'},
    {'value': '02', 'title': '02 - February'},
    {'value': '03', 'title': '03 - March'},
    {'value': '04', 'title': '04 - April'},
    {'value': '05', 'title': '05 - May'},
    {'value': '06', 'title': '06 - June'},
    {'value': '07', 'title': '07 - July'},
    {'value': '08', 'title': '08 - August'},
    {'value': '09', 'title': '09 - September'},
    {'value': '10', 'title': '10 - October'},
    {'value': '11', 'title': '11 - November'},
    {'value': '12', 'title': '12 - December'},
  ];

  final _brandItems = List<ListItemModel>.generate(
    _brands.length,
    (i) => ListItemModel(
      _brands[i],
      PhosphorIcons.cardholder(PhosphorIconsStyle.thin),
      null,
      (ctx) {
        Navigator.pop(ctx, _brands[i]);
      },
      _brands[i],
    ),
  );

  final _monthsItems = List<ListItemModel>.generate(
    _months.length,
    (i) => ListItemModel(
      _months[i]['title']!,
      PhosphorIcons.calendar(PhosphorIconsStyle.thin),
      null,
      (ctx) {
        Navigator.pop(ctx, _months[i]);
      },
      _months[i]['value']!,
    ),
  );

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
      _itemNameController.text = record.itemName;
      _cardholderController.text = record.data.name;
      _codeController.text = record.data.cvv;
      _numberController.text = record.data.number;
      _yearController.text = record.data.expYear;

      setState(() {
        _brand = record.data.brand;
        _expMonth = _months
            .where((map) => map['value'] == record.data.expMonth)
            .firstOrNull;
      });

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
  void dispose() {
    _itemNameController.dispose();
    _cardholderController.dispose();
    _numberController.dispose();
    _yearController.dispose();
    _codeController.dispose();
    super.dispose();
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
            controller: _itemNameController,
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

          SizedBox(height: 24),

          // Card details header
          SectionHeader(title: 'CARD DETAILS'),
          SizedBox(height: 8),

          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            controller: _cardholderController,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              prefixIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.thin)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(PhosphorIcons.copy(PhosphorIconsStyle.thin)),
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _cardholderController.text),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Note copied to clipboard')),
                      );
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
          SizedBox(height: 16),

          // Number with eye
          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            controller: _numberController,
            decoration: InputDecoration(
              labelText: 'Card Number',
              prefixIcon: Icon(
                PhosphorIcons.creditCard(PhosphorIconsStyle.thin),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(PhosphorIcons.copy(PhosphorIconsStyle.thin)),
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _numberController.text),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Note copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _showNumber
                          ? PhosphorIcons.eye(PhosphorIconsStyle.thin)
                          : PhosphorIcons.eyeSlash(PhosphorIconsStyle.thin),
                    ),
                    onPressed: () => setState(() => _showNumber = !_showNumber),
                  ),
                ],
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _requiredValidator,
            obscureText: !_showNumber,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),

          const SizedBox(height: 16),

          CustomDropdown<String>(
            value: _brand ?? '',
            options: _brandItems,
            onChanged: (selected) {
              setState(() {
                _brand = selected;
              });

              if (_submitCalled) _formKey.currentState!.validate();
            },
            title: 'Brand',
            icon: PhosphorIcons.cardholder(PhosphorIconsStyle.thin),
            validator: _requiredValidator,
          ),

          const SizedBox(height: 16),

          CustomDropdown<Map<String, String>>(
            value: _expMonth?['title'] ?? '',
            options: _monthsItems,
            onChanged: (selected) {
              setState(() {
                _expMonth = selected;
              });

              if (_submitCalled) _formKey.currentState!.validate();
            },
            title: 'Expiration Month',
            icon: PhosphorIcons.calendar(PhosphorIconsStyle.thin),
            validator: _requiredValidator,
          ),

          const SizedBox(height: 16),

          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            controller: _yearController,
            decoration: InputDecoration(
              labelText: 'Expiration Year',
              prefixIcon: Icon(
                PhosphorIcons.calendarBlank(PhosphorIconsStyle.thin),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _requiredValidator,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            controller: _codeController,
            decoration: InputDecoration(
              labelText: 'Security Code',
              prefixIcon: Icon(
                PhosphorIcons.lockSimple(PhosphorIconsStyle.thin),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(PhosphorIcons.copy(PhosphorIconsStyle.thin)),
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _codeController.text),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Note copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _showCode
                          ? PhosphorIcons.eye(PhosphorIconsStyle.thin)
                          : PhosphorIcons.eyeSlash(PhosphorIconsStyle.thin),
                    ),
                    onPressed: () => setState(() => _showCode = !_showCode),
                  ),
                ],
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _requiredValidator,
            obscureText: !_showCode,
            onChanged: (_) {
              if (_submitCalled) _formKey.currentState!.validate();
            },
          ),
        ],
      ),
    );
  }

  @override
  RecordBase<CreditCardRecord> getFormData() {
    return RecordBase<CreditCardRecord>(
      data: CreditCardRecord(
        name: _cardholderController.text,
        number: _numberController.text,
        brand: _brand!,
        expMonth: _expMonth?['value'] ?? '',
        expYear: _yearController.text,
        cvv: _codeController.text,
      ),
      itemName: _itemNameController.text,
      folder: selectedFolder?.id,
      icon: null,
      isTrashed: widget.record?.isTrashed ?? false,
    );
  }

  @override
  bool validate() {
    _submitCalled = true;
    return _formKey.currentState?.validate() ?? false;
  }
}
