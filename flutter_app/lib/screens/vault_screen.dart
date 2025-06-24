import 'package:flutter/material.dart';
import 'package:flutter_app/components/categories_list.dart';
import 'package:flutter_app/components/folder_list.dart';
import 'package:flutter_app/components/records_list.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

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
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search',
              prefixIcon: Icon(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.thin),
              ),
              isDense: true,
              suffixIcon: _searchText.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        PhosphorIcons.x(PhosphorIconsStyle.thin),
                      ),
                      onPressed: () {
                        setState(() => _searchController.clear());
                      },
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          // Content list
          Expanded(
            child: _searchText.isNotEmpty
                ? RecordsList(
                    key: ScreenUpdater.noFolderListGlobalKey,
                    searchText: _searchText,
                    showTrash: false,
                    category: null,
                    folderId: null,
                    title: 'ALL RECORDS',
                    hasNoFolder: false,
                  )
                : ListView(
                    children: [
                      CategoryList(key: ScreenUpdater.categoryListGlobalKey),
                      const SizedBox(height: 24),

                      FolderList(key: ScreenUpdater.folderListGlobalKey),
                      RecordsList(
                        key: ScreenUpdater.noFolderListGlobalKey,
                        searchText: _searchText,
                        showTrash: false,
                        category: null,
                        folderId: null,
                        title: 'NO FOLDER',
                        hasNoFolder: true,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
