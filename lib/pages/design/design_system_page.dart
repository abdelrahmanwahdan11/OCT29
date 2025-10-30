import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class DesignSystemPage extends StatelessWidget {
  const DesignSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final colors = <MapEntry<String, Color>>[
      MapEntry('primary', colorScheme.primary),
      MapEntry('onPrimary', colorScheme.onPrimary),
      MapEntry('secondary', colorScheme.secondary),
      MapEntry('tertiary', colorScheme.tertiary),
      MapEntry('surface', colorScheme.surface),
      MapEntry('background', colorScheme.background),
      MapEntry('error', colorScheme.error),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.string('design_tokens')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Color Scheme',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors
                .map(
                  (entry) => _ColorSwatch(name: entry.key, color: entry.value),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Typography',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...[
            textTheme.displaySmall,
            textTheme.headlineMedium,
            textTheme.titleLarge,
            textTheme.bodyLarge,
            textTheme.bodyMedium,
            textTheme.bodySmall,
          ].map((style) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'The quick brown fox jumps over the lazy dog',
                style: style,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ThemeData.estimateBrightnessForColor(color) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
      ),
    );
  }
}
