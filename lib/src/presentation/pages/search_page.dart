import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../components/car_card.dart';
import '../components/eink_scaffold.dart';
import '../components/skeleton_list_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('بحث')),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث عن المركبة'),
            onChanged: (value) {
              setState(() => _query = value);
              widget.controllers.searchController.search(value);
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<List<Car>>(
              valueListenable: widget.controllers.searchController.results,
              builder: (context, cars, _) {
                if (_query.isNotEmpty && cars.isEmpty) {
                  return const Center(child: Text('لا توجد نتائج'));
                }
                if (cars.isEmpty) {
                  return ListView(children: List.generate(4, (_) => const SkeletonListTile()));
                }
                return ListView.separated(
                  itemCount: cars.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => CarCard(car: cars[index], controllers: widget.controllers),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
