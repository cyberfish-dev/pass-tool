import 'package:flutter/material.dart';

class ColoredPassword extends StatelessWidget {
  final String password;
  const ColoredPassword(this.password, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 18,
      color: theme.colorScheme.onSurface,
    );

    // helper to pick a color based on char type
    Color spanColor(String char) {
      if (RegExp(r'\d').hasMatch(char)) {
        return Colors.purpleAccent;            // digits
      } else if (RegExp(r'[!@#\$%\^&\*\(\)\-_=+\[\]\{\};:,.<>\/\?|]').hasMatch(char)) {
        return Colors.greenAccent;          // symbols
      } else if (RegExp(r'[A-Z]').hasMatch(char)) {
        return theme.colorScheme.onSurface;           // uppercase
      } else {
        return theme.colorScheme.onSurface.withAlpha(180);  // lowercase (or default)
      }
    }

    // build a span for each character
    final spans = password.characters.map((c) {
      return TextSpan(
        text: c,
        style: textStyle.copyWith(color: spanColor(c)),
      );
    }).toList();

    return RichText(
      text: TextSpan(children: spans),
      overflow: TextOverflow.visible,
    );
  }
}
