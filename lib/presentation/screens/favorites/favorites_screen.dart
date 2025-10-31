import 'package:flutter/material.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';
import '../../widgets/car_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.carsController});

  final CarsController carsController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final favorites = carsController.favoriteIds
        .map((id) => carsController.findById(id))
        .whereType<Car>()
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('favorites'))),
      body: RefreshIndicator(
        onRefresh: carsController.refresh,
        child: favorites.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(child: Text(l10n.t('favorites_empty'))),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final car = favorites[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CarCard(
                      car: car,
                      onFavorite: () => carsController.toggleFavorite(car.id),
                      isFavorite: carsController.isFavorite(car.id),
                      onCompare: () => carsController.toggleCompare(car.id),
                      onDetails: () => Navigator.pushNamed(context, '/details/${car.id}'),
                      onImageTap: () => Navigator.pushNamed(context, '/details/${car.id}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
