import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../components/eink_scaffold.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('المقارنة')),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: controllers.compareController.selected,
        builder: (context, ids, _) {
          final cars = controllers.catalogController.filteredCars.value.where((car) => ids.contains(car.id)).toList();
          if (cars.isEmpty) {
            return const Center(child: Text('أضف سيارات للمقارنة'));
          }
          final specs = <String, String Function(Car)>>{
            'السعر': (car) => '${car.price} ${car.currency}',
            'القوة': (car) => '${car.hp} hp',
            'المحرك': (car) => '${car.engineCc} cc',
          };
          return Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cars
                      .map(
                        (car) => Container(
                          width: 160,
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(car.fullName, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              Image.network(car.images.isNotEmpty ? car.images.first : 'https://picsum.photos/seed/${car.id}/120/80', height: 80, fit: BoxFit.cover),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: ListView(
                  children: specs.entries
                      .map(
                        (entry) => ListTile(
                          title: Text(entry.key),
                          subtitle: Row(
                            children: cars.map((car) => Expanded(child: Text(entry.value(car), textAlign: TextAlign.center))).toList(),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              TextButton(onPressed: () => controllers.compareController.clear(), child: const Text('مسح الكل')),
            ],
          );
        },
      ),
    );
  }
}
