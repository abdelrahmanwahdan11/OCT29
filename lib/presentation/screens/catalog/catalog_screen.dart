import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../domain/entities/car.dart';
import '../../widgets/car_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.carsController});

  final CarsController carsController;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    widget.carsController.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.carsController.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final controller = widget.carsController.scrollController;
    if (controller.position.pixels >= controller.position.maxScrollExtent * 0.75) {
      widget.carsController.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          IconButton(
            onPressed: () => widget.carsController.refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: widget.carsController.refresh,
        child: ValueListenableBuilder<List<Car>>(
          valueListenable: widget.carsController.listController,
          builder: (context, cars, _) {
            if (cars.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              controller: widget.carsController.scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CarCard(
                    car: car,
                    onTap: () => Navigator.pushNamed(context, '/details/${car.id}'),
                    onFavorite: () => widget.carsController.toggleFavorite(car.id),
                    isFavorite: widget.carsController.isFavorite(car.id),
                    onCompare: () => widget.carsController.toggleCompare(car.id),
                  ).animate().fade(duration: 300.ms, delay: (index * 40).ms).slide(begin: const Offset(0, 0.1)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
