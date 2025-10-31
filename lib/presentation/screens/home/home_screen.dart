import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/tutorial_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';
import '../../widgets/car_card.dart';
import '../../widgets/hero_viewer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.appController,
    required this.carsController,
    required this.tutorialController,
  });

  final AppController appController;
  final CarsController carsController;
  final TutorialController tutorialController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCity = 'Dubai';
  String _selectedCondition = 'All';
  String _selectedBrand = 'All';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final featured = widget.carsController.featuredController;
    return Scaffold(
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
                                'Buy a Car Anytime, Anywhere',
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Explore immersive 360° spins and smart comparisons.',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(IconlyLight.more_circle),
                          onPressed: () => Navigator.pushNamed(context, '/settings'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSearchCard(context),
                    const SizedBox(height: 24),
                    Text(l10n.t('brands'), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _BrandSelector(
                      selected: _selectedBrand,
                      onSelected: (brand) {
                        setState(() => _selectedBrand = brand);
                        if (brand == 'All') {
                          widget.carsController.clearFilter();
                        } else {
                          widget.carsController.updateFilter(widget.carsController.filter.copyWith(brands: <String>{brand}));
                        }
                      },
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
                      return const Center(child: CircularProgressIndicator());
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
                    Text('Featured 3D Spins', style: theme.textTheme.titleMedium),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/catalog'),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<List<Car>>(
              valueListenable: widget.carsController.listController,
              builder: (context, cars, _) {
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
                          onTap: () => Navigator.pushNamed(context, '/details/${car.id}'),
                          onFavorite: () => widget.carsController.toggleFavorite(car.id),
                          isFavorite: widget.carsController.isFavorite(car.id),
                          onCompare: () => widget.carsController.toggleCompare(car.id),
                        ).animate().fade(duration: 400.ms, delay: (index * 60).ms).slide(begin: const Offset(0, 0.1)),
                      );
                    },
                    childCount: cars.length,
                  ),
                );
              },
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 72)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.15),
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
                  label: 'City',
                  value: _selectedCity,
                  icon: IconlyBold.location,
                  onTap: () async {
                    final cities = <String>['Dubai', 'Riyadh', 'Abu Dhabi', 'Jeddah'];
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      builder: (_) => ListView(
                        shrinkWrap: true,
                        children: cities
                            .map(
                              (city) => ListTile(
                                title: Text(city),
                                onTap: () => Navigator.pop(context, city),
                              ),
                            )
                            .toList(),
                      ),
                    );
                    if (selected != null) {
                      setState(() => _selectedCity = selected);
                      widget.carsController.updateFilter(
                        widget.carsController.filter.copyWith(city: selected),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SearchField(
                  label: 'Condition',
                  value: _selectedCondition,
                  icon: IconlyBold.category,
                  onTap: () async {
                    final options = <String>['All', 'New', 'Used'];
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      builder: (_) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: options
                            .map(
                              (option) => ListTile(
                                title: Text(option),
                                onTap: () => Navigator.pop(context, option),
                              ),
                            )
                            .toList(),
                      ),
                    );
                    if (selected != null) {
                      setState(() => _selectedCondition = selected);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SearchField(
                  label: 'Brand',
                  value: _selectedBrand,
                  icon: IconlyBold.ticket,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Model', prefixIcon: Icon(IconlyBold.edit)),
                  onChanged: widget.carsController.updateSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.carsController.updateSearch(_selectedBrand),
            child: const Text('Search Car'),
          ),
        ],
      ),
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
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(IconlyLight.arrow_down_2, size: 18),
          ],
        ),
      ),
    );
  }
}

class _BrandSelector extends StatefulWidget {
  const _BrandSelector({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  State<_BrandSelector> createState() => _BrandSelectorState();
}

class _BrandSelectorState extends State<_BrandSelector> {
  final List<String> _brands = const <String>[
    'All',
    'Tesla',
    'BMW',
    'Audi',
    'Mercedes',
    'Toyota',
    'Hyundai',
    'Ferrari',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final brand = _brands[index];
          final isSelected = widget.selected == brand;
          return ChoiceChip(
            label: Text(brand),
            selected: isSelected,
            onSelected: (_) => widget.onSelected(brand),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _brands.length,
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
