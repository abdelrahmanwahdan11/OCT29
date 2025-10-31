import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color_utils.dart';

class EInkTheme {
  static const Color paperWhite = Color(0xFFFFFFFF);
  static const Color inkBlack = Color(0xFF000000);
  static const Color inkGray100 = Color(0xFFF7F7F7);
  static const Color inkGray300 = Color(0xFFE5E5E5);
  static const Color inkGray500 = Color(0xFF9A9A9A);
  static const Color inkGray700 = Color(0xFF5A5A5A);

  static const Color paperWhiteDark = Color(0xFF0E0E0E);
  static const Color inkBlackDark = Color(0xFFFFFFFF);
  static const Color inkGray100Dark = Color(0xFF1A1A1A);
  static const Color inkGray300Dark = Color(0xFF2A2A2A);
  static const Color inkGray500Dark = Color(0xFF8B8B8B);
  static const Color inkGray700Dark = Color(0xFFCFCFCF);

  final Color defaultAccent;

  const EInkTheme({this.defaultAccent = const Color(0xFF00A3FF)});

  ThemeData lightTheme(Color accent) {
    return _buildTheme(
      brightness: Brightness.light,
      background: paperWhite,
      foreground: inkBlack,
      accent: accent,
      surface: inkGray100,
      divider: inkGray300,
      skeletonBase: inkGray100,
      skeletonHighlight: inkGray300,
    );
  }

  ThemeData darkTheme(Color accent) {
    return _buildTheme(
      brightness: Brightness.dark,
      background: paperWhiteDark,
      foreground: inkBlackDark,
      accent: accent,
      surface: inkGray100Dark,
      divider: inkGray300Dark,
      skeletonBase: inkGray100Dark,
      skeletonHighlight: inkGray300Dark,
    );
  }

  ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color foreground,
    required Color accent,
    required Color surface,
    required Color divider,
    required Color skeletonBase,
    required Color skeletonHighlight,
  }) {
    final base = ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: accent,
        primary: accent,
        onPrimary: brightness == Brightness.dark ? background : foreground,
        background: background,
        onBackground: foreground,
      ),
      textTheme: _textTheme(foreground),
      dividerColor: divider,
      cardTheme: CardTheme(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: true,
      ),
      iconTheme: IconThemeData(color: foreground),
      useMaterial3: true,
    );

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[SkeletonTheme(base: skeletonBase, highlight: skeletonHighlight)],
    );
  }

  TextTheme _textTheme(Color foreground) {
    final cairo = GoogleFonts.cairo(color: foreground);
    final inter = GoogleFonts.inter(color: foreground);
    return TextTheme(
      displayLarge: cairo.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      headlineLarge: cairo.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: inter.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: inter.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      bodyMedium: inter.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
      labelLarge: inter.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
      labelMedium: inter.copyWith(fontSize: 12, fontWeight: FontWeight.normal),
    );
  }
}

class SkeletonTheme extends ThemeExtension<SkeletonTheme> {
  const SkeletonTheme({required this.base, required this.highlight});

  final Color base;
  final Color highlight;

  @override
  ThemeExtension<SkeletonTheme> copyWith({Color? base, Color? highlight}) {
    return SkeletonTheme(base: base ?? this.base, highlight: highlight ?? this.highlight);
  }

  @override
  ThemeExtension<SkeletonTheme> lerp(ThemeExtension<SkeletonTheme>? other, double t) {
    if (other is! SkeletonTheme) return this;
    return SkeletonTheme(
      base: Color.lerp(base, other.base, t) ?? base,
      highlight: Color.lerp(highlight, other.highlight, t) ?? highlight,
    );
  }
}

extension ThemeContextX on BuildContext {
  SkeletonTheme get skeletonTheme => Theme.of(this).extension<SkeletonTheme>()!;
}
