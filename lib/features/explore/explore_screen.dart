import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/catalog_controller.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/view_models/auction_view_model.dart';
import '../../shared/view_models/wanted_view_model.dart';
import '../../shared/utils/search_index.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.controller});

  final CatalogController controller;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ValueNotifier<SearchScope> scope = ValueNotifier(SearchScope.all);
  List<SearchResult> results = [];

  @override
  void initState() {
    super.initState();
    widget.controller.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.controller.searchController.removeListener(_onSearchChanged);
    scope.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.controller.searchController.query;
    results = widget.controller.search(query, scope: scope.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller.searchController.queryController,
            decoration: InputDecoration(
              hintText: 'ابحث عن مزاد أو طلب',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: ValueListenableBuilder(
                valueListenable: scope,
                builder: (context, value, child) {
                  return PopupMenuButton<SearchScope>(
                    icon: const Icon(Icons.filter_list_rounded),
                    onSelected: (value) {
                      scope.value = value;
                      _onSearchChanged();
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: SearchScope.all, child: Text('الكل')),
                      PopupMenuItem(value: SearchScope.auctions, child: Text('مزادات')),
                      PopupMenuItem(value: SearchScope.wanted, child: Text('طلبات')),
                    ],
                  );
                },
              ),
            ),
            onSubmitted: (_) => _onSearchChanged(),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: 300.ms,
            child: results.isEmpty
                ? _ExploreGrid(controller: controller)
                : ListView.builder(
                    key: const ValueKey('results'),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ListTile(
                        title: Text(result.title),
                        subtitle: Text(result.subtitle),
                        trailing: Text(result.type == SearchScope.auctions ? 'مزاد' : 'طلب'),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  const _ExploreGrid({required this.controller});

  final CatalogController controller;

  @override
  Widget build(BuildContext context) {
    final auctions = controller.auctions;
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.76,
      ),
      itemCount: auctions.length,
      itemBuilder: (context, index) {
        final auction = auctions[index];
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(auction.listing.images.first, height: 140, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(auction.listing.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  GlassChip(label: auction.listing.category),
                  GlassChip(label: auction.listing.condition),
                  GlassChip(label: auction.listing.location, icon: Icons.place_outlined),
                ],
              ),
              const Spacer(),
              Text('السعر الحالي ${auction.currentBid.toStringAsFixed(0)} ر.س'),
            ],
          ),
        ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95));
      },
    );
  }
}
