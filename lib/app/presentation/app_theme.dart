import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0F766E),
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF4F7F6),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
