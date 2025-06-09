import 'package:flutter/material.dart';
import 'package:flutter_app/themes/colors.dart';
import 'package:flutter_app/themes/texts.dart';

final baseeTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.light(
    primary: accent,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
);

final darkTeme = ThemeData.dark().copyWith(
  textTheme: textTheme,
  scaffoldBackgroundColor: darkBg,
  colorScheme: ColorScheme.dark(
    primary: accent,
    surface: darkCard,
    onSurface: textPrimary,
    secondary: accent,
   ),
   iconTheme: const IconThemeData(
    color: whiteDull,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkCard,
    hintStyle: const TextStyle(color: textSecondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkBg,
    selectedItemColor: accent,
    unselectedItemColor: textSecondary,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accent,
    foregroundColor: darkBg,
  ),
);
