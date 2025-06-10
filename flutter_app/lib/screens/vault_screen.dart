import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/menu/category_items.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  String _searchText = '';

  final List<ListItemModel> _folders = [
    ListItemModel(
      'Test',
      PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
      1,
      (ctx) => {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const SizedBox(height: 12),

          // Search field
          TextField(
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search',
              prefixIcon: Icon(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.thin),
                size: 20,
              ),
            ),
            onChanged: (v) => setState(() => _searchText = v),
          ),

          const SizedBox(height: 24),

          // Content list
          Expanded(
            child: ListView(
              children: [
                SectionHeader(title: 'TYPES', count: categories.length),
                ListItems(items: categories),

                const SizedBox(height: 24),

                SectionHeader(title: 'FOLDERS', count: _folders.length),
                if (_folders.isNotEmpty) ListItems(items: _folders),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
