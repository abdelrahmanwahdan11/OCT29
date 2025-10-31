import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.card,
    required this.cardAlt,
    required this.onBackground,
    required this.onSurface,
    required this.subtext,
    required this.divider,
    required this.accent,
    required this.accentAlt,
    required this.warning,
    required this.error,
    required this.success,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color cardAlt;
  final Color onBackground;
  final Color onSurface;
  final Color subtext;
  final Color divider;
  final Color accent;
  final Color accentAlt;
  final Color warning;
  final Color error;
  final Color success;
}

class AppTheme {
  static const _darkPalette = AppPalette(
    background: Color(0xFF0F1318),
    surface: Color(0xFF171B21),
    card: Color(0xFF1C2228),
    cardAlt: Color(0xFF222A2F),
    onBackground: Color(0xFFE9EEF4),
    onSurface: Color(0xFFD3D9E0),
    subtext: Color(0xFF9AA6B2),
    divider: Color(0xFF232B33),
    accent: Color(0xFF36E67D),
    accentAlt: Color(0xFF2ECB70),
    warning: Color(0xFFFFB020),
    error: Color(0xFFFF5D5D),
    success: Color(0xFF36E67D),
  );

  static const _lightPalette = AppPalette(
    background: Color(0xFFF4F6F8),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    cardAlt: Color(0xFFF1F5F9),
    onBackground: Color(0xFF0F141A),
    onSurface: Color(0xFF1C242C),
    subtext: Color(0xFF6B7785),
    divider: Color(0xFFE5EAF0),
    accent: Color(0xFF36E67D),
    accentAlt: Color(0xFF2ECB70),
    warning: Color(0xFFFFB020),
    error: Color(0xFFE34444),
    success: Color(0xFF2ECB70),
  );

  static ThemeData dark(Color accent) => _buildTheme(_darkPalette, accent, Brightness.dark);
  static ThemeData light(Color accent) => _buildTheme(_lightPalette, accent, Brightness.light);

  static ThemeData _buildTheme(AppPalette palette, Color accent, Brightness brightness) {
    final textTheme = GoogleFonts.interTextTheme();
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.black,
      secondary: palette.accentAlt,
      onSecondary: Colors.black,
      error: palette.error,
      onError: Colors.white,
      background: palette.background,
      onBackground: palette.onBackground,
      surface: palette.surface,
      onSurface: palette.onSurface,
    );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(bodyColor: palette.onSurface, displayColor: palette.onBackground),
      cardTheme: CardTheme(
        color: palette.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        shadowColor: palette.accent.withOpacity(0.15),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        elevation: 0,
        foregroundColor: palette.onBackground,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      dividerColor: palette.divider,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.cardAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: palette.subtext),
        hintStyle: TextStyle(color: palette.subtext),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.cardAlt,
        selectedColor: accent,
        secondarySelectedColor: palette.accentAlt,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        labelStyle: TextStyle(color: palette.onSurface),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        brightness: brightness,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          elevation: 6,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      useMaterial3: true,
    );
  }
}
