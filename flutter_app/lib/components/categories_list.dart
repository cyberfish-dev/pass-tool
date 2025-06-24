import 'package:flutter/material.dart';
import 'package:flutter_app/components/list_items.dart';
import 'package:flutter_app/components/section_header.dart';
import 'package:flutter_app/menu/menu_items.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:flutter_app/screens/records_screen.dart';
import 'package:flutter_app/vault/vault_service.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => CategoryListState();
}

class CategoryListState extends State<CategoryList> {
  List<ListItemModel> _categories = [
    ListItemModel(
      'Logins',
      PhosphorIcons.globe(PhosphorIconsStyle.thin),
      null,
      (ctx) {
        Navigator.of(vaultNavigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => RecordsScreen(
              showTrash: false,
              category: EntryCategory.login,
              folderId: null,
              title: 'Logins',
            ),
          ),
        );
      },
      '_login',
    ),
    ListItemModel(
      'Cards',
      PhosphorIcons.creditCard(PhosphorIconsStyle.thin),
      null,
      (ctx) {
        Navigator.of(vaultNavigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => RecordsScreen(
              showTrash: false,
              category: EntryCategory.creditCard,
              folderId: null,
              title: 'Cards',
            ),
          ),
        );
      },
      '_card',
    ),
    ListItemModel(
      'Secure Notes',
      PhosphorIcons.note(PhosphorIconsStyle.thin),
      null,
      (ctx) {
        Navigator.of(vaultNavigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => RecordsScreen(
              showTrash: false,
              category: EntryCategory.secureNote,
              folderId: null,
              title: 'Secure Notes',
            ),
          ),
        );
      },
      '_note',
    ),
    ListItemModel('Trash', PhosphorIcons.trash(PhosphorIconsStyle.thin), null, (
      ctx,
    ) {
      Navigator.of(vaultNavigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => RecordsScreen(
            showTrash: true,
            category: null,
            folderId: null,
            title: 'Trash',
          ),
        ),
      );
    }, '_trash'),
  ];

  final Map<String, EntryCategory> _categoryMap = {
    '_login': EntryCategory.login,
    '_card': EntryCategory.creditCard,
    '_note': EntryCategory.secureNote,
  };

  void update() {
    final metadata = VaultService.fetchMeta();

    setState(() {
      for (var category in _categories) {
        final categoryKey = category.id;
        if (_categoryMap.containsKey(categoryKey)) {
          final entryCategory = _categoryMap[categoryKey]!;

          final rawCount =
              metadata.categoryCounts[entryCategory] ?? BigInt.zero;
          final count = rawCount.toInt();

          category.count = count;
        }

        if (category.id == '_trash') {
          final rawCount = metadata.trashedCount;
          category.count = rawCount.toInt();
        }
      }

      _categories = List<ListItemModel>.from(_categories);
    });
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
        SectionHeader(title: 'TYPES', count: _categories.length),
        ListItems(items: _categories),
      ],
    );
  }
}
