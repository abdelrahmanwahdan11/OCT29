import 'package:flutter/material.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../domain/entities/car.dart';
import '../../widgets/car_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.carsController});

  final CarsController carsController;

  @override
  Widget build(BuildContext context) {
    final favorites = carsController.favoriteIds
        .map((id) => carsController.findById(id))
        .whereType<Car>()
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final car = favorites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CarCard(
                    car: car,
                    onTap: () => Navigator.pushNamed(context, '/details/${car.id}'),
                    onFavorite: () => carsController.toggleFavorite(car.id),
                    isFavorite: carsController.isFavorite(car.id),
                    onCompare: () => carsController.toggleCompare(car.id),
                  ),
                );
              },
            ),
    );
  }
}
