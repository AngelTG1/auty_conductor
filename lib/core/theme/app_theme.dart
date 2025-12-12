import 'package:flutter/material.dart';

/// Centralized color palette and theme definitions.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E329D);
  static const Color secondary = Color(0xFF4E8DFF);
  static const Color neutralBackground = Color(0xFFF5F6FA);
}

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      secondary: AppColors.secondary,
    ).copyWith(
      background: AppColors.neutralBackground,
    ),
    scaffoldBackgroundColor: AppColors.neutralBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      secondary: AppColors.secondary,
      brightness: Brightness.dark,
    ),
  );
}
