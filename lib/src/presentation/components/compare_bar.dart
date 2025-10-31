import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../application/controllers/app_controllers.dart';

class CompareBar extends StatelessWidget {
  const CompareBar({super.key, required this.controllers, this.overlayKey});

  final AppControllerRegistry controllers;
  final Key? overlayKey;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: controllers.compareController.selected,
      builder: (context, value, _) {
        if (value.isEmpty) return const SizedBox.shrink();
        return Align(
          key: overlayKey,
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(IconlyBold.swap, color: Colors.white),
                const SizedBox(width: 8),
                Text('${value.length} مقارنة', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/compare'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('عرض'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
