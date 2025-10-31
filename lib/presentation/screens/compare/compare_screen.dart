import 'package:flutter/material.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key, required this.carsController});

  final CarsController carsController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final compared = carsController.compareSet.ids
        .map((id) => carsController.findById(id))
        .whereType<Car>()
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('compare'))),
      body: RefreshIndicator(
        onRefresh: carsController.refresh,
        child: compared.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(child: Text(l10n.t('compare_empty'))),
                ],
              )
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Spec')),
                        DataColumn(label: Text('Car 1')),
                        DataColumn(label: Text('Car 2')),
                        DataColumn(label: Text('Car 3')),
                      ],
                      rows: _buildRows(compared),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<DataRow> _buildRows(List<Car> cars) {
    final specs = <String, String Function(Car)>{
      'Price': (car) => '${car.currency} ${car.price.toStringAsFixed(0)}',
      'Year': (car) => car.year.toString(),
      'Fuel': (car) => car.fuel.labelEn,
      'Transmission': (car) => car.transmission.labelEn,
      'Horsepower': (car) => '${car.horsepower} hp',
      'Seats': (car) => car.seats.toString(),
      'Mileage': (car) => '${car.mileageKm} km',
      'Top speed': (car) => '${car.topSpeedKmh} km/h',
      'Battery range': (car) => car.batteryRangeKm != null ? '${car.batteryRangeKm} km' : '—',
    };

    return specs.entries.map((entry) {
      return DataRow(
        cells: [
          DataCell(Text(entry.key)),
          for (var i = 0; i < 3; i++)
            DataCell(Text(i < cars.length ? entry.value(cars[i]) : '—')),
        ],
      );
    }).toList();
  }
}
