import 'package:flutter/material.dart';

class AppColors {
  static const Color navy = Color(0xFF081B2C);
  static const Color navyAlt = Color(0xFF0F2437);
  static const Color panel = Color(0xFF102539);
  static const Color panelAlt = Color(0xFF162E45);
  static const Color emerald = Color(0xFF1DD1A1);
  static const Color emeraldSoft = Color(0xFF1BC98A);
  static const Color cyan = Color(0xFF46D2FF);
  static const Color amber = Color(0xFFE6B863);
  static const Color red = Color(0xFFFF6B6B);
  static const Color border = Color(0xFF254A69);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3C6D9);
  static const Color textMuted = Color(0xFF7E93AB);
}

final ThemeData fleetwatchTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.navy,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.emerald,
    secondary: AppColors.cyan,
    surface: AppColors.panel,
    background: AppColors.navy,
    error: AppColors.red,
  ),
  cardColor: AppColors.panel,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.navyAlt,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: false,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textPrimary),
    displayMedium: TextStyle(color: AppColors.textPrimary),
    displaySmall: TextStyle(color: AppColors.textPrimary),
    headlineLarge: TextStyle(color: AppColors.textPrimary),
    headlineMedium: TextStyle(color: AppColors.textPrimary),
    headlineSmall: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary),
    titleMedium: TextStyle(color: AppColors.textPrimary),
    titleSmall: TextStyle(color: AppColors.textPrimary),
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    bodyMedium: TextStyle(color: AppColors.textPrimary),
    bodySmall: TextStyle(color: AppColors.textPrimary),
    labelLarge: TextStyle(color: AppColors.textPrimary),
    labelMedium: TextStyle(color: AppColors.textPrimary),
    labelSmall: TextStyle(color: AppColors.textPrimary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.panel,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.emerald),
    ),
    labelStyle: const TextStyle(color: AppColors.textSecondary),
    hintStyle: const TextStyle(color: AppColors.textMuted),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.emerald,
      foregroundColor: AppColors.navy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.navyAlt,
    indicatorColor: AppColors.emerald.withOpacity(0.18),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
  ),
  dividerColor: AppColors.border,
);
