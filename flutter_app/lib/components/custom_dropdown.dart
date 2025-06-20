import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_menu.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDropdown<T> extends StatelessWidget {
  final GlobalKey _fieldKey = GlobalKey();

  final String? value;
  final String title;
  final IconData icon;
  final List<ListItemModel> options;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<String>? validator;

  CustomDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.title,
    required this.icon,
    required this.validator,
  });

  _onTap(BuildContext context) async {
    if (options.isEmpty) {
      return;
    }

    final box = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final inputWidth = box.size.width;

    final selected = await showCustomMenu<T>(
      context,
      _fieldKey,
      options,
      inputWidth,
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(icon),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.trashSimple(PhosphorIconsStyle.thin)),
              onPressed: () => onChanged(null),
            ),
            IconButton(
              icon: Icon(PhosphorIcons.caretDown(PhosphorIconsStyle.thin)),
              onPressed: () async{
                await _onTap(context);
              },
            ),
          ],
        ),
      ),
      onTap: () async {
        await _onTap(context);
      },
      showCursor: false,
      enableInteractiveSelection: false,
      canRequestFocus: false,
      validator: validator,
    );
  }
}
