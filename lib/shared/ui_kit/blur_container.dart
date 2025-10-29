import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassThemeExtension>();
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass?.blurSigma ?? 18, sigmaY: glass?.blurSigma ?? 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.35),
                Colors.white.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: glass?.borderColor ?? Colors.white.withOpacity(0.5),
              width: glass?.borderWidth ?? 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: glass?.shadowColor ?? Colors.black.withOpacity(0.15),
                offset: const Offset(0, 12),
                blurRadius: 28,
              ),
            ],
          ),
          child: ColoredBox(
            color: Colors.white.withOpacity(0.08),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
