import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../pages/details_page.dart';
import 'primary_button.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.car, required this.controllers});

  final Car car;
  final AppControllerRegistry controllers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = car.price > 0 ? '${car.price.toStringAsFixed(0)} ${car.currency}' : '---';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(car.images.isNotEmpty ? car.images.first : 'https://picsum.photos/seed/${car.id}/600/400', fit: BoxFit.cover)
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 350)),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: theme.colorScheme.background.withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
                        child: Text(car.condition.toUpperCase(), style: theme.textTheme.labelLarge),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('${car.make} ${car.model}', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('${car.year} • ${car.mileageKm} كم', style: theme.textTheme.bodyMedium),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(child: Text(price, style: theme.textTheme.headlineSmall)),
                IconButton(
                  icon: const Icon(IconlyBold.heart),
                  onPressed: () {
                    controllers.notificationController.addNotification(
                      AppNotification(title: 'Favorite', message: car.fullName, createdAt: DateTime.now()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(IconlyBold.swap),
                  onPressed: () => controllers.compareController.toggle(car.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: MaterialLocalizations.of(context).viewButtonLabel,
              icon: IconlyBold.show,
              onPressed: () => Navigator.of(context).pushNamed('/details/${car.id}', arguments: car),
            ),
          ],
        ),
      ),
    );
  }
}
