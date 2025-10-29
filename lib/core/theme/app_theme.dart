import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/controllers/app_controller.dart';

class AppThemeBundle {
  const AppThemeBundle({required this.light, required this.dark});

  final ThemeData light;
  final ThemeData dark;
}

AppThemeBundle buildAppTheme(AppController controller) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF10B6E8),
      secondary: Color(0xFFFF8E3C),
      background: Color(0xFFEFF6FB),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF0B1A24),
      onSurface: Color(0xFF0E1B25),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.transparent,
  );

  final darkBase = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1CC4F0),
      secondary: Color(0xFFFFB36B),
      background: Color(0xFF07111A),
      surface: Color(0xFF0E1B25),
      onPrimary: Color(0xFF01212F),
      onSecondary: Color(0xFF01212F),
      onSurface: Color(0xFFEFF6FB),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    scaffoldBackgroundColor: Colors.transparent,
  );

  ThemeData decorate(ThemeData baseTheme) {
    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0B1A24),
        scrolledUnderElevation: 0,
        shadowColor: const Color(0x40001018),
        surfaceTintColor: Colors.white.withOpacity(0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.white.withOpacity(0.35),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.35), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFF10B6E8).withOpacity(0.65), width: 1.2),
        ),
        hintStyle: TextStyle(color: const Color(0xFF3E5665).withOpacity(0.8)),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: Colors.white.withOpacity(0.25),
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
        labelStyle: const TextStyle(color: Color(0xFF0B1A24)),
      ),
      extensions: <ThemeExtension<dynamic>>[
        GlassThemeExtension(
          blurSigma: 18,
          borderColor: Colors.white.withOpacity(0.5),
          borderWidth: 1.2,
          saturation: 1.4,
          shadowColor: const Color(0x40001018),
        ),
      ],
    );
  }

  return AppThemeBundle(
    light: decorate(base),
    dark: decorate(darkBase),
  );
}

class GlassThemeExtension extends ThemeExtension<GlassThemeExtension> {
  const GlassThemeExtension({
    required this.blurSigma,
    required this.borderColor,
    required this.borderWidth,
    required this.saturation,
    required this.shadowColor,
  });

  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final double saturation;
  final Color shadowColor;

  @override
  ThemeExtension<GlassThemeExtension> copyWith({
    double? blurSigma,
    Color? borderColor,
    double? borderWidth,
    double? saturation,
    Color? shadowColor,
  }) {
    return GlassThemeExtension(
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      saturation: saturation ?? this.saturation,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  ThemeExtension<GlassThemeExtension> lerp(
    covariant ThemeExtension<GlassThemeExtension>? other,
    double t,
  ) {
    if (other is! GlassThemeExtension) {
      return this;
    }

    return GlassThemeExtension(
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      saturation: lerpDouble(saturation, other.saturation, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}
