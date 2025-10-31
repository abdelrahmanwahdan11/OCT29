import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/car.dart';
import 'hero_viewer.dart';

Future<void> showCarPreviewDialog({
  required BuildContext context,
  required Car car,
  required VoidCallback onViewDetails,
}) {
  final l10n = AppLocalizations.of(context);
  final colors = AppColors.of(context);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.t('car_preview'),
    transitionDuration: 240.ms,
    pageBuilder: (context, _, __) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = math.min(constraints.maxWidth * 0.92, 620.0);
          final maxHeight = math.min(constraints.maxHeight * 0.92, 760.0);
          return Material(
            color: colors.background.withOpacity(0.86),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
                child: _PreviewCard(
                  car: car,
                  onViewDetails: onViewDetails,
                ),
              ),
            ),
          );
        },
      );
    },
    transitionBuilder: (context, animation, _, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.car, required this.onViewDetails});

  final Car car;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final locale = Localizations.localeOf(context);
    final fuelLabel = locale.languageCode == 'ar' ? car.fuel.labelAr : car.fuel.labelEn;
    final transmissionLabel =
        locale.languageCode == 'ar' ? car.transmission.labelAr : car.transmission.labelEn;
    final price = '${car.currency} ${car.price.toStringAsFixed(0)}';

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeroViewer(car: car),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Badge(text: '${car.year}'),
                        _Badge(text: fuelLabel),
                        _Badge(text: transmissionLabel),
                        _Badge(text: '${car.horsepower} hp'),
                        if (car.batteryRangeKm != null) _Badge(text: '${car.batteryRangeKm} km EV'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      car.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onViewDetails();
                        },
                        child: Text(l10n.t('view_details')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 220.ms).slide(begin: const Offset(0, 0.04));
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.cardAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onSurface),
      ),
    );
  }
}
