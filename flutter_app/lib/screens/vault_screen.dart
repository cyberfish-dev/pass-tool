import 'package:flutter/material.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  String _searchText = '';

  final List<_Category> _categories = [
    _Category('Logins', Icons.language_outlined, 80),
    _Category('Cards', Icons.credit_card_outlined, 0),
    _Category('Identity', Icons.account_box_outlined, 0),
    _Category('Secure Notes', Icons.sticky_note_2_outlined, 0),
    _Category('SSH Keys', Icons.key_outlined, 0),
  ];

  final List<String> _folders = ['Test'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surfaceVariant;
    final textColor = theme.colorScheme.onSurfaceVariant;

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
              prefixIcon: const Icon(Icons.search),
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
                      return _ItemRow(
                        icon: cat.icon,
                        title: cat.title,
                        count: cat.count,
                        textColor: textColor,
                        onTap: () {
                          // TODO: Navigate to category screen
                        },
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
                        return _ItemRow(
                          icon: Icons.folder_open,
                          title: folder,
                          count: 0,
                          textColor: textColor,
                          onTap: () {
                            // TODO: Navigate to folder contents
                          },
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
  final VoidCallback onTap;

  const _ItemRow({
    required this.icon,
    required this.title,
    required this.count,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: textColor),
              ),
            ),
            Text(
              count.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  final String title;
  final IconData icon;
  final int count;
  const _Category(this.title, this.icon, this.count);
}
