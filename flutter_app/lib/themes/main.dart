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
    iconTheme: IconThemeData(color: iconsColor, size: 25),
    titleTextStyle: textTheme.labelLarge,
    centerTitle: false,
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
  iconTheme: IconThemeData(color: iconsColor, size: 25),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkCard,
    hintStyle: textTheme.bodyMedium?.copyWith(
      color: textSecondary.withAlpha(180),
    ),
    labelStyle: textTheme.bodyMedium?.copyWith(
      color: textSecondary.withAlpha(180),
    ),
    prefixIconColor: iconsColor,
    suffixIconColor: iconsColor,
    errorStyle: textTheme.bodySmall?.copyWith(color: errorColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: inputBorderColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: inputBorderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: accent.withAlpha(150), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: errorColor.withAlpha(200), width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: errorColor.withAlpha(200), width: 1),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkMenu,
    selectedItemColor: accent,
    unselectedItemColor: textSecondary,
    elevation: 0,
  ),
  bottomAppBarTheme: BottomAppBarThemeData(color: darkMenu, elevation: 0),
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: darkMenu,
    elevation: 0,
    indicatorColor: textSecondary.withAlpha(50),
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    selectedIconTheme: IconThemeData(color: accent),
    unselectedIconTheme: IconThemeData(color: textSecondary),
    selectedLabelTextStyle: TextStyle(color: accent),
    unselectedLabelTextStyle: TextStyle(color: textSecondary),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkCard,
    foregroundColor: accent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: inputBorderColor, width: 1),
      borderRadius: BorderRadius.circular(16.0),
    ),
  ),
  dividerColor: inputBorderColor,
  shadowColor: darkBg,
  popupMenuTheme: PopupMenuThemeData(
    shadowColor: darkBg,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
  dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
  cardTheme: CardThemeData(
    color: darkCard,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: inputBorderColor, width: 1),
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: darkBg, // Or any color you want
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      side: BorderSide(color: inputBorderColor, width: 1),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(textStyle: textTheme.bodyMedium),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: inputBorderColor, width: 1),
      ),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      return states.any((state) => state == WidgetState.selected)
          ? accent
          : darkBg;
    }),
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.any((state) => state == WidgetState.selected)
          ? textPrimary
          : textSecondary;
    }),
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
);
