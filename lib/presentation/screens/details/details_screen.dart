import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../domain/entities/car.dart';
import '../../widgets/hero_viewer.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.carsController, required this.car});

  final CarsController carsController;
  final Car car;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _showSpecs = false;

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
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
                      ? _SpecCard(car: car, key: const ValueKey('spec'))
                      : HeroViewer(car: car, key: const ValueKey('viewer')),
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
                children: [
                  IconButton.filledTonal(
                    onPressed: () => _showExplain(context),
                    icon: const Icon(Icons.smart_toy_outlined),
                  ),
                  ElevatedButton(
                    onPressed: () => widget.carsController.toggleCompare(car.id),
                    child: const Text('Add to compare'),
                  ),
                  IconButton.filledTonal(
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
                  _OverviewTile(title: 'Top speed', value: '${car.topSpeedKmh} km/h'),
                  _OverviewTile(title: 'Seats', value: car.seats.toString()),
                  _OverviewTile(title: 'HP', value: car.horsepower.toString()),
                  _OverviewTile(title: 'Mileage', value: '${car.mileageKm} km'),
                ],
              ).animate().fade(duration: 320.ms).slide(begin: const Offset(0, 0.1)),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () => _showContactDialog(context),
                child: const Text('Contact Seller (Stub)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExplain(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('AI Explain', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Text('AI analysis will provide insights later. Stay tuned!'),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Contact Seller (Stub)'),
        content: const Text('This is a placeholder. Integration will arrive in later phases.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({super.key, required this.car});

  final Car car;

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
          Text('Specifications', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _SpecRow(label: 'Drivetrain', value: car.drivetrain),
          _SpecRow(label: 'Acceleration 0-100', value: '${car.acceleration0100}s'),
          _SpecRow(label: 'Fuel', value: car.fuel.labelEn),
          _SpecRow(label: 'Transmission', value: car.transmission.labelEn),
          _SpecRow(label: 'Condition', value: car.condition.labelEn),
          if (car.batteryRangeKm != null) _SpecRow(label: 'Battery range', value: '${car.batteryRangeKm} km'),
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
