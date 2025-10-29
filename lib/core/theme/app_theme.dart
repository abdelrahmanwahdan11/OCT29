import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/controllers/app_controller.dart';

class AppThemeBundle {
  const AppThemeBundle({required this.light, required this.dark});

  final ThemeData light;
  final ThemeData dark;
}

class NeoTokens extends ThemeExtension<NeoTokens> {
  const NeoTokens({
    required this.cardRadius,
    required this.navRadius,
    required this.appBarRadius,
    required this.inputRadius,
    required this.chipRadius,
    required this.backgroundImageOpacity,
    required this.backgroundOverlayLight,
    required this.backgroundOverlayDark,
  });

  final double cardRadius;
  final double navRadius;
  final double appBarRadius;
  final double inputRadius;
  final double chipRadius;
  final double backgroundImageOpacity;
  final Color backgroundOverlayLight;
  final Color backgroundOverlayDark;

  @override
  ThemeExtension<NeoTokens> copyWith({
    double? cardRadius,
    double? navRadius,
    double? appBarRadius,
    double? inputRadius,
    double? chipRadius,
    double? backgroundImageOpacity,
    Color? backgroundOverlayLight,
    Color? backgroundOverlayDark,
  }) {
    return NeoTokens(
      cardRadius: cardRadius ?? this.cardRadius,
      navRadius: navRadius ?? this.navRadius,
      appBarRadius: appBarRadius ?? this.appBarRadius,
      inputRadius: inputRadius ?? this.inputRadius,
      chipRadius: chipRadius ?? this.chipRadius,
      backgroundImageOpacity: backgroundImageOpacity ?? this.backgroundImageOpacity,
      backgroundOverlayLight: backgroundOverlayLight ?? this.backgroundOverlayLight,
      backgroundOverlayDark: backgroundOverlayDark ?? this.backgroundOverlayDark,
    );
  }

  @override
  ThemeExtension<NeoTokens> lerp(ThemeExtension<NeoTokens>? other, double t) {
    if (other is! NeoTokens) return this;
    return NeoTokens(
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      navRadius: lerpDouble(navRadius, other.navRadius, t)!,
      appBarRadius: lerpDouble(appBarRadius, other.appBarRadius, t)!,
      inputRadius: lerpDouble(inputRadius, other.inputRadius, t)!,
      chipRadius: lerpDouble(chipRadius, other.chipRadius, t)!,
      backgroundImageOpacity: lerpDouble(backgroundImageOpacity, other.backgroundImageOpacity, t)!,
      backgroundOverlayLight: Color.lerp(backgroundOverlayLight, other.backgroundOverlayLight, t)!,
      backgroundOverlayDark: Color.lerp(backgroundOverlayDark, other.backgroundOverlayDark, t)!,
    );
  }
}

AppThemeBundle buildAppTheme(AppController controller) {
  const lightPalette = _NeoPalette.light();
  const darkPalette = _NeoPalette.dark();

  TextTheme textThemeForLocale(Brightness brightness) {
    final baseTheme = brightness == Brightness.dark
        ? ThemeData(brightness: Brightness.dark).textTheme
        : ThemeData(brightness: Brightness.light).textTheme;
    final localeCode = controller.locale.languageCode.toLowerCase();
    final textTheme = localeCode == 'ar'
        ? GoogleFonts.cairoTextTheme(baseTheme)
        : GoogleFonts.manropeTextTheme(baseTheme);
    return textTheme.apply(
      bodyColor: brightness == Brightness.dark ? darkPalette.textPrimary : lightPalette.textPrimary,
      displayColor: brightness == Brightness.dark ? darkPalette.textPrimary : lightPalette.textPrimary,
    );
  }

  ThemeData buildTheme(_NeoPalette palette, Brightness brightness) {
    final textTheme = textThemeForLocale(brightness);
    final scheme = ColorScheme(
      brightness: brightness,
      primary: controller.seedColor,
      onPrimary: brightness == Brightness.dark ? palette.textPrimary : Colors.white,
      secondary: palette.secondary,
      onSecondary: brightness == Brightness.dark ? palette.textPrimary : palette.textPrimary,
      tertiary: palette.accent,
      onTertiary: palette.textPrimary,
      error: palette.danger,
      onError: Colors.white,
      background: palette.background,
      onBackground: palette.textPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      outline: palette.divider,
      shadow: Colors.black.withOpacity(brightness == Brightness.dark ? 0.4 : 0.1),
      scrim: Colors.black45,
      surfaceTint: controller.seedColor,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: palette.textPrimary,
      secondaryContainer: palette.secondaryContainer,
      onSecondaryContainer: palette.textPrimary,
      tertiaryContainer: palette.surfaceAlt,
      onTertiaryContainer: palette.textPrimary,
      errorContainer: palette.danger.withOpacity(0.14),
      onErrorContainer: palette.textPrimary,
      inverseSurface: palette.surfaceAlt,
      onInverseSurface: palette.textPrimary,
      inversePrimary: palette.accent,
      surfaceVariant: palette.surfaceAlt,
      onSurfaceVariant: palette.textSecondary,
      outlineVariant: palette.divider,
    );

    final tokens = const NeoTokens(
      cardRadius: 22,
      navRadius: 24,
      appBarRadius: 20,
      inputRadius: 18,
      chipRadius: 18,
      backgroundImageOpacity: 0.03,
      backgroundOverlayLight: Color(0x0AFFFFFF),
      backgroundOverlayDark: Color(0x24000000),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      visualDensity: controller.density,
      textTheme: textTheme,
      fontFamily: controller.locale.languageCode.toLowerCase() == 'ar'
          ? GoogleFonts.cairo().fontFamily
          : GoogleFonts.manrope().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.appBarRadius)),
        titleTextStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      cardTheme: CardTheme(
        color: palette.surface,
        elevation: palette == darkPalette ? 8 : 6,
        shadowColor: scheme.shadow,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.cardRadius)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: controller.seedColor,
        unselectedItemColor: palette.textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelSmall,
      ),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: palette.divider)),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium,
        backgroundColor: palette.surfaceAlt,
        secondarySelectedColor: controller.seedColor.withOpacity(0.12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: palette.divider),
          borderRadius: BorderRadius.circular(tokens.inputRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette.divider),
          borderRadius: BorderRadius.circular(tokens.inputRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: controller.seedColor, width: 1.6),
          borderRadius: BorderRadius.circular(tokens.inputRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette.danger),
          borderRadius: BorderRadius.circular(tokens.inputRadius),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: controller.seedColor,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: controller.seedColor,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: controller.seedColor.withOpacity(0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          foregroundColor: controller.seedColor,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: controller.seedColor,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(color: palette.divider, space: 24, thickness: 1),
      listTileTheme: ListTileThemeData(
        tileColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.cardRadius)),
        iconColor: palette.textSecondary,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: palette.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.cardRadius)),
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }

  return AppThemeBundle(
    light: buildTheme(lightPalette, Brightness.light),
    dark: buildTheme(darkPalette, Brightness.dark),
  );
}

class _NeoPalette {
  const _NeoPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.secondary,
    required this.secondaryContainer,
    required this.primaryContainer,
    required this.accent,
    required this.danger,
    required this.warning,
    required this.success,
    required this.divider,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color secondary;
  final Color secondaryContainer;
  final Color primaryContainer;
  final Color accent;
  final Color danger;
  final Color warning;
  final Color success;
  final Color divider;

  static const _NeoPalette light() = _NeoPalette(
    background: Color(0xFFF7FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    secondary: Color(0xFF22C55E),
    secondaryContainer: Color(0xFFDCFCE7),
    primaryContainer: Color(0xFFE0F2FE),
    accent: Color(0xFFA78BFA),
    danger: Color(0xFFEF4444),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF16A34A),
    divider: Color.fromRGBO(2, 6, 23, 0.08),
  );

  static const _NeoPalette dark() = _NeoPalette(
    background: Color(0xFF0B1220),
    surface: Color(0xFF0F172A),
    surfaceAlt: Color(0xFF111827),
    textPrimary: Color(0xFFE5E7EB),
    textSecondary: Color(0xFF9CA3AF),
    secondary: Color(0xFF34D399),
    secondaryContainer: Color(0xFF064E3B),
    primaryContainer: Color(0xFF082F49),
    accent: Color(0xFFC4B5FD),
    danger: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
    success: Color(0xFF22C55E),
    divider: Color.fromRGBO(241, 245, 249, 0.08),
  );
}
