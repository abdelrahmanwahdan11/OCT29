import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/saved_search_controller.dart';
import '../../../application/controllers/settings_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';
import '../../../domain/enums/condition.dart';
import '../../../domain/enums/fuel_type.dart';
import '../../../domain/enums/transmission.dart';
import '../../widgets/car_card.dart';
import '../../widgets/hero_viewer.dart';
import '../../widgets/car_preview_dialog.dart';
import '../../widgets/skeletons.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
    required this.carsController,
    required this.savedSearchController,
    required this.settingsController,
  });

  final CarsController carsController;
  final SavedSearchController savedSearchController;
  final SettingsController settingsController;

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
      animation: Listenable.merge(<Listenable>[widget.carsController, widget.settingsController]),
      builder: (context, _) {
        final bool isLoading = widget.carsController.isLoading;
        final bool isLoadingMore = widget.carsController.isLoadingMore;
        final bool isGrid = widget.settingsController.isCatalogGrid;
        final SortMode sortMode = widget.carsController.sortMode;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.t('catalog')),
            actions: [
              PopupMenuButton<SortMode>(
                tooltip: l10n.t('sort'),
                initialValue: sortMode,
                onSelected: widget.carsController.updateSort,
                itemBuilder: (context) => <PopupMenuEntry<SortMode>>[
                  _buildSortEntry(context, SortMode.newest, l10n.t('newest'), sortMode),
                  _buildSortEntry(context, SortMode.priceAsc, l10n.t('price_asc'), sortMode),
                  _buildSortEntry(context, SortMode.priceDesc, l10n.t('price_desc'), sortMode),
                  _buildSortEntry(context, SortMode.yearAsc, l10n.t('year_asc'), sortMode),
                  _buildSortEntry(context, SortMode.yearDesc, l10n.t('year_desc'), sortMode),
                  _buildSortEntry(context, SortMode.mileageAsc, l10n.t('mileage_asc'), sortMode),
                  _buildSortEntry(context, SortMode.mileageDesc, l10n.t('mileage_desc'), sortMode),
                ],
                icon: const Icon(Icons.sort),
              ),
              IconButton(
                tooltip: isGrid ? l10n.t('list') : l10n.t('grid'),
                onPressed: widget.settingsController.toggleCatalogLayout,
                icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: widget.carsController.refresh,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool compact = constraints.maxWidth < 640;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (compact)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Semantics(
                                  label: l10n.t('search'),
                                  textField: true,
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: l10n.t('search'),
                                    ),
                                    onChanged: widget.carsController.updateSearch,
                                    textInputAction: TextInputAction.search,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FilledButton.icon(
                                  onPressed: _openFilterSheet,
                                  icon: const Icon(Icons.filter_alt),
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(52),
                                  ),
                                  label: Text(l10n.t('filter')),
                                ),
                              ],
                            )
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Semantics(
                                    label: l10n.t('search'),
                                    textField: true,
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.search),
                                        hintText: l10n.t('search'),
                                      ),
                                      onChanged: widget.carsController.updateSearch,
                                      textInputAction: TextInputAction.search,
                                    ),
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
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              icon: const Icon(Icons.bookmark_add_outlined),
                              label: Text(l10n.t('save_search')),
                              onPressed: () => _onSaveSearch(context, l10n),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildActiveFilterRow(context, l10n),
                        ],
                      );
                    },
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
                                onReset: () {
                                  widget.carsController.clearFilters();
                                  widget.carsController.updateSearch('');
                                },
                                message: l10n.t('no_cars_found'),
                                actionLabel: l10n.t('adjust_filters'),
                              );
                            }
                            return AnimatedSwitcher(
                              duration: 300.ms,
                              child: isGrid
                                  ? _buildGrid(cars, isLoadingMore, l10n)
                                  : _buildList(cars, isLoadingMore, l10n),
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

  PopupMenuItem<SortMode> _buildSortEntry(
    BuildContext context,
    SortMode mode,
    String label,
    SortMode current,
  ) {
    return PopupMenuItem<SortMode>(
      value: mode,
      child: Row(
        children: [
          if (mode == current) const Icon(Icons.check, size: 18) else const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildList(List<Car> cars, bool isLoadingMore, AppLocalizations l10n) {
    return ListView.builder(
      controller: widget.carsController.scrollController,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      physics: const AlwaysScrollableScrollPhysics(),
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
              onImageTap: () => _showOverlay(car, l10n),
            ),
          ).animate().fade(duration: 320.ms, delay: (index * 40).ms).slide(begin: const Offset(0, 0.08)),
        );
      },
    );
  }

  Widget _buildGrid(List<Car> cars, bool isLoadingMore, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount;
        final double aspectRatio;
        if (width >= 1200) {
          crossAxisCount = 3;
          aspectRatio = 0.88;
        } else if (width >= 840) {
          crossAxisCount = 2;
          aspectRatio = 0.82;
        } else {
          crossAxisCount = 1;
          aspectRatio = 0.74;
        }
        return GridView.builder(
          controller: widget.carsController.scrollController,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspectRatio,
          ),
          itemCount: isLoadingMore ? cars.length + 1 : cars.length,
          itemBuilder: (context, index) {
            if (index >= cars.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final car = cars[index];
            return CarCard(
              car: car,
              onFavorite: () => widget.carsController.toggleFavorite(car.id),
              isFavorite: widget.carsController.isFavorite(car.id),
              onCompare: () => widget.carsController.toggleCompare(car.id),
              onDetails: () => Navigator.pushNamed(context, '/details/${car.id}'),
              onImageTap: () => _showOverlay(car, l10n),
            ).animate().fade(duration: 280.ms, delay: (index * 24).ms).scale(begin: const Offset(0.98, 0.98));
          },
        );
      },
    );
  }

  Widget _buildSkeletons() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, __) => const SkeletonCard(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }

  void _onSaveSearch(BuildContext context, AppLocalizations l10n) async {
    final query = _searchController.text.trim().isEmpty
        ? '${l10n.t('search')} ${TimeOfDay.now().format(context)}'
        : _searchController.text.trim();
    await widget.savedSearchController.addSearch(query, widget.carsController.filter);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.t('search_saved'))));
  }

  void _openFilterSheet() {
    final l10n = AppLocalizations.of(context);
    final filter = widget.carsController.filter;
    final locale = Localizations.localeOf(context);
    final brands = <String>['Tesla', 'BMW', 'Audi', 'Mercedes', 'Toyota', 'Hyundai', 'Ferrari'];
    Set<String> selectedBrands = Set<String>.from(filter.brands);
    Condition? selectedCondition = filter.condition;
    RangeValues priceRange = RangeValues((filter.minPrice ?? 0).toDouble(), (filter.maxPrice ?? 500000).toDouble());
    RangeValues yearRange = RangeValues((filter.minYear ?? 1990).toDouble(), (filter.maxYear ?? 2026).toDouble());
    RangeValues mileageRange = RangeValues((filter.minMileage ?? 0).toDouble(), (filter.maxMileage ?? 300000).toDouble());
    Set<FuelType> fuels = Set<FuelType>.from(filter.fuels);
    Set<Transmission> transmissions = Set<Transmission>.from(filter.transmissions);
    Set<int> seats = Set<int>.from(filter.seats);
    final cityController = TextEditingController(text: filter.city ?? '');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(l10n.t('filter'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          ),
                          IconButton(
                            tooltip: l10n.t('close'),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.t('brands')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: brands
                            .map(
                              (brand) => FilterChip(
                                label: Text(brand),
                                selected: selectedBrands.contains(brand),
                                onSelected: (value) => setModalState(() {
                                  if (value) {
                                    selectedBrands.add(brand);
                                  } else {
                                    selectedBrands.remove(brand);
                                  }
                                }),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.t('condition')),
                      const SizedBox(height: 8),
                      SegmentedButton<Condition?>(
                        segments: <ButtonSegment<Condition?>>[
                          ButtonSegment<Condition?>(value: null, label: Text(l10n.t('all'))),
                          ButtonSegment<Condition?>(value: Condition.newCar, label: Text(l10n.t('new'))),
                          ButtonSegment<Condition?>(value: Condition.used, label: Text(l10n.t('used'))),
                        ],
                        selected: <Condition?>{selectedCondition},
                        onSelectionChanged: (selection) => setModalState(() => selectedCondition = selection.first),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.t('price')),
                      RangeSlider(
                        min: 0,
                        max: 500000,
                        divisions: 50,
                        values: priceRange,
                        labels: RangeLabels(
                          _formatNumber(priceRange.start.toInt()),
                          _formatNumber(priceRange.end.toInt()),
                        ),
                        onChanged: (values) => setModalState(() => priceRange = values),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.t('year')),
                      RangeSlider(
                        min: 1990,
                        max: 2026,
                        divisions: 36,
                        values: yearRange,
                        labels: RangeLabels(
                          yearRange.start.toInt().toString(),
                          yearRange.end.toInt().toString(),
                        ),
                        onChanged: (values) => setModalState(() => yearRange = values),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.t('mileage')),
                      RangeSlider(
                        min: 0,
                        max: 300000,
                        divisions: 30,
                        values: mileageRange,
                        labels: RangeLabels(
                          _formatNumber(mileageRange.start.toInt()),
                          _formatNumber(mileageRange.end.toInt()),
                        ),
                        onChanged: (values) => setModalState(() => mileageRange = values),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.t('fuel')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: FuelType.values
                            .map(
                              (fuel) => FilterChip(
                                label: Text(_fuelLabel(fuel, locale)),
                                selected: fuels.contains(fuel),
                                onSelected: (value) => setModalState(() {
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
                      Text(l10n.t('transmission')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: Transmission.values
                            .map(
                              (transmission) => FilterChip(
                                label: Text(_transmissionLabel(transmission, locale)),
                                selected: transmissions.contains(transmission),
                                onSelected: (value) => setModalState(() {
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
                      Text(l10n.t('seats')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: <int>[2, 4, 5, 7]
                            .map(
                              (seat) => ChoiceChip(
                                label: Text('$seat'),
                                selected: seats.contains(seat),
                                onSelected: (value) => setModalState(() {
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
                        decoration: InputDecoration(labelText: l10n.t('city')),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.carsController.clearFilters();
                              widget.carsController.updateSearch('');
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
                                  minPrice: priceRange.start == 0 ? null : priceRange.start,
                                  maxPrice: priceRange.end == 500000 ? null : priceRange.end,
                                  minYear: yearRange.start.toInt() == 1990 ? null : yearRange.start.toInt(),
                                  maxYear: yearRange.end.toInt() == 2026 ? null : yearRange.end.toInt(),
                                  minMileage: mileageRange.start.toInt() == 0 ? null : mileageRange.start.toInt(),
                                  maxMileage: mileageRange.end.toInt() == 300000 ? null : mileageRange.end.toInt(),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActiveFilterRow(BuildContext context, AppLocalizations l10n) {
    final filter = widget.carsController.filter;
    final locale = Localizations.localeOf(context);
    final chips = <Widget>[];

    if (_searchController.text.trim().isNotEmpty) {
      chips.add(_buildChip(l10n.t('search'), _searchController.text.trim(), () {
        _searchController.clear();
        widget.carsController.updateSearch('');
      }));
    }

    for (final brand in filter.brands) {
      chips.add(_buildChip(l10n.t('brand'), brand, () {
        final next = filter.copyWith(brands: Set<String>.from(filter.brands)..remove(brand));
        widget.carsController.updateFilter(next);
      }));
    }

    if (filter.condition != null) {
      chips.add(_buildChip(l10n.t('condition'), _conditionLabel(filter.condition!, locale), () {
        widget.carsController.updateFilter(filter.copyWith(clearCondition: true));
      }));
    }

    if (filter.minPrice != null || filter.maxPrice != null) {
      final min = filter.minPrice != null ? _formatNumber(filter.minPrice!.toInt()) : '0';
      final max = filter.maxPrice != null ? _formatNumber(filter.maxPrice!.toInt()) : '500k';
      chips.add(_buildChip(l10n.t('price'), '$min – $max', () {
        widget.carsController.updateFilter(filter.copyWith(clearMinPrice: true, clearMaxPrice: true));
      }));
    }

    if (filter.minYear != null || filter.maxYear != null) {
      final min = filter.minYear?.toString() ?? '1990';
      final max = filter.maxYear?.toString() ?? '2026';
      chips.add(_buildChip(l10n.t('year'), '$min – $max', () {
        widget.carsController.updateFilter(filter.copyWith(clearMinYear: true, clearMaxYear: true));
      }));
    }

    if (filter.minMileage != null || filter.maxMileage != null) {
      final min = filter.minMileage != null ? _formatNumber(filter.minMileage!) : '0';
      final max = filter.maxMileage != null ? _formatNumber(filter.maxMileage!) : '300k';
      chips.add(_buildChip(l10n.t('mileage'), '$min – $max', () {
        widget.carsController.updateFilter(filter.copyWith(clearMinMileage: true, clearMaxMileage: true));
      }));
    }

    for (final fuel in filter.fuels) {
      chips.add(_buildChip(l10n.t('fuel'), _fuelLabel(fuel, locale), () {
        final updated = Set<FuelType>.from(filter.fuels)..remove(fuel);
        widget.carsController.updateFilter(filter.copyWith(fuels: updated));
      }));
    }

    for (final transmission in filter.transmissions) {
      chips.add(_buildChip(l10n.t('transmission'), _transmissionLabel(transmission, locale), () {
        final updated = Set<Transmission>.from(filter.transmissions)..remove(transmission);
        widget.carsController.updateFilter(filter.copyWith(transmissions: updated));
      }));
    }

    for (final seat in filter.seats) {
      chips.add(_buildChip(l10n.t('seats'), seat.toString(), () {
        final updated = Set<int>.from(filter.seats)..remove(seat);
        widget.carsController.updateFilter(filter.copyWith(seats: updated));
      }));
    }

    if (filter.city != null && filter.city!.isNotEmpty) {
      chips.add(_buildChip(l10n.t('city'), filter.city!, () {
        widget.carsController.updateFilter(filter.copyWith(clearCity: true));
      }));
    }

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    chips.add(ActionChip(
      label: Text(l10n.t('clear_all')),
      onPressed: () {
        _searchController.clear();
        widget.carsController.clearFilters();
        widget.carsController.updateSearch('');
      },
    ));

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildChip(String label, String value, VoidCallback onRemoved) {
    return InputChip(
      label: Text('$label: $value'),
      onDeleted: onRemoved,
    );
  }

  void _showOverlay(Car car, AppLocalizations l10n) {
    showCarPreviewDialog(
      context: context,
      car: car,
      onViewDetails: () => Navigator.pushNamed(context, '/details/${car.id}'),
    );
  }

  String _conditionLabel(Condition condition, Locale locale) {
    return locale.languageCode == 'ar' ? condition.labelAr : condition.labelEn;
  }

  String _fuelLabel(FuelType fuel, Locale locale) {
    return locale.languageCode == 'ar' ? fuel.labelAr : fuel.labelEn;
  }

  String _transmissionLabel(Transmission transmission, Locale locale) {
    return locale.languageCode == 'ar' ? transmission.labelAr : transmission.labelEn;
  }

  String _formatNumber(num value) {
    final digits = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1 && i != digits.length - 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
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
      background: const _ActionBackground(icon: Icons.favorite, alignment: Alignment.centerLeft),
      secondaryBackground: const _ActionBackground(icon: Icons.compare_arrows, alignment: Alignment.centerRight),
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
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Icon(Icons.directions_car, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Align(
          child: ElevatedButton(onPressed: onReset, child: Text(actionLabel)),
        ),
      ],
    );
  }
}
