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
  ThemeData buildLightTheme() {
    final scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF10B6E8),
      onPrimary: Colors.white,
      secondary: Color(0xFFFF8E3C),
      onSecondary: Color(0xFF0E1B25),
      error: Color(0xFFEF4444),
      onError: Colors.white,
      background: Colors.transparent,
      onBackground: Color(0xFF0E1B25),
      surface: Colors.white,
      onSurface: Color(0xFF0E1B25),
      primaryContainer: Color(0xFF1CC4F0),
      onPrimaryContainer: Color(0xFF01212F),
      secondaryContainer: Color(0xFFFFB36B),
      onSecondaryContainer: Color(0xFF0B1A24),
      errorContainer: Color(0xFFFFD6D6),
      onErrorContainer: Color(0xFF5A1111),
      surfaceTint: Color(0xFF10B6E8),
      outline: Color(0xFFB3D8E7),
      outlineVariant: Color(0x66FFFFFF),
      shadow: Color(0x40001018),
      scrim: Color(0x550B1A24),
      inverseSurface: Color(0xFF0E1B25),
      inversePrimary: Color(0xFF22D3EE),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.35),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.28),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.45), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.28), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.7), width: 1.3),
        ),
        hintStyle: TextStyle(color: const Color(0xFF3E5665).withOpacity(0.9)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.25),
        labelStyle: TextStyle(color: scheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: StadiumBorder(side: BorderSide(color: Colors.white.withOpacity(0.35))),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white.withOpacity(0.72),
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const GlassThemeExtension(
          blurSigma: 20,
          borderColor: Color(0x73FFFFFF),
          borderWidth: 1.2,
          saturation: 1.4,
          shadowColor: Color(0x33001018),
        ),
      ],
    );
  }

  ThemeData buildDarkTheme() {
    final scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF22D3EE),
      onPrimary: Color(0xFF01212F),
      secondary: Color(0xFFFFB36B),
      onSecondary: Color(0xFF0B1A24),
      error: Color(0xFFF87171),
      onError: Color(0xFF1F0A0A),
      background: Colors.transparent,
      onBackground: Color(0xFFE6F2F9),
      surface: Color(0xFF0E1B25),
      onSurface: Color(0xFFE6F2F9),
      primaryContainer: Color(0xFF0E2A3A),
      onPrimaryContainer: Color(0xFF9EF1FF),
      secondaryContainer: Color(0xFF274659),
      onSecondaryContainer: Color(0xFFFFF4E8),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFFE5E5),
      surfaceTint: Color(0xFF22D3EE),
      outline: Color(0xFF274659),
      outlineVariant: Color(0x33FFFFFF),
      shadow: Color(0x66001018),
      scrim: Color(0x880B1A24),
      inverseSurface: Color(0xFFE6F2F9),
      inversePrimary: Color(0xFF10B6E8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme.apply(
            bodyColor: scheme.onSurface,
            displayColor: scheme.onSurface,
          )),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.12),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.35), width: 1.1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.22), width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.8), width: 1.2),
        ),
        hintStyle: TextStyle(color: const Color(0xFFB7CEDB).withOpacity(0.85)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.18),
        labelStyle: TextStyle(color: scheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: StadiumBorder(side: BorderSide(color: Colors.white.withOpacity(0.28))),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: const Color(0xFF0B1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFF0B1A24).withOpacity(0.92),
        surfaceTintColor: const Color(0xFF0B1A24),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        GlassThemeExtension(
          blurSigma: 24,
          borderColor: Color(0x59FFFFFF),
          borderWidth: 1.2,
          saturation: 1.3,
          shadowColor: Color(0x55001018),
        ),
      ],
    );
  }

  return AppThemeBundle(
    light: buildLightTheme(),
    dark: buildDarkTheme(),
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
