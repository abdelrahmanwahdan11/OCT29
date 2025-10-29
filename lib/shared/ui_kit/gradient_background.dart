import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    required this.imageUrl,
  });

  final Widget child;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<NeoTokens>() ??
        const NeoTokens(
          cardRadius: 22,
          navRadius: 24,
          appBarRadius: 20,
          inputRadius: 18,
          chipRadius: 18,
          backgroundImageOpacity: 0.03,
          backgroundOverlayLight: Color(0x0AFFFFFF),
          backgroundOverlayDark: Color(0x24000000),
        );
    final overlay = theme.brightness == Brightness.dark
        ? tokens.backgroundOverlayDark
        : tokens.backgroundOverlayLight;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: tokens.backgroundImageOpacity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(child: ColoredBox(color: overlay)),
          child,
        ],
      ),
    );
  }
}
