import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_menu.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String? value;
  final String title;
  final IconData icon;
  final List<ListItemModel> options;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.title,
    required this.icon,
    required this.validator,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.text = widget.value ?? '';
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (widget.options.isEmpty) return;

    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final inputWidth = renderBox.size.width;

    final selected = await showCustomMenu<T>(
      context,
      _fieldKey,
      widget.options,
      inputWidth,
    );

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      readOnly: true,
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.title,
        prefixIcon: Icon(widget.icon),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.trashSimple(PhosphorIconsStyle.thin)),
              onPressed: () => widget.onChanged(null),
            ),
            IconButton(
              icon: Icon(PhosphorIcons.caretDown(PhosphorIconsStyle.thin)),
              onPressed: _onTap,
            ),
          ],
        ),
      ),
      onTap: _onTap,
      showCursor: false,
      enableInteractiveSelection: false,
      validator: widget.validator,
    );
  }
}
