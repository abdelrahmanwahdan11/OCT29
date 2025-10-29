import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassNavItemData {
  const GlassNavItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<GlassNavItemData> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Material(
        elevation: 12,
        color: scheme.surface,
        shadowColor: scheme.shadow.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _GlassNavItem(
                    icon: items[i].icon,
                    label: items[i].label,
                    index: i,
                    currentIndex: currentIndex,
                    onTap: onChanged,
                  ),
                ),
            ],
          ),
        ),
      ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOutBack),
    );
  }
}

class _GlassNavItem extends StatelessWidget {
  const _GlassNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: 200.ms,
              curve: Curves.easeOut,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
              child: Text(label, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: 200.ms,
              height: 4,
              width: isActive ? 24 : 4,
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
