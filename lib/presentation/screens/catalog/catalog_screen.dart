import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/saved_search_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';
import '../../../domain/enums/condition.dart';
import '../../../domain/enums/fuel_type.dart';
import '../../../domain/enums/transmission.dart';
import '../../widgets/car_card.dart';
import '../../widgets/hero_viewer.dart';
import '../../widgets/skeletons.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
    required this.carsController,
    required this.savedSearchController,
  });

  final CarsController carsController;
  final SavedSearchController savedSearchController;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.carsController.searchTerm);
    widget.carsController.scrollController.addListener(_handleScroll);
    widget.savedSearchController.addListener(_handleSavedSearchApplied);
  }

  @override
  void dispose() {
    widget.carsController.scrollController.removeListener(_handleScroll);
    widget.savedSearchController.removeListener(_handleSavedSearchApplied);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSavedSearchApplied() {
    setState(() {
      _searchController.text = widget.carsController.searchTerm;
    });
  }

  void _handleScroll() {
    final controller = widget.carsController.scrollController;
    if (!controller.hasClients) return;
    if (controller.position.pixels >= controller.position.maxScrollExtent * 0.9) {
      widget.carsController.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.carsController,
      builder: (context, _) {
        final isLoading = widget.carsController.isLoading;
        final isLoadingMore = widget.carsController.isLoadingMore;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.t('catalog')),
            actions: [
              IconButton(
                icon: const Icon(Icons.save_alt),
                tooltip: l10n.t('save_search'),
                onPressed: () async {
                  final query = _searchController.text.trim().isEmpty
                      ? '${l10n.t('search')} ${DateTime.now().hour}:${DateTime.now().minute}'
                      : _searchController.text.trim();
                  await widget.savedSearchController.addSearch(query, widget.carsController.filter);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.t('search_saved'))));
                  }
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: widget.carsController.refresh,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: l10n.t('search'),
                          ),
                          onChanged: widget.carsController.updateSearch,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _openFilterSheet,
                        icon: const Icon(Icons.filter_alt),
                        label: Text(l10n.t('filter')),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? _buildSkeletons()
                      : ValueListenableBuilder<List<Car>>(
                          valueListenable: widget.carsController.listController,
                          builder: (context, cars, _) {
                            if (cars.isEmpty) {
                              return _EmptyState(
                                onReset: widget.carsController.clearFilters,
                                message: l10n.t('no_cars_found'),
                                actionLabel: l10n.t('adjust_filters'),
                              );
                            }
                            return ListView.builder(
                              controller: widget.carsController.scrollController,
                              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                              itemCount: isLoadingMore ? cars.length + 1 : cars.length,
                              itemBuilder: (context, index) {
                                if (index >= cars.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                final car = cars[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: _SwipeActions(
                                    onFavorite: () => widget.carsController.toggleFavorite(car.id),
                                    onCompare: () => widget.carsController.toggleCompare(car.id),
                                    child: CarCard(
                                      car: car,
                                     onFavorite: () => widget.carsController.toggleFavorite(car.id),
                                     isFavorite: widget.carsController.isFavorite(car.id),
                                     onCompare: () => widget.carsController.toggleCompare(car.id),
                                     onDetails: () => Navigator.pushNamed(context, '/details/${car.id}'),
                                     onImageTap: () => _showOverlay(car),
                                    ),
                                  ).animate().fade(duration: 320.ms, delay: (index * 40).ms).slide(begin: const Offset(0, 0.1)),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletons() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      itemCount: 10,
      itemBuilder: (_, __) => const SkeletonCard(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }

  void _openFilterSheet() {
    final l10n = AppLocalizations.of(context);
    final filter = widget.carsController.filter;
    final brands = <String>['Tesla', 'BMW', 'Audi', 'Mercedes', 'Toyota', 'Hyundai', 'Ferrari'];
    Set<String> selectedBrands = Set<String>.from(filter.brands);
    Condition? selectedCondition = filter.condition;
    RangeValues priceRange = RangeValues(filter.minPrice ?? 0, filter.maxPrice ?? 500000);
    RangeValues yearRange = RangeValues((filter.minYear ?? 1990).toDouble(), (filter.maxYear ?? 2026).toDouble());
    RangeValues mileageRange = RangeValues((filter.minMileage ?? 0).toDouble(), (filter.maxMileage ?? 300000).toDouble());
    Set<FuelType> fuels = Set<FuelType>.from(filter.fuels);
    Set<Transmission> transmissions = Set<Transmission>.from(filter.transmissions);
    Set<int> seats = Set<int>.from(filter.seats);
    final cityController = TextEditingController(text: filter.city ?? '');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.t('filter'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.t('brands')),
                    Wrap(
                      spacing: 8,
                      children: brands
                          .map(
                            (brand) => FilterChip(
                              label: Text(brand),
                              selected: selectedBrands.contains(brand),
                              onSelected: (value) {
                                setState(() {
                                  if (value) {
                                    selectedBrands.add(brand);
                                  } else {
                                    selectedBrands.remove(brand);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.t('condition')),
                    SegmentedButton<Condition?>(
                      segments: const <ButtonSegment<Condition?>>[
                        ButtonSegment(value: null, label: Text('All')),
                        ButtonSegment(value: Condition.newCar, label: Text('New')),
                        ButtonSegment(value: Condition.used, label: Text('Used')),
                      ],
                      selected: <Condition?>{selectedCondition},
                      onSelectionChanged: (value) => setState(() => selectedCondition = value.first),
                    ),
                    const SizedBox(height: 16),
                    const Text('Price'),
                    RangeSlider(
                      min: 0,
                      max: 500000,
                      divisions: 50,
                      values: priceRange,
                      labels: RangeLabels(priceRange.start.toStringAsFixed(0), priceRange.end.toStringAsFixed(0)),
                      onChanged: (values) => setState(() => priceRange = values),
                    ),
                    const Text('Year'),
                    RangeSlider(
                      min: 1990,
                      max: 2026,
                      divisions: 36,
                      values: yearRange,
                      labels: RangeLabels(yearRange.start.toStringAsFixed(0), yearRange.end.toStringAsFixed(0)),
                      onChanged: (values) => setState(() => yearRange = values),
                    ),
                    const Text('Mileage'),
                    RangeSlider(
                      min: 0,
                      max: 300000,
                      divisions: 30,
                      values: mileageRange,
                      labels: RangeLabels(mileageRange.start.toStringAsFixed(0), mileageRange.end.toStringAsFixed(0)),
                      onChanged: (values) => setState(() => mileageRange = values),
                    ),
                    const SizedBox(height: 16),
                    const Text('Fuel'),
                    Wrap(
                      spacing: 8,
                      children: FuelType.values
                          .map(
                            (fuel) => FilterChip(
                              label: Text(fuel.labelEn),
                              selected: fuels.contains(fuel),
                              onSelected: (value) => setState(() {
                                if (value) {
                                  fuels.add(fuel);
                                } else {
                                  fuels.remove(fuel);
                                }
                              }),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Transmission'),
                    Wrap(
                      spacing: 8,
                      children: Transmission.values
                          .map(
                            (transmission) => FilterChip(
                              label: Text(transmission.labelEn),
                              selected: transmissions.contains(transmission),
                              onSelected: (value) => setState(() {
                                if (value) {
                                  transmissions.add(transmission);
                                } else {
                                  transmissions.remove(transmission);
                                }
                              }),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Seats'),
                    Wrap(
                      spacing: 8,
                      children: <int>[2, 4, 5, 7]
                          .map(
                            (seat) => ChoiceChip(
                              label: Text('$seat'),
                              selected: seats.contains(seat),
                              onSelected: (value) => setState(() {
                                if (value) {
                                  seats.add(seat);
                                } else {
                                  seats.remove(seat);
                                }
                              }),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.carsController.clearFilters();
                          },
                          child: Text(l10n.t('clear')),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            widget.carsController.updateFilter(
                              CarsFilter(
                                brands: selectedBrands,
                                condition: selectedCondition,
                                minPrice: priceRange.start,
                                maxPrice: priceRange.end,
                                minYear: yearRange.start.toInt(),
                                maxYear: yearRange.end.toInt(),
                                minMileage: mileageRange.start.toInt(),
                                maxMileage: mileageRange.end.toInt(),
                                fuels: fuels,
                                transmissions: transmissions,
                                seats: seats,
                                city: cityController.text.trim().isEmpty ? null : cityController.text.trim(),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(l10n.t('apply')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOverlay(Car car) {
    final l10n = AppLocalizations.of(context);
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'preview',
      transitionDuration: 240.ms,
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 360,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeroViewer(car: car),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(car.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/details/${car.id}');
                              },
                              child: Text(l10n.t('view_details')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
      },
    );
  }
}

class _SwipeActions extends StatelessWidget {
  const _SwipeActions({
    required this.child,
    required this.onFavorite,
    required this.onCompare,
  });

  final Widget child;
  final VoidCallback onFavorite;
  final Future<bool> Function() onCompare;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: _ActionBackground(icon: Icons.favorite, alignment: Alignment.centerLeft),
      secondaryBackground: _ActionBackground(icon: Icons.compare_arrows, alignment: Alignment.centerRight),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onFavorite();
        } else {
          await onCompare();
        }
        return false;
      },
      child: child,
    );
  }
}

class _ActionBackground extends StatelessWidget {
  const _ActionBackground({required this.icon, required this.alignment});

  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: alignment,
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset, required this.message, required this.actionLabel});

  final VoidCallback onReset;
  final String message;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sentiment_dissatisfied, size: 48),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onReset, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
