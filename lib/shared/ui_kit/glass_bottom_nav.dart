import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'blur_container.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: BlurContainer(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < items.length; i++)
              _GlassNavItem(
                icon: items[i].icon,
                label: items[i].label,
                index: i,
                currentIndex: currentIndex,
                onTap: onChanged,
              ),
          ],
        ),
      ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutBack),
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
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: 250.ms,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.28) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
            ),
            if (isActive)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ).animate().fade(duration: 200.ms).slide(begin: const Offset(0.2, 0)),
              ),
          ],
        ),
      ),
    );
  }
}
