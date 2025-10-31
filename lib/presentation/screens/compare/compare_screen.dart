import 'package:flutter/material.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/car.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key, required this.carsController});

  final CarsController carsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: carsController,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final colors = AppColors.of(context);
        final compared = carsController.compareSet.ids
            .map((id) => carsController.findById(id))
            .whereType<Car>()
            .toList();
        final locale = Localizations.localeOf(context);
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final car in compared)
                            InputChip(
                              label: Text(car.title),
                              onDeleted: () {
                                carsController.removeFromCompare(car.id);
                              },
                              deleteIcon: const Icon(Icons.close),
                              backgroundColor: colors.card,
                              deleteIconColor: colors.subtext,
                            ),
                          if (compared.isNotEmpty)
                            ActionChip(
                              label: Text(l10n.t('clear_all')),
                              avatar: Icon(Icons.delete_sweep, color: colors.accent),
                              onPressed: () {
                                carsController.clearCompare();
                              },
                              backgroundColor: colors.cardAlt,
                              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onSurface),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600),
                          columns: [
                            DataColumn(label: Text(l10n.t('spec'))),
                            DataColumn(label: Text('${l10n.t('car')} 1')),
                            DataColumn(label: Text('${l10n.t('car')} 2')),
                            DataColumn(label: Text('${l10n.t('car')} 3')),
                          ],
                          rows: _buildRows(
                            compared,
                            l10n,
                            locale,
                            colors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  List<DataRow> _buildRows(
    List<Car> cars,
    AppLocalizations l10n,
    Locale locale,
    Color highlightColor,
  ) {
    final specs = <_SpecRowData>[
      _SpecRowData(
        key: 'price',
        label: l10n.t('price'),
        valueBuilder: (car) => '${car.currency} ${car.price.toStringAsFixed(0)}',
        highlightType: _HighlightType.lower,
      ),
      _SpecRowData(
        key: 'year',
        label: l10n.t('year'),
        valueBuilder: (car) => car.year.toString(),
        highlightType: _HighlightType.higher,
      ),
      _SpecRowData(
        key: 'fuel',
        label: l10n.t('fuel'),
        valueBuilder: (car) => locale.languageCode == 'ar' ? car.fuel.labelAr : car.fuel.labelEn,
      ),
      _SpecRowData(
        key: 'transmission',
        label: l10n.t('transmission'),
        valueBuilder: (car) => locale.languageCode == 'ar' ? car.transmission.labelAr : car.transmission.labelEn,
      ),
      _SpecRowData(
        key: 'horsepower',
        label: l10n.t('horsepower'),
        valueBuilder: (car) => '${car.horsepower} hp',
        highlightType: _HighlightType.higher,
      ),
      _SpecRowData(
        key: 'seats',
        label: l10n.t('seats'),
        valueBuilder: (car) => car.seats.toString(),
      ),
      _SpecRowData(
        key: 'mileage',
        label: l10n.t('mileage'),
        valueBuilder: (car) => '${car.mileageKm} km',
        highlightType: _HighlightType.lower,
      ),
      _SpecRowData(
        key: 'top_speed',
        label: l10n.t('top_speed'),
        valueBuilder: (car) => '${car.topSpeedKmh} km/h',
      ),
      _SpecRowData(
        key: 'battery_range',
        label: l10n.t('battery_range'),
        valueBuilder: (car) => car.batteryRangeKm != null ? '${car.batteryRangeKm} km' : '—',
      ),
    ];

    return specs.map((spec) {
      final values = List<String>.generate(
        3,
        (index) => index < cars.length ? spec.valueBuilder(cars[index]) : '—',
      );
      final highlights = _bestIndexes(spec, cars);
      return DataRow(
        cells: [
          DataCell(Text(spec.label)),
          for (var i = 0; i < 3; i++)
            DataCell(
              Text(
                values[i],
                style: highlights.contains(i)
                    ? TextStyle(color: highlightColor, fontWeight: FontWeight.bold)
                    : null,
              ),
            ),
        ],
      );
    }).toList();
  }

  List<int> _bestIndexes(_SpecRowData spec, List<Car> cars) {
    if (cars.isEmpty) {
      return const <int>[];
    }
    switch (spec.highlightType) {
      case _HighlightType.lower:
        final minValue = spec.key == 'price'
            ? cars.map((car) => car.price).reduce((a, b) => a < b ? a : b)
            : cars.map((car) => car.mileageKm).reduce((a, b) => a < b ? a : b);
        return _indicesWhere(cars, (car) {
          if (spec.key == 'price') return car.price == minValue;
          return car.mileageKm == minValue;
        });
      case _HighlightType.higher:
        final maxValue = spec.key == 'horsepower'
            ? cars.map((car) => car.horsepower).reduce((a, b) => a > b ? a : b)
            : cars.map((car) => car.year).reduce((a, b) => a > b ? a : b);
        return _indicesWhere(cars, (car) {
          if (spec.key == 'horsepower') return car.horsepower == maxValue;
          return car.year == maxValue;
        });
      case _HighlightType.none:
        return const <int>[];
    }
  }

  List<int> _indicesWhere(List<Car> cars, bool Function(Car) predicate) {
    final indices = <int>[];
    for (var i = 0; i < cars.length; i++) {
      if (predicate(cars[i])) {
        indices.add(i);
      }
    }
    return indices;
  }
}

class _SpecRowData {
  const _SpecRowData({
    required this.key,
    required this.label,
    required this.valueBuilder,
    this.highlightType = _HighlightType.none,
  });

  final String key;
  final String label;
  final String Function(Car) valueBuilder;
  final _HighlightType highlightType;
}

enum _HighlightType { none, higher, lower }
