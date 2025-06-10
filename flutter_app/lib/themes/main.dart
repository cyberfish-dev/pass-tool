import 'package:flutter/material.dart';
import 'package:flutter_app/themes/colors.dart';
import 'package:flutter_app/themes/texts.dart';

final baseTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.light(
    primary: accent,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
);

final darkTeme = ThemeData.dark().copyWith(
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    elevation: 0,
  ),
  splashFactory: NoSplash.splashFactory,
  splashColor: Colors.transparent,
  scaffoldBackgroundColor: darkBg,
  colorScheme: ColorScheme.dark(
    primary: accent,
    surface: darkCard,
    onSurface: textPrimary,
    secondary: accent,
  ),
  iconTheme: const IconThemeData(color: textSecondary),
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
    backgroundColor: darkCard,
    selectedItemColor: accent,
    unselectedItemColor: textSecondary,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: darkCard,
    foregroundColor: accent,
    elevation: 25,
  ),
);
