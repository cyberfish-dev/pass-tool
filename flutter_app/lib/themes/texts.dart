import 'package:flutter/material.dart';
import 'package:flutter_app/themes/colors.dart';

const _fontFamily = 'SFProText'; // or 'Roboto', whichever you bundle

final textTheme = Typography.whiteMountainView.copyWith(
  headlineSmall: TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // Semi-bold instead of bold
    color: textPrimary,
  ),
  bodyLarge: TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular weight
    color: textPrimary,
  ),
  bodyMedium: TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300, // Light weight
    color: textPrimary,
  ),
  labelLarge: TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
    color: textPrimary,
  ),
);
