import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  String _searchText = '';

  final List<_Category> _categories = [
    _Category('Logins', PhosphorIcons.globe(PhosphorIconsStyle.thin), 80),
    _Category('Cards', PhosphorIcons.creditCard(PhosphorIconsStyle.thin), 0),
    _Category(
      'Identity',
      PhosphorIcons.identificationCard(PhosphorIconsStyle.thin),
      0,
    ),
    _Category('Secure Notes', PhosphorIcons.note(PhosphorIconsStyle.thin), 0),
    _Category('SSH Keys', PhosphorIcons.key(PhosphorIconsStyle.thin), 0),
  ];

  final List<String> _folders = ['Test'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surfaceVariant;
    final textColor = theme.colorScheme.onSurfaceVariant;
    final iconColor = theme.iconTheme.color ?? Colors.white;

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
              hintText: 'Search',
              prefixIcon: Icon(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.thin),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              border: OutlineInputBorder(
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
                // TYPES section
                _SectionHeader(title: 'TYPES', count: _categories.length),
                Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: _categories.map((cat) {
                      var isLast = _categories.last == cat;
                      return _ItemRow(
                        icon: cat.icon,
                        title: cat.title,
                        count: cat.count,
                        textColor: textColor,
                        iconColor: iconColor,
                        onTap: () {
                          // TODO: Navigate to category screen
                        },
                        isLast: isLast,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // FOLDERS section
                _SectionHeader(title: 'FOLDERS', count: _folders.length),
                if (_folders.isNotEmpty)
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: _folders.map((folder) {
                        var isLast = _folders.last == folder;
                        return _ItemRow(
                          icon: PhosphorIcons.folderOpen(
                            PhosphorIconsStyle.thin,
                          ),
                          title: folder,
                          count: 0,
                          textColor: textColor,
                          iconColor: iconColor,
                          onTap: () {
                            // TODO: Navigate to folder contents
                          },
                          isLast: isLast,
                        );
                      }).toList(),
                    ),
                  ),

                // If you later want an "Uncategorized" section, insert here.
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header widget, e.g. "TYPES (5)"
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('$title (${count.toString()})', style: style),
    );
  }
}

/// A single row item with icon, title, and trailing count.
class _ItemRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isLast;

  const _ItemRow({
    required this.icon,
    required this.title,
    required this.count,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: iconColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: textColor),
                      ),
                    ),
                    Text(
                      count.toString(),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: iconColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: iconColor.withAlpha(20),
                  thickness: 1,
                  height: 1,
                  indent: 45,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Category {
  final String title;
  final IconData icon;
  final int count;
  const _Category(this.title, this.icon, this.count);
}
