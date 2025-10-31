import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../components/eink_scaffold.dart';
import '../components/image_overlay.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.controllers, required this.carId});

  final AppControllerRegistry controllers;
  final String carId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Car? _car;

  @override
  void initState() {
    super.initState();
    widget.controllers.carDetailsController.findById(widget.carId).then((value) => setState(() => _car = value));
  }

  @override
  Widget build(BuildContext context) {
    final car = _car;
    return EInkScaffold(
      appBar: AppBar(
        title: Text(car?.fullName ?? '...'),
        actions: <Widget>[
          IconButton(icon: const Icon(IconlyLight.download), onPressed: () {}),
        ],
      ),
      body: car == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (_) => Dialog(backgroundColor: Colors.transparent, child: ImageOverlay(images: car.images)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(car.images[index], fit: BoxFit.cover),
                      ).animate().fade(duration: const Duration(milliseconds: 350)),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: car.images.length,
                  ),
                ),
                const SizedBox(height: 16),
                _SpecsGrid(car: car),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(IconlyLight.location),
                  title: Text(car.location),
                  subtitle: Text('البائع: ${car.sellerType}'),
                ),
                ListTile(
                  leading: const Icon(IconlyLight.chat),
                  title: const Text('AI Insight'),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('سيتم إضافة التحليلات لاحقاً.'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => widget.controllers.compareController.toggle(car.id),
                          icon: const Icon(IconlyBold.swap),
                          label: const Text('أضف للمقارنة'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(IconlyBold.call),
                          label: const Text('تواصل'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  const _SpecsGrid({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    final specs = <String, String>{
      'المحرك': '${car.engineCc} cc',
      'القوة': '${car.hp} hp',
      'الأبواب': '${car.doors}',
      'المقاعد': '${car.seats}',
    };
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      children: specs.entries
          .map(
            (entry) => Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
