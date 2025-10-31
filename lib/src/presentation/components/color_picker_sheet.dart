import 'package:flutter/material.dart';

class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({super.key, required this.onColorSelected});

  final ValueChanged<Color> onColorSelected;

  static const _palette = <Color>[
    Color(0xFF00A3FF),
    Color(0xFFFF006E),
    Color(0xFF8338EC),
    Color(0xFF3A86FF),
    Color(0xFFFFBE0B),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('اختر لوناً أساسياً', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _palette
                .map(
                  (color) => GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.onBackground, width: 2),
                        color: color,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
