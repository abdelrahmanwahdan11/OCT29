import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../domain/entities/car.dart';

class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
    required this.onFavorite,
    required this.isFavorite,
    required this.onCompare,
  });

  final Car car;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final Future<bool> Function() onCompare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Expanded(
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
                      IconButton(
                        onPressed: onFavorite,
                        icon: Icon(isFavorite ? IconlyBold.heart : IconlyLight.heart),
                        color: isFavorite ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    car.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${car.year} • ${car.mileageKm} km • ${car.fuel.labelEn}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _SpecChip(label: '${car.seats} Seats'),
                      _SpecChip(label: '${car.topSpeedKmh} km/h'),
                      _SpecChip(label: car.fuel.labelEn),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final added = await onCompare();
                          if (!added) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Compare list is full. Remove a car to add more.')),
                            );
                          }
                        },
                        icon: const Icon(Icons.compare),
                        label: const Text('Compare'),
                      ),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/details/${car.id}'),
                        icon: const Icon(IconlyBold.play),
                        label: const Text('View 3D'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                car.images.first,
                fit: BoxFit.cover,
                height: 140,
                width: 160,
              ),
            ),
          ],
        ),
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
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
