import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final shapeRadius = BorderRadius.circular(borderRadius);
    final content = Material(
      color: theme.colorScheme.surface,
      elevation: theme.brightness == Brightness.dark ? 8 : 6,
      shadowColor: theme.colorScheme.shadow.withOpacity(theme.brightness == Brightness.dark ? 0.24 : 0.12),
      borderRadius: shapeRadius,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        borderRadius: shapeRadius,
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}
