import 'package:flutter/material.dart';

class InkChip extends StatelessWidget {
  const InkChip({super.key, required this.label, this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
