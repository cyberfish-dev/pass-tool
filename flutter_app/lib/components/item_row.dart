import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;
  final VoidCallback onTap;
  final bool isLast;

  const ItemRow({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (count != null)
                  Text(
                    count.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Row(children: [Expanded(child: Divider(height: 1, indent: 45))]),
      ],
    );
  }
}
