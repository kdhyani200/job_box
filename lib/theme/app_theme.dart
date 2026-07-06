import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color azure = Color(0xFF0078D4); // Azure blue
  static const Color azureDark = Color(0xFF2B98E0); // lighter azure for dark bg
  static const Color navy = Color(0xFF0B1E33); // deep navy for dark surfaces
  static const Color navySurface = Color(0xFF122A45); // dark cards/surfaces

  // Status colors (kept semantic across both themes)
  static const Color statusApplied = azure;
  static const Color statusInterviewing = Color(0xFFF59E0B); // amber
  static const Color statusOffered = Color(0xFF2E7D32); // green
  static const Color statusRejected = Color(0xFFD32F2F); // red9811073812
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.azure,
      brightness: Brightness.light,
      primary: AppColors.azure,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.azure,
      dividerColor: Colors.grey.shade300,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.azure,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.azure,
        foregroundColor: Colors.white,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.azure,
          foregroundColor: Colors.white,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.azure,
          side: const BorderSide(color: AppColors.azure),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(focusColor: AppColors.azure),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.azure,
      brightness: Brightness.dark,
      primary: AppColors.azureDark,
      surface: AppColors.navySurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.navy,
      primaryColor: AppColors.azureDark,
      dividerColor: Colors.white24,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: AppColors.navySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white24),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.azureDark,
        foregroundColor: Colors.white,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.azureDark,
          foregroundColor: Colors.white,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.azureDark,
          side: const BorderSide(color: AppColors.azureDark),
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        focusColor: AppColors.azureDark,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }
}
