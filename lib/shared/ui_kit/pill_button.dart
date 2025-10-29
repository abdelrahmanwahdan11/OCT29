import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.style = PillButtonStyle.filledGlass,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;
  final PillButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    BoxDecoration decoration;
    Color textColor;

    switch (style) {
      case PillButtonStyle.gradient:
        decoration = const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF22D3EE)],
          ),
        );
        textColor = Colors.white;
        break;
      case PillButtonStyle.pillIcon:
        decoration = BoxDecoration(
          color: colors.surface.withOpacity(0.55),
        );
        textColor = colors.onSurface;
        break;
      case PillButtonStyle.filledGlass:
      default:
        decoration = BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
        );
        textColor = colors.onSurface;
        break;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: decoration.copyWith(
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x40001018), blurRadius: 28, offset: Offset(0, 12)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ).animate().scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1), duration: 180.ms, curve: Curves.easeOutBack),
    );
  }
}

enum PillButtonStyle { filledGlass, gradient, pillIcon }
