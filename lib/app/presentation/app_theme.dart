import 'package:flutter/material.dart';

import 'package:artisan_hr/app/presentation/app_brand.dart';

ThemeData buildAppTheme() => _buildTheme(_lightColorScheme);

ThemeData buildDarkAppTheme() => _buildTheme(_darkColorScheme);

ThemeData _buildTheme(ColorScheme colorScheme) {
  final isDark = colorScheme.brightness == Brightness.dark;

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    brightness: colorScheme.brightness,
    scaffoldBackgroundColor: isDark
        ? AppBrandPalette.night
        : AppBrandPalette.mist,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? colorScheme.surface : AppBrandPalette.ink,
      contentTextStyle: TextStyle(
        color: isDark ? colorScheme.onSurface : Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surface,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.error, width: 1.6),
      ),
      filled: true,
      fillColor: isDark ? AppBrandPalette.nightCard : const Color(0xFFFCFEFD),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.outlineVariant,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      height: 78,
      indicatorColor: colorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        );
      }),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    dividerColor: colorScheme.outlineVariant,
  );
}

const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppBrandPalette.deepTeal,
  onPrimary: Colors.white,
  primaryContainer: AppBrandPalette.softMint,
  onPrimaryContainer: AppBrandPalette.darkTeal,
  secondary: AppBrandPalette.richTeal,
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFD6F1E7),
  onSecondaryContainer: AppBrandPalette.darkTeal,
  tertiary: Color(0xFF7FCDB2),
  onTertiary: AppBrandPalette.ink,
  tertiaryContainer: Color(0xFFE7F8F1),
  onTertiaryContainer: AppBrandPalette.darkTeal,
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Colors.white,
  onSurface: AppBrandPalette.ink,
  onSurfaceVariant: Color(0xFF4E635C),
  outline: Color(0xFF98AEA6),
  outlineVariant: Color(0xFFD4E4DD),
  shadow: Color(0x1A000000),
  scrim: Color(0x66000000),
  inverseSurface: AppBrandPalette.ink,
  onInverseSurface: AppBrandPalette.mist,
  inversePrimary: AppBrandPalette.mint,
  surfaceTint: AppBrandPalette.deepTeal,
);

const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppBrandPalette.mint,
  onPrimary: AppBrandPalette.darkTeal,
  primaryContainer: Color(0xFF184D3F),
  onPrimaryContainer: Color(0xFFD8F7EA),
  secondary: Color(0xFF7ED6B5),
  onSecondary: AppBrandPalette.darkTeal,
  secondaryContainer: Color(0xFF173D32),
  onSecondaryContainer: Color(0xFFD7F7EA),
  tertiary: Color(0xFFBDEBD9),
  onTertiary: AppBrandPalette.darkTeal,
  tertiaryContainer: Color(0xFF21463C),
  onTertiaryContainer: Color(0xFFE5FAF2),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: AppBrandPalette.nightCard,
  onSurface: Color(0xFFF3FCF8),
  onSurfaceVariant: Color(0xFFB7CCC4),
  outline: Color(0xFF7E978E),
  outlineVariant: AppBrandPalette.nightOutline,
  shadow: Color(0x66000000),
  scrim: Color(0x99000000),
  inverseSurface: Color(0xFFF3FCF8),
  onInverseSurface: AppBrandPalette.ink,
  inversePrimary: AppBrandPalette.deepTeal,
  surfaceTint: AppBrandPalette.mint,
);
