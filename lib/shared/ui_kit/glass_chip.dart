import 'package:flutter/material.dart';

class GlassChip extends StatelessWidget {
  const GlassChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.primaryContainer : colors.surfaceVariant,
          border: Border.all(
            color: selected ? colors.primary.withOpacity(0.4) : colors.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: colors.primary.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: selected ? colors.onPrimaryContainer : colors.onSurfaceVariant),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? colors.onPrimaryContainer : colors.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
