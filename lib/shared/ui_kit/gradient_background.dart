import 'package:flutter/material.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF0B1A24), Color(0xFF0E2A3A)]
        : const [Color(0xFF0EA5E9), Color(0xFF22D3EE)];
    final overlay = isDark ? Colors.black.withOpacity(0.35) : Colors.white.withOpacity(0.12);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
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
