import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/my_car_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/car.dart';
import '../../../domain/entities/offer_watch.dart';
import '../../../domain/enums/condition.dart';
import '../../../domain/enums/fuel_type.dart';
import '../../../domain/enums/transmission.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key, required this.controller, required this.carsController});

  final MyCarController controller;
  final CarsController carsController;

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _tipDismissed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.t('my_car')),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.t('my_car')),
                Tab(text: l10n.t('offers_watch')),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildForm(context, l10n),
              _buildOfferWatch(context, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, AppLocalizations l10n) {
    final controller = widget.controller;
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (!_tipDismissed)
            _MaintenanceTipCard(
              controller: controller,
              l10n: l10n,
              onDismissed: () => setState(() => _tipDismissed = true),
            ),
          _SectionHeader(title: l10n.t('basics')),
          _buildTextField(
            label: l10n.t('brand'),
            icon: IconlyBold.ticket,
            initialValue: controller.brand,
            onSaved: (value) => controller.brand = value ?? '',
            validator: (value) => (value == null || value.isEmpty) ? l10n.t('required_field') : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: l10n.t('model'),
            icon: IconlyBold.edit,
            initialValue: controller.model,
            onSaved: (value) => controller.model = value ?? '',
            validator: (value) => (value == null || value.isEmpty) ? l10n.t('required_field') : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: l10n.t('year'),
                  icon: IconlyBold.time_circle,
                  initialValue: controller.year.toString(),
                  onSaved: (value) => controller.year = int.tryParse(value ?? '') ?? controller.year,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  label: l10n.t('price'),
                  icon: IconlyBold.wallet,
                  initialValue: controller.price.toStringAsFixed(0),
                  onSaved: (value) => controller.price = double.tryParse(value ?? '') ?? controller.price,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: l10n.t('mileage'),
                  icon: IconlyBold.location,
                  initialValue: controller.mileage.toString(),
                  onSaved: (value) => controller.mileage = int.tryParse(value ?? '') ?? controller.mileage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  label: l10n.t('horsepower'),
                  icon: IconlyBold.work,
                  initialValue: controller.horsepower.toString(),
                  onSaved: (value) => controller.horsepower = int.tryParse(value ?? '') ?? controller.horsepower,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Condition>(
            decoration: InputDecoration(labelText: l10n.t('condition')),
            value: controller.condition,
            items: Condition.values
                .map((condition) => DropdownMenuItem(
                      value: condition,
                      child: Text(_conditionLabel(condition, Localizations.localeOf(context))),
                    ))
                .toList(),
            onChanged: (value) => setState(() => controller.condition = value ?? controller.condition),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<FuelType>(
            decoration: InputDecoration(labelText: l10n.t('fuel')),
            value: controller.fuel,
            items: FuelType.values
                .map((fuel) => DropdownMenuItem(
                      value: fuel,
                      child: Text(_fuelLabel(fuel, Localizations.localeOf(context))),
                    ))
                .toList(),
            onChanged: (value) => setState(() => controller.fuel = value ?? controller.fuel),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Transmission>(
            decoration: InputDecoration(labelText: l10n.t('transmission')),
            value: controller.transmission,
            items: Transmission.values
                .map((transmission) => DropdownMenuItem(
                      value: transmission,
                      child: Text(_transmissionLabel(transmission, Localizations.localeOf(context))),
                    ))
                .toList(),
            onChanged: (value) => setState(() => controller.transmission = value ?? controller.transmission),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: l10n.t('seats')),
            value: controller.seats,
            items: <int>[2, 4, 5, 7]
                .map((seat) => DropdownMenuItem(value: seat, child: Text('$seat ${l10n.t('seat')}')))
                .toList(),
            onChanged: (value) => setState(() => controller.seats = value ?? controller.seats),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: l10n.t('city'),
            icon: IconlyBold.location,
            initialValue: controller.city,
            onSaved: (value) => controller.city = value ?? '',
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: controller.description,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(labelText: l10n.t('description')),
            onSaved: (value) => controller.description = value ?? '',
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(l10n.t('accepting_offers')),
            value: controller.acceptingOffers,
            onChanged: (value) => setState(() => controller.acceptingOffers = value),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.t('images_urls')),
          TextFormField(
            initialValue: controller.imagesMultiline,
            maxLines: 4,
            decoration: InputDecoration(hintText: l10n.t('one_url_per_line')),
            onChanged: controller.updateImages,
          ),
          const SizedBox(height: 12),
          _ImagePreview(urls: controller.images),
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.t('spinset_urls')),
          TextFormField(
            initialValue: controller.spinsetMultiline,
            maxLines: 4,
            decoration: InputDecoration(hintText: l10n.t('one_url_per_line')),
            onChanged: controller.updateSpinset,
          ),
          const SizedBox(height: 8),
          Text('${l10n.t('frames')}: ${controller.spinset360.length}'),
          const SizedBox(height: 12),
          _ImagePreview(urls: controller.spinset360),
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.t('maintenance')),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: l10n.t('current_mileage'),
                  icon: IconlyBold.location,
                  initialValue: controller.currentMileage.toString(),
                  onChanged: controller.updateCurrentMileage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  label: l10n.t('last_oil_change'),
                  icon: IconlyBold.setting,
                  initialValue: controller.lastOilChangeKm.toString(),
                  onChanged: controller.updateLastOilChange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () async {
              final car = controller.buildCarFromForm();
              await controller.insertIntoCatalog(car);
              await widget.carsController.addCar(car);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.t('listed_for_sale'))));
            },
            child: Text(l10n.t('list_for_sale')),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () async {
              await controller.saveOnly();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.t('saved_draft'))));
            },
            child: Text(l10n.t('save_only')),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferWatch(BuildContext context, AppLocalizations l10n) {
    final controller = widget.controller;
    final watches = controller.offerWatches;
    final cars = widget.carsController.visibleCars.isEmpty
        ? widget.carsController.listController.value
        : widget.carsController.visibleCars;
    return RefreshIndicator(
      onRefresh: controller.refreshOfferWatches,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.t('offer_watch_hint'), style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showAddOfferWatch(context, l10n, cars),
            icon: const Icon(Icons.add_alert),
            label: Text(l10n.t('add_offer_watch')),
          ),
          const SizedBox(height: 24),
          if (watches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text(l10n.t('no_offer_watches'))),
            )
          else
            ...List.generate(watches.length, (index) {
              final watch = watches[index];
              final car = widget.carsController.findById(watch.carId);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(car?.title ?? watch.carId),
                  subtitle: Text('${l10n.t('target_price_label')}: ${watch.targetPrice.toStringAsFixed(0)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: watch.notifyOnMatch,
                        onChanged: (value) => controller.toggleOfferWatchNotify(index, value),
                      ),
                      IconButton(
                        tooltip: l10n.t('remove'),
                        onPressed: () => controller.removeOfferWatch(index),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showAddOfferWatch(BuildContext context, AppLocalizations l10n, List<Car> cars) {
    final controller = widget.controller;
    final idController = TextEditingController(
      text: cars.isNotEmpty ? cars.first.id : '',
    );
    final priceController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.t('add_offer_watch')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: idController.text.isEmpty && cars.isNotEmpty ? cars.first.id : idController.text,
              items: cars
                  .map((car) => DropdownMenuItem(value: car.id, child: Text(car.title)))
                  .toList(),
              onChanged: (value) => idController.text = value ?? idController.text,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.t('target_price_label')),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.t('cancel'))),
          TextButton(
            onPressed: () {
              final price = double.tryParse(priceController.text.trim());
              if (price != null && idController.text.isNotEmpty) {
                controller.addOfferWatch(
                  OfferWatch(carId: idController.text, targetPrice: price, notifyOnMatch: true),
                );
                Navigator.pop(context);
              }
            },
            child: Text(l10n.t('add')),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextField({
    required String label,
    required IconData icon,
    String? initialValue,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      onSaved: onSaved,
      validator: validator,
    );
  }

  TextFormField _buildNumberField({
    required String label,
    required IconData icon,
    String? initialValue,
    FormFieldSetter<String>? onSaved,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: TextInputType.number,
      onSaved: onSaved,
      onChanged: onChanged,
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
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final url = urls[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(url, width: 120, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

class _MaintenanceTipCard extends StatelessWidget {
  const _MaintenanceTipCard({required this.controller, required this.l10n, required this.onDismissed});

  final MyCarController controller;
  final AppLocalizations l10n;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final bool oilTip = controller.needsOilChange;
    final String message = oilTip ? l10n.t('maintenance_tip_oil') : l10n.t('maintenance_tip_tires');
    return Dismissible(
      key: const ValueKey('tip'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Icon(oilTip ? Icons.local_gas_station : Icons.tire_repair, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
            IconButton(onPressed: onDismissed, icon: const Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}
