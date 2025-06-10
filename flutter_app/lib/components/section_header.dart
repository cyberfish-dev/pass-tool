import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const SectionHeader({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 12),
      child: Text('$title (${count.toString()})', style: style),
    );
  }
}
