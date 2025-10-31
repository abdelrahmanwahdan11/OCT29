import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../components/car_card.dart';
import '../components/eink_scaffold.dart';
import '../components/pagination_loader.dart';
import '../components/skeleton_list_tile.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ScrollController _scrollController = ScrollController();
  List<Car> _displayed = <Car>[];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.controllers.catalogController.filteredCars.addListener(_update);
    _update();
  }

  void _update() {
    final cars = widget.controllers.catalogController.filteredCars.value;
    setState(() {
      _page = 1;
      _displayed = cars.take(12).toList();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final cars = widget.controllers.catalogController.filteredCars.value;
      final totalPages = (cars.length / 12).ceil();
      if (_page < totalPages) {
        setState(() {
          _page += 1;
          _displayed = cars.take(_page * 12).toList();
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.controllers.catalogController.filteredCars.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('الكتالوج')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'بحث'),
              onChanged: widget.controllers.catalogController.applyFilter,
            ),
          ),
          Expanded(
            child: _displayed.isEmpty
                ? ListView(children: List.generate(6, (_) => const SkeletonListTile()))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _displayed.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _displayed.length) {
                        final hasMore = _displayed.length < widget.controllers.catalogController.filteredCars.value.length;
                        return PaginationLoader(visible: hasMore);
                      }
                      final car = _displayed[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CarCard(car: car, controllers: widget.controllers),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
