import 'package:flutter/material.dart';
import 'package:flutter_app/components/records_list.dart';
import 'package:flutter_app/updater/screen_updater.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecordsScreen extends StatefulWidget {
  final bool showTrash;
  final EntryCategory? category;
  final String? folderId;
  final String title;

  const RecordsScreen({
    super.key,
    required this.showTrash,
    this.category,
    this.folderId, 
    required this.title,
  });

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title
        ),),
      body: Padding(
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
                ),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
      
            const SizedBox(height: 24),
      
            // Content list
            Expanded(
              child: ListView(
                children: [
                  RecordsList(
                    key: ScreenUpdater.recordsGlobalKey,
                    searchText: _searchText,
                    showTrash: widget.showTrash,
                    category: widget.category,
                    folderId: widget.folderId,
                    title: widget.title,
                    hasNoFolder: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
