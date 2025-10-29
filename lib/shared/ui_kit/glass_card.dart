import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'blur_container.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlurContainer(
      borderRadius: 24,
      onTap: onTap,
      child: child,
    ).animate().fade(duration: 400.ms).slide(begin: const Offset(0, 0.1), curve: Curves.easeOut);
  }
}
