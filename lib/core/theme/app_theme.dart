import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _lightPrimary = Color(0xFF4F46E5);
  static const _lightSecondary = Color(0xFF0EA5E9);
  static const _lightBackground = Color(0xFFF4F6FA);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightDivider = Color(0xFFE7EAF0);

  static const _darkPrimary = Color(0xFF8B8CF8);
  static const _darkSecondary = Color(0xFF22D3EE);
  static const _darkBackground = Color(0xFF0B0E12);
  static const _darkSurface = Color(0xFF12161A);
  static const _darkDivider = Color(0xFF242A30);

  static ThemeData lightTheme(TextTheme textTheme) {
    final baseTextTheme = GoogleFonts.interTextTheme(textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _lightPrimary,
        onPrimary: Colors.white,
        secondary: _lightSecondary,
        onSecondary: const Color(0xFF0B0C10),
        background: _lightBackground,
        onBackground: const Color(0xFF14181B),
        surface: _lightSurface,
        onSurface: const Color(0xFF14181B),
        error: const Color(0xFFEF4444),
        onError: Colors.white,
        primaryContainer: const Color(0xFF6366F1),
        onPrimaryContainer: Colors.white,
        secondaryContainer: const Color(0xFF22D3EE),
        onSecondaryContainer: const Color(0xFF0B0C10),
        surfaceVariant: _lightDivider,
        outline: _lightDivider,
        shadow: Colors.black.withOpacity(.12),
        scrim: Colors.black,
        inversePrimary: _lightSecondary,
        tertiary: const Color(0xFF22D3EE),
        onTertiary: const Color(0xFF0B0C10),
        errorContainer: const Color(0xFFF59E0B),
        onErrorContainer: const Color(0xFF0B0C10),
      ),
      scaffoldBackgroundColor: _lightBackground,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      cardTheme: CardTheme(
        color: _lightSurface.withOpacity(.92),
        elevation: 0,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF14181B),
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dividerColor: _lightDivider,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lightPrimary, width: 1.6),
        ),
        fillColor: Colors.white.withOpacity(.92),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: const BorderSide(color: _lightPrimary),
        ),
      ),
    );
  }

  static ThemeData darkTheme(TextTheme textTheme) {
    final baseTextTheme = GoogleFonts.cairoTextTheme(textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: _darkPrimary,
        onPrimary: const Color(0xFF0B0C10),
        secondary: _darkSecondary,
        onSecondary: const Color(0xFF0B0C10),
        background: _darkBackground,
        onBackground: const Color(0xFFEDEFF2),
        surface: _darkSurface,
        onSurface: const Color(0xFFEDEFF2),
        error: const Color(0xFFFF6B6B),
        onError: const Color(0xFF0B0C10),
        primaryContainer: const Color(0xFF6366F1),
        onPrimaryContainer: Colors.white,
        secondaryContainer: const Color(0xFF67E8F9),
        onSecondaryContainer: const Color(0xFF0B0C10),
        surfaceVariant: _darkDivider,
        outline: _darkDivider,
        shadow: Colors.black.withOpacity(.4),
        scrim: Colors.black,
        inversePrimary: _darkSecondary,
        tertiary: const Color(0xFF22D3EE),
        onTertiary: const Color(0xFF0B0C10),
        errorContainer: const Color(0xFFF59E0B),
        onErrorContainer: const Color(0xFF0B0C10),
      ),
      scaffoldBackgroundColor: _darkBackground,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      cardTheme: CardTheme(
        color: _darkSurface.withOpacity(.9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFEDEFF2),
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: Color(0xFF0B0C10),
        elevation: 4,
      ),
      dividerColor: _darkDivider,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkPrimary, width: 1.6),
        ),
        fillColor: _darkSurface.withOpacity(.92),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: _darkPrimary,
          foregroundColor: const Color(0xFF0B0C10),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: const BorderSide(color: _darkSecondary),
        ),
      ),
    );
  }
}
