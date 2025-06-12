import 'package:flutter/material.dart';
import 'package:flutter_app/components/folder_list.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/menu/category_items.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  String _searchText = '';

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
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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

                FolderList(key: ScreenUpdater.folderListGlobalKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
