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
  final ValueChanged<T> onChanged;

  CustomDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: Icon(
          PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: () async {

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
      },
      showCursor: false,
      enableInteractiveSelection: false,
    );
  }
}
