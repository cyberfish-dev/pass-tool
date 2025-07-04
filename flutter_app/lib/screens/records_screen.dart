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
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Search field
                TextField(
                  controller: _searchController,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
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
                              _searchController.clear();
                            },
                          )
                        : null,
                  ),
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

          // Floating back button
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              heroTag: 'backButton',
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular)),
            ),
          ),
        ],
      ),
    );
  }
}
