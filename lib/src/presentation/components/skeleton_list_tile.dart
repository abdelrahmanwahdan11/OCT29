import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/eink_theme.dart';

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final skeleton = context.skeletonTheme;
    return Row(
      children: <Widget>[
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(color: skeleton.base, borderRadius: BorderRadius.circular(12)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 14, width: double.infinity, color: skeleton.base)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: const Duration(milliseconds: 800), color: skeleton.highlight),
              const SizedBox(height: 8),
              Container(height: 12, width: double.infinity, color: skeleton.base)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: const Duration(milliseconds: 900), color: skeleton.highlight),
            ],
          ),
        ),
      ],
    );
  }
}
