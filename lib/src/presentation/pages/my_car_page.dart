import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../components/eink_scaffold.dart';

class MyCarPage extends StatelessWidget {
  const MyCarPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('سيارتي')),
      body: ValueListenableBuilder<List<Car>>(
        valueListenable: controllers.myCarController.cars,
        builder: (context, cars, _) {
          if (cars.isEmpty) {
            return const Center(child: Text('أضف سياراتك هنا'));
          }
          return ListView.separated(
            itemCount: cars.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                title: Text(car.fullName),
                subtitle: Text('${car.year} - ${car.mileageKm} كم'),
                trailing: TextButton(onPressed: () {}, child: const Text('تعديل')),
              );
            },
          );
        },
      ),
    );
  }
}
