import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.grey,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: _textTheme,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 4),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
