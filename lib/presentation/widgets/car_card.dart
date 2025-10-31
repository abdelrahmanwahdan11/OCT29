import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../core/localization/app_localizations.dart';
import '../../domain/entities/car.dart';

class CarCard extends StatefulWidget {
  const CarCard({
    super.key,
    required this.car,
    required this.onFavorite,
    required this.isFavorite,
    required this.onCompare,
    required this.onDetails,
    required this.onImageTap,
  });

  final Car car;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final Future<bool> Function() onCompare;
  final VoidCallback onDetails;
  final VoidCallback onImageTap;

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  bool _showBack = false;

  void _toggleSide() {
    setState(() => _showBack = !_showBack);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return AnimatedContainer(
      duration: 240.ms,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onImageTap,
            child: Semantics(
              label: '${widget.car.brand} ${widget.car.model}',
              image: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.car.images.first,
                  fit: BoxFit.cover,
                  height: 160,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 420.ms,
              transitionBuilder: (child, animation) {
                final rotate = Tween<double>(begin: _showBack ? -1 : 1, end: 0).animate(animation);
                return AnimatedBuilder(
                  animation: rotate,
                  child: child,
                  builder: (context, child) {
                    final value = rotate.value;
                    return Transform(
                      transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(value * 1.57),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                );
              },
              child: _showBack ? _buildBack(theme, l10n) : _buildFront(theme, l10n),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.t('flip_for_specs'),
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onDetails,
                  child: Text(l10n.t('view_details')),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () async {
                  final added = await widget.onCompare();
                  if (!added && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.t('compare_full'))),
                    );
                  }
                },
                icon: const Icon(Icons.compare_arrows),
                tooltip: l10n.t('add_to_compare'),
              ),
              IconButton(
                onPressed: widget.onFavorite,
                icon: Icon(widget.isFavorite ? IconlyBold.heart : IconlyLight.heart),
                color: widget.isFavorite ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                tooltip: l10n.t('favorites'),
              ),
            ],
          ),
          TextButton(
            onPressed: _toggleSide,
            child: Text(_showBack ? l10n.t('show_overview') : l10n.t('show_specs')),
          ),
        ],
      ),
    );
  }

  Widget _buildFront(ThemeData theme, AppLocalizations l10n) {
    final car = widget.car;
    final locale = Localizations.localeOf(context);
    return Container(
      key: const ValueKey('front'),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _formatCurrency(car.price, car.currency),
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Icon(IconlyLight.time_circle, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            car.title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${car.year} • ${car.mileageKm} km • ${locale.languageCode == 'ar' ? car.fuel.labelAr : car.fuel.labelEn}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SpecChip(label: '${car.seats} ${l10n.t('seat')}'),
              _SpecChip(label: '${car.topSpeedKmh} km/h'),
              _SpecChip(label: locale.languageCode == 'ar' ? car.transmission.labelAr : car.transmission.labelEn),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(ThemeData theme, AppLocalizations l10n) {
    final car = widget.car;
    final locale = Localizations.localeOf(context);
    return Container(
      key: const ValueKey('back'),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.t('specifications'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _SpecRow(title: l10n.t('fuel'), value: locale.languageCode == 'ar' ? car.fuel.labelAr : car.fuel.labelEn),
          _SpecRow(title: l10n.t('transmission'), value: locale.languageCode == 'ar' ? car.transmission.labelAr : car.transmission.labelEn),
          _SpecRow(title: l10n.t('condition'), value: locale.languageCode == 'ar' ? car.condition.labelAr : car.condition.labelEn),
          _SpecRow(title: l10n.t('acceleration'), value: '${car.acceleration0100}s'),
          if (car.batteryRangeKm != null)
            _SpecRow(title: l10n.t('battery_range'), value: '${car.batteryRangeKm} km'),
        ],
      ),
    );
  }

  String _formatCurrency(double value, String currency) {
    final digits = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1 && i != digits.length - 1) {
        buffer.write(',');
      }
    }
    return '$currency ${buffer.toString()}';
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
