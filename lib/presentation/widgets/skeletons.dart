import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.height = 16, this.width = double.infinity, this.radius = 12});

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final base = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return base.animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 900.ms);
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonLine(height: 160, radius: 20),
          SizedBox(height: 16),
          SkeletonLine(width: 160),
          SizedBox(height: 8),
          SkeletonLine(width: 120),
          SizedBox(height: 8),
          SkeletonLine(width: 200),
        ],
      ),
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        count,
        (_) => const SkeletonLine(width: 120),
      ),
    );
  }
}
