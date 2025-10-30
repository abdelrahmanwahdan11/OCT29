import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _lightPrimary = Color(0xFF3D5AFE);
  static const Color _lightSecondary = Color(0xFF7C4DFF);
  static const Color _lightBackground = Color(0xFFF8F9FB);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightOnSurface = Color(0xFF1A1D1F);
  static const Color _lightError = Color(0xFFD32F2F);

  static const Color _darkPrimary = Color(0xFF8EA0FF);
  static const Color _darkSecondary = Color(0xFFB39DFF);
  static const Color _darkBackground = Color(0xFF0F1214);
  static const Color _darkSurface = Color(0xFF14181B);
  static const Color _darkOnSurface = Color(0xFFEDEFF2);
  static const Color _darkError = Color(0xFFFF6B6B);

  static final RoundedRectangleBorder defaultShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

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
        onSecondary: Colors.white,
        background: _lightBackground,
        onBackground: const Color(0xFF1A1D1F),
        surface: _lightSurface,
        onSurface: _lightOnSurface,
        error: _lightError,
        onError: Colors.white,
        primaryContainer: _lightPrimary.withOpacity(.1),
        onPrimaryContainer: _lightPrimary,
        secondaryContainer: _lightSecondary.withOpacity(.1),
        onSecondaryContainer: _lightSecondary,
        surfaceVariant: const Color(0xFFE6E8EC),
        outline: const Color(0xFFE6E8EC),
        shadow: Colors.black.withOpacity(.15),
        scrim: Colors.black,
        inversePrimary: _lightSecondary,
        tertiary: _lightSecondary,
        onTertiary: Colors.white,
        errorContainer: _lightError.withOpacity(.1),
        onErrorContainer: _lightError,
      ),
      scaffoldBackgroundColor: _lightBackground,
      cardColor: _lightSurface,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
        onBackground: _darkOnSurface,
        surface: _darkSurface,
        onSurface: _darkOnSurface,
        error: _darkError,
        onError: const Color(0xFF0B0C10),
        primaryContainer: _darkPrimary.withOpacity(.15),
        onPrimaryContainer: _darkPrimary,
        secondaryContainer: _darkSecondary.withOpacity(.15),
        onSecondaryContainer: _darkSecondary,
        surfaceVariant: const Color(0xFF2A2F34),
        outline: const Color(0xFF2A2F34),
        shadow: Colors.black,
        scrim: Colors.black,
        inversePrimary: _darkSecondary,
        tertiary: _darkSecondary,
        onTertiary: const Color(0xFF0B0C10),
        errorContainer: _darkError.withOpacity(.15),
        onErrorContainer: _darkError,
      ),
      scaffoldBackgroundColor: _darkBackground,
      cardColor: _darkSurface,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: _darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          backgroundColor: _darkPrimary,
          foregroundColor: const Color(0xFF0B0C10),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
