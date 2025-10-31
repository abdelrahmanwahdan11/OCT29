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
              ),
              IconButton(
                onPressed: widget.onFavorite,
                icon: Icon(widget.isFavorite ? IconlyBold.heart : IconlyLight.heart),
                color: widget.isFavorite ? theme.colorScheme.primary : theme.colorScheme.onSurface,
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
                  '${car.currency} ${car.price.toStringAsFixed(0)}',
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
            '${car.year} • ${car.mileageKm} km • ${car.fuel.labelEn}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SpecChip(label: '${car.seats} seats'),
              _SpecChip(label: '${car.topSpeedKmh} km/h'),
              _SpecChip(label: car.transmission.labelEn),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(ThemeData theme, AppLocalizations l10n) {
    final car = widget.car;
    return Container(
      key: const ValueKey('back'),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Specs', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _SpecRow(title: 'Fuel', value: car.fuel.labelEn),
          _SpecRow(title: 'Transmission', value: car.transmission.labelEn),
          _SpecRow(title: 'Condition', value: car.condition.labelEn),
          _SpecRow(title: '0-100', value: '${car.acceleration0100}s'),
          if (car.batteryRangeKm != null)
            _SpecRow(title: 'Range', value: '${car.batteryRangeKm} km'),
        ],
      ),
    );
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
