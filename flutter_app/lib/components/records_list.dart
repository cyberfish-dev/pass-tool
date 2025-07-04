import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/actions/credit_action.dart';
import 'package:flutter_app/actions/login_action.dart';
import 'package:flutter_app/actions/note_action.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/enums/action.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecordsList extends StatefulWidget {
  final String? searchText;
  final EntryCategory? category;
  final String? folderId;
  final bool showTrash;
  final bool hasNoFolder;
  final String title;

  const RecordsList({
    super.key,
    this.searchText,
    this.category,
    this.folderId,
    required this.showTrash,
    required this.title,
    required this.hasNoFolder,
  });

  @override
  State<RecordsList> createState() => RecordsListState();
}

class RecordsListState extends State<RecordsList> {
  List<ListItemModel> _items = [];
  Timer? _debounce;

  void update() {
    final metadata = VaultService.fetchMeta();

    setState(() {
      final items = metadata.entries.where((item) {
        var result = true;

        if (widget.hasNoFolder) {
          result = result && item.folder == null;
        }

        if (widget.folderId != null) {
          result = result && item.folder == widget.folderId;
        }

        if (widget.category != null) {
          result = result && item.category == widget.category;
        }

        if (widget.showTrash) {
          result = result && item.isTrashed;
        }

        if (!widget.showTrash) {
          result = result && !item.isTrashed;
        }

        if (widget.searchText != null && widget.searchText!.trim().isNotEmpty) {
          final keywords = widget.searchText!
              .toLowerCase()
              .split(RegExp(r'\s+'))
              .where((s) => s.isNotEmpty);

          result =
              result &&
              keywords.every((kw) => item.name.toLowerCase().contains(kw));
        }

        return result;
      }).toList();

      _items = items.map((item) {
        return ListItemModel(item.name, _getIcon(item), null, (ctx) {
          switch (item.category) {
            case EntryCategory.login:
              {
                final action = LoginAction(RecordAction.update);
                action.showCustomBottomSheet(ctx, item);
              }
            case EntryCategory.secureNote:
              {
                final action = NoteAction(RecordAction.update);
                action.showCustomBottomSheet(ctx, item);
              }
            case EntryCategory.creditCard:
              {
                final action = CreditAction(RecordAction.update);
                action.showCustomBottomSheet(ctx, item);
              }
          }
        }, item.id);
      }).toList();
    });
  }

  IconData _getIcon(VaultMetadataEntry entry) {
    if (entry.icon == null) {
      switch (entry.category) {
        case EntryCategory.creditCard:
          return PhosphorIcons.creditCard(PhosphorIconsStyle.thin);
        case EntryCategory.login:
          return PhosphorIcons.globe(PhosphorIconsStyle.thin);
        case EntryCategory.secureNote:
          return PhosphorIcons.note(PhosphorIconsStyle.thin);
      }
    }

    return PhosphorIcons.record(PhosphorIconsStyle.thin);
  }

  @override
  void didUpdateWidget(covariant RecordsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchText != widget.searchText) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 200), () {
        update();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: widget.title, count: _items.length),
        ListItems(items: _items),
      ],
    );
  }
}
