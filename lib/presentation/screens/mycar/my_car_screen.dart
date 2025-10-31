import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/my_car_controller.dart';
import '../../../domain/entities/offer_watch.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key, required this.controller, required this.carsController});

  final MyCarController controller;
  final CarsController carsController;

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Car'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Car'),
            Tab(text: 'Offers Watch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForm(context),
          _buildOfferWatch(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.controller.formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Brand', prefixIcon: Icon(IconlyBold.ticket)),
              onSaved: (value) => widget.controller.brand = value ?? '',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Model', prefixIcon: Icon(IconlyBold.edit)),
              onSaved: (value) => widget.controller.model = value ?? '',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Year', prefixIcon: Icon(IconlyBold.time_circle)),
              keyboardType: TextInputType.number,
              onSaved: (value) => widget.controller.year = int.tryParse(value ?? '') ?? widget.controller.year,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Accepting offers'),
              value: widget.controller.acceptingOffers,
              onChanged: (value) => setState(() => widget.controller.acceptingOffers = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.controller.saveForm();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Car saved locally.')),
                );
              },
              child: const Text('List for Sale'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                widget.controller.saveForm();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Draft saved.')),
                );
              },
              child: const Text('Save Only'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferWatch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add a target price to get notified when a buyer is willing to pay it.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddOfferWatch(context),
            child: const Text('Add Offer Watch'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.controller.offerWatches.length,
              itemBuilder: (context, index) {
                final watch = widget.controller.offerWatches[index];
                return Card(
                  child: ListTile(
                    title: Text('Car: ${watch.carId}'),
                    subtitle: Text('Target: ${watch.targetPrice.toStringAsFixed(0)}'),
                    trailing: Switch(
                      value: watch.notifyOnMatch,
                      onChanged: (_) {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOfferWatch(BuildContext context) {
    final carId = widget.carsController.visibleCars.isNotEmpty ? widget.carsController.visibleCars.first.id : 'car';
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Offer Watch'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Target price'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final price = double.tryParse(controller.text);
              if (price != null) {
                widget.controller.addOfferWatch(
                  OfferWatch(carId: carId, targetPrice: price, notifyOnMatch: true),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
