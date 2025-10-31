import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/recent_views_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';
import '../../widgets/hero_viewer.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.carsController,
    required this.car,
    required this.recentViewsController,
  });

  final CarsController carsController;
  final Car car;
  final RecentViewsController recentViewsController;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _showSpecs = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.recentViewsController.recordView(widget.car.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final car = widget.car;
    final fuelLabel = locale.languageCode == 'ar' ? car.fuel.labelAr : car.fuel.labelEn;
    final transmissionLabel =
        locale.languageCode == 'ar' ? car.transmission.labelAr : car.transmission.labelEn;
    final conditionLabel = locale.languageCode == 'ar' ? car.condition.labelAr : car.condition.labelEn;

    return Scaffold(
      appBar: AppBar(title: Text(car.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: () => setState(() => _showSpecs = !_showSpecs),
                child: AnimatedSwitcher(
                  duration: 420.ms,
                  transitionBuilder: (child, animation) {
                    final rotate = Tween(begin: _showSpecs ? -1.0 : 1.0, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                      animation: rotate,
                      child: child,
                      builder: (context, child) {
                        final value = rotate.value;
                        return Transform(
                          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(value * 3.14 / 2),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                    );
                  },
                  child: _showSpecs
                      ? _SpecCard(
                          car: car,
                          fuelLabel: fuelLabel,
                          transmissionLabel: transmissionLabel,
                          conditionLabel: conditionLabel,
                          key: const ValueKey('spec'),
                        )
                      : Semantics(
                          label: l10n.t('hero_viewer'),
                          child: HeroViewer(car: car, key: const ValueKey('viewer')),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(car.description, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton.filledTonal(
                    tooltip: l10n.t('ai_explain'),
                    onPressed: () => _showExplain(context, l10n),
                    icon: const Icon(Icons.smart_toy_outlined),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final added = await widget.carsController.toggleCompare(car.id);
                      if (!added && mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(l10n.t('compare_full'))));
                      }
                    },
                    icon: const Icon(Icons.compare_arrows),
                    label: Text(l10n.t('add_to_compare')),
                  ),
                  IconButton.filledTonal(
                    tooltip: l10n.t('favorites'),
                    onPressed: () => widget.carsController.toggleFavorite(car.id),
                    icon: Icon(widget.carsController.isFavorite(car.id) ? IconlyBold.heart : IconlyLight.heart),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _OverviewTile(title: l10n.t('top_speed'), value: '${car.topSpeedKmh} km/h'),
                  _OverviewTile(title: l10n.t('seats'), value: car.seats.toString()),
                  _OverviewTile(title: l10n.t('horsepower'), value: '${car.horsepower} hp'),
                  _OverviewTile(title: l10n.t('mileage'), value: '${car.mileageKm} km'),
                ],
              ).animate().fade(duration: 320.ms).slide(begin: const Offset(0, 0.1)),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FilledButton(
                onPressed: () => _showContactDialog(context, l10n),
                child: Text(l10n.t('contact_seller')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExplain(BuildContext context, AppLocalizations l10n) {
    final explanation = widget.carsController.buildAiExplainText(widget.car);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.t('ai_explain'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text(explanation),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.t('contact_seller')),
        content: Text(l10n.t('contact_placeholder')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.t('close'))),
        ],
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({
    super.key,
    required this.car,
    required this.fuelLabel,
    required this.transmissionLabel,
    required this.conditionLabel,
  });

  final Car car;
  final String fuelLabel;
  final String transmissionLabel;
  final String conditionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).t('specifications'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _SpecRow(label: AppLocalizations.of(context).t('drivetrain'), value: car.drivetrain),
          _SpecRow(label: AppLocalizations.of(context).t('acceleration'), value: '${car.acceleration0100}s'),
          _SpecRow(label: AppLocalizations.of(context).t('fuel'), value: fuelLabel),
          _SpecRow(label: AppLocalizations.of(context).t('transmission'), value: transmissionLabel),
          _SpecRow(label: AppLocalizations.of(context).t('condition'), value: conditionLabel),
          if (car.batteryRangeKm != null)
            _SpecRow(label: AppLocalizations.of(context).t('battery_range'), value: '${car.batteryRangeKm} km'),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
