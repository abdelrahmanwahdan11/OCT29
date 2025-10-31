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

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
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

  factory AppColors.fromPalette(AppPalette palette, {required Color accent}) => AppColors(
        background: palette.background,
        surface: palette.surface,
        card: palette.card,
        cardAlt: palette.cardAlt,
        onBackground: palette.onBackground,
        onSurface: palette.onSurface,
        subtext: palette.subtext,
        divider: palette.divider,
        accent: accent,
        accentAlt: palette.accentAlt,
        warning: palette.warning,
        error: palette.error,
        success: palette.success,
      );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardAlt: Color.lerp(cardAlt, other.cardAlt, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      subtext: Color.lerp(subtext, other.subtext, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentAlt: Color.lerp(accentAlt, other.accentAlt, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? card,
    Color? cardAlt,
    Color? onBackground,
    Color? onSurface,
    Color? subtext,
    Color? divider,
    Color? accent,
    Color? accentAlt,
    Color? warning,
    Color? error,
    Color? success,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      cardAlt: cardAlt ?? this.cardAlt,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      subtext: subtext ?? this.subtext,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      accentAlt: accentAlt ?? this.accentAlt,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  int get hashCode => Object.hash(
        background,
        surface,
        card,
        cardAlt,
        onBackground,
        onSurface,
        subtext,
        divider,
        accent,
        accentAlt,
        warning,
        error,
        success,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppColors &&
        other.background == background &&
        other.surface == surface &&
        other.card == card &&
        other.cardAlt == cardAlt &&
        other.onBackground == onBackground &&
        other.onSurface == onSurface &&
        other.subtext == subtext &&
        other.divider == divider &&
        other.accent == accent &&
        other.accentAlt == accentAlt &&
        other.warning == warning &&
        other.error == error &&
        other.success == success;
  }
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
    final onAccent = brightness == Brightness.dark ? palette.background : palette.onBackground;
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: palette.onBackground),
      headlineLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: palette.onBackground),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: palette.onSurface),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: palette.onSurface),
      titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: palette.onSurface),
      titleSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: palette.onSurface),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: palette.onSurface),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: palette.subtext),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: palette.subtext),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: onAccent),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: palette.subtext),
      labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: palette.subtext),
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      secondary: palette.accentAlt,
      onSecondary: onAccent,
      error: palette.error,
      onError: palette.onBackground,
      background: palette.background,
      onBackground: palette.onBackground,
      surface: palette.surface,
      onSurface: palette.onSurface,
    );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      colorScheme: colorScheme,
      textTheme: textTheme,
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
        secondaryLabelStyle: TextStyle(color: onAccent),
        brightness: brightness,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          elevation: 6,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.card,
        selectedItemColor: accent,
        unselectedItemColor: palette.subtext,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: accent),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: palette.subtext),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(color: accent),
        unselectedIconTheme: IconThemeData(color: palette.subtext),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppColors.fromPalette(palette, accent: accent),
      ],
      useMaterial3: false,
    );
  }
}
