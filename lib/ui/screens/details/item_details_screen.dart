import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.itemId});

  final String itemId;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = AppScope.of(context);
      final item = appState.findItemById(widget.itemId);
      if (item != null) {
        appState.recordRecentlyViewed(item.id);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final item = appState.findItemById(widget.itemId);

    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.error_outline,
          title: localization.translate('network_error'),
          subtitle: localization.translate('try_again'),
          action: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localization.translate('remove')),
          ),
        ),
      );
    }

    final images = item.imageUrls.isNotEmpty ? item.imageUrls : [item.imageUrl];
    final relatedItems = appState.getRelatedItems(item.id);
    final recentlyViewed = appState
        .getRecentlyViewedItems()
        .where((recent) => recent.id != item.id)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(item.isFavorite ? IconlyBold.heart : IconlyLight.heart),
                onPressed: () => appState.toggleFavorite(item),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(Icons.broken_image, color: theme.colorScheme.outline),
                        ),
                      );
                      if (index == 0) {
                        return Hero(
                          tag: 'item-${item.id}',
                          child: image,
                        );
                      }
                      return image;
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceVariant.withOpacity(.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(item.rating.toString()),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: theme.colorScheme.primaryContainer,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(localization.translate('details'), style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(IconlyBold.bag),
                    label: Text(localization.translate('add_to_cart')),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => appState.toggleFavorite(item),
                    child: Text(item.isFavorite
                        ? localization.translate('remove')
                        : localization.translate('save')),
                  ),
                ],
              ),
            ),
          ),
          if (recentlyViewed.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localization.translate('recently_viewed'), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final recent = recentlyViewed[index];
                          return SizedBox(
                            width: 200,
                            child: ItemCard(
                              item: recent,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('${AppRoutes.itemDetails}/${recent.id}'),
                              onFavorite: () => appState.toggleFavorite(recent),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: recentlyViewed.length,
                      ),
                    )
                  ],
                ),
              ),
            ),
          if (relatedItems.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localization.translate('related_items'), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...relatedItems.map(
                      (related) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ItemCard(
                          item: related,
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed('${AppRoutes.itemDetails}/${related.id}'),
                          onFavorite: () => appState.toggleFavorite(related),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
