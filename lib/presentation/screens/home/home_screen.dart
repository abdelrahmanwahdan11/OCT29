import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/recent_views_controller.dart';
import '../../../application/controllers/tutorial_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/car.dart';
import '../../../domain/enums/condition.dart';
import '../../widgets/car_card.dart';
import '../../widgets/hero_viewer.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/car_preview_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.appController,
    required this.carsController,
    required this.tutorialController,
    required this.recentViewsController,
  });

  final AppController appController;
  final CarsController carsController;
  final TutorialController tutorialController;
  final RecentViewsController recentViewsController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _cityOptions = <String>['Dubai', 'Riyadh', 'Abu Dhabi', 'Jeddah'];
  static const List<String> _brandOptions = <String>[
    'All',
    'Tesla',
    'BMW',
    'Audi',
    'Mercedes',
    'Toyota',
    'Hyundai',
    'Ferrari',
  ];

  String _selectedCity = _cityOptions.first;
  Condition? _selectedCondition;
  String _selectedBrand = _brandOptions.first;
  late final TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController();
  }

  @override
  void dispose() {
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final featured = widget.carsController.featuredController;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.t('home_title_primary'),
                                style: theme.textTheme.headlineMedium?.copyWith(
                                      color: colors.onBackground,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.t('home_subtitle'),
                                style: theme.textTheme.bodyMedium?.copyWith(color: colors.subtext),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(IconlyLight.more_circle, color: colors.onSurface),
                          onPressed: () => Navigator.pushNamed(context, '/settings'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSearchCard(context),
                    const SizedBox(height: 24),
                    Text(l10n.t('brands'), style: theme.textTheme.titleMedium?.copyWith(color: colors.onSurface)),
                    const SizedBox(height: 12),
                    _BrandSelector(
                      selected: _selectedBrand,
                      brands: _brandOptions,
                      onSelected: _applyBrand,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ValueListenableBuilder<List<Car>>(
                  valueListenable: featured,
                  builder: (context, cars, _) {
                    if (cars.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(color: colors.accent),
                      );
                    }
                    return SizedBox(
                      height: 320,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          return _FeaturedCard(car: car, controller: widget.carsController);
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemCount: cars.length,
                      ).animate().fade(duration: 400.ms).slide(begin: const Offset(0.2, 0)),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.t('featured_spins'), style: theme.textTheme.titleMedium?.copyWith(color: colors.onSurface)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/catalog'),
                      child: Text(
                        l10n.t('view_all'),
                        style: theme.textTheme.labelLarge?.copyWith(color: colors.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<List<Car>>(
              valueListenable: widget.carsController.listController,
              builder: (context, cars, _) {
                if (cars.isEmpty) {
                  if (widget.carsController.isLoading) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: SkeletonCard(),
                        ),
                        childCount: 3,
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        children: [
                          Icon(Icons.directions_car_filled, color: colors.subtext, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            l10n.t('no_cars_found'),
                            style: theme.textTheme.titleMedium?.copyWith(color: colors.onSurface),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.t('adjust_filters'),
                            style: theme.textTheme.bodySmall?.copyWith(color: colors.subtext),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= cars.length) {
                        return const SizedBox.shrink();
                      }
                      final car = cars[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: CarCard(
                          car: car,
                          onFavorite: () => widget.carsController.toggleFavorite(car.id),
                          isFavorite: widget.carsController.isFavorite(car.id),
                          onCompare: () => widget.carsController.toggleCompare(car.id),
                          onDetails: () => Navigator.pushNamed(context, '/details/${car.id}'),
                          onImageTap: () => _showOverlay(car),
                        ).animate().fade(duration: 400.ms, delay: (index * 60).ms).slide(begin: const Offset(0, 0.1)),
                      );
                    },
                    childCount: cars.length,
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: widget.recentViewsController,
                builder: (context, _) {
                  final recent = widget.recentViewsController.recentCars;
                  if (recent.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.t('recent_views'),
                          style: theme.textTheme.titleMedium?.copyWith(color: colors.onSurface),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final car = recent[index];
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/details/${car.id}'),
                                child: Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: colors.card,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.network(car.images.first, fit: BoxFit.cover, width: double.infinity),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        car.title,
                                        style: theme.textTheme.labelLarge?.copyWith(color: colors.onSurface),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${car.currency} ${car.price.toStringAsFixed(0)}',
                                        style: theme.textTheme.labelMedium?.copyWith(color: colors.accent),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemCount: recent.length,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 72)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final conditionLabel = _selectedCondition == null
        ? l10n.t('all')
        : _selectedCondition == Condition.newCar
            ? l10n.t('new')
            : l10n.t('used');
    final brandLabel = _selectedBrand == 'All' ? l10n.t('all') : _selectedBrand;
    final cityLabel = _selectedCity == 'All' ? l10n.t('all') : _selectedCity;
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _SearchField(
                  label: l10n.t('city'),
                  value: cityLabel,
                  icon: IconlyBold.location,
                  onTap: () => _selectCity(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SearchField(
                  label: l10n.t('condition'),
                  value: conditionLabel,
                  icon: IconlyBold.category,
                  onTap: () => _selectCondition(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SearchField(
                  label: l10n.t('brand'),
                  value: brandLabel,
                  icon: IconlyBold.ticket,
                  onTap: () => _selectBrand(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    labelText: l10n.t('model'),
                    prefixIcon: Icon(IconlyBold.edit, color: colors.subtext),
                  ),
                  onChanged: widget.carsController.updateSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              widget.carsController.updateSearch(_modelController.text.trim());
            },
            child: Text(l10n.t('search_car')),
          ),
        ],
      ),
    );
  }

  Future<void> _selectCity(BuildContext context) async {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final selection = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.t('all')),
              onTap: () => Navigator.pop(context, 'all'),
            ),
            for (final city in _cityOptions)
              ListTile(
                title: Text(city),
                onTap: () => Navigator.pop(context, city),
              ),
          ],
        ),
      ),
    );
    if (selection == null) return;
    if (selection == 'all') {
      setState(() => _selectedCity = 'All');
      widget.carsController.updateFilter(
        widget.carsController.filter.copyWith(clearCity: true),
      );
    } else {
      setState(() => _selectedCity = selection);
      widget.carsController.updateFilter(
        widget.carsController.filter.copyWith(city: selection),
      );
    }
  }

  Future<void> _selectCondition(BuildContext context) async {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final selection = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.t('all')),
              onTap: () => Navigator.pop(context, 'all'),
            ),
            ListTile(
              title: Text(l10n.t('new')),
              onTap: () => Navigator.pop(context, 'new'),
            ),
            ListTile(
              title: Text(l10n.t('used')),
              onTap: () => Navigator.pop(context, 'used'),
            ),
          ],
        ),
      ),
    );
    if (selection == null) return;
    final filter = widget.carsController.filter;
    if (selection == 'all') {
      setState(() => _selectedCondition = null);
      widget.carsController.updateFilter(
        filter.copyWith(condition: null, clearCondition: true),
      );
    } else {
      final condition = selection == 'new' ? Condition.newCar : Condition.used;
      setState(() => _selectedCondition = condition);
      widget.carsController.updateFilter(
        filter.copyWith(condition: condition),
      );
    }
  }

  Future<void> _selectBrand(BuildContext context) async {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final selection = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final brand in _brandOptions)
              ListTile(
                title: Text(brand == 'All' ? l10n.t('all') : brand),
                onTap: () => Navigator.pop(context, brand),
              ),
          ],
        ),
      ),
    );
    if (selection != null) {
      _applyBrand(selection);
    }
  }

  void _applyBrand(String brand) {
    setState(() => _selectedBrand = brand);
    final filter = widget.carsController.filter;
    if (brand == 'All') {
      widget.carsController.updateFilter(
        filter.copyWith(clearBrands: true),
      );
    } else {
      widget.carsController.updateFilter(
        filter.copyWith(brands: <String>{brand}),
      );
    }
  }

  void _showOverlay(Car car) {
    showCarPreviewDialog(
      context: context,
      car: car,
      onViewDetails: () => Navigator.pushNamed(context, '/details/${car.id}'),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.label, required this.value, required this.icon, required this.onTap});

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.of(context).cardAlt,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.of(context).divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.of(context).subtext),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.of(context).subtext,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.of(context).onSurface),
                  ),
                ],
              ),
            ),
            Icon(IconlyLight.arrow_down_2, size: 18, color: AppColors.of(context).subtext),
          ],
        ),
      ),
    );
  }
}

class _BrandSelector extends StatefulWidget {
  const _BrandSelector({required this.selected, required this.brands, required this.onSelected});

  final String selected;
  final List<String> brands;
  final ValueChanged<String> onSelected;

  @override
  State<_BrandSelector> createState() => _BrandSelectorState();
}

class _BrandSelectorState extends State<_BrandSelector> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final brand = widget.brands[index];
          final isSelected = widget.selected == brand;
          return ChoiceChip(
            label: Text(brand == 'All' ? l10n.t('all') : brand),
            selected: isSelected,
            onSelected: (_) => widget.onSelected(brand),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: widget.brands.length,
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.car, required this.controller});

  final Car car;
  final CarsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/details/${car.id}'),
        child: HeroViewer(car: car),
      ),
    );
  }
}
