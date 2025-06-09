import 'package:flutter/material.dart';

const _fontFamily = 'SFProText'; // or 'Roboto', whichever you bundle

final textTheme = Typography.whiteMountainView.copyWith(
  headlineSmall: const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // Semi-bold instead of bold
    color: Colors.white,
  ),
  bodyLarge: const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular weight
    color: Colors.white,
  ),
  bodyMedium: const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300, // Light weight
    color: Colors.white70,
  ),
  labelLarge: const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
    color: Colors.white70,
  ),
);