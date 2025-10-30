import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final item = appState.findItemById(itemId);

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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(item.isFavorite ? IconlyBold.heart : IconlyLight.heart),
                onPressed: () => appState.toggleFavorite(item),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              background: Hero(
                tag: 'item-${item.id}',
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(Icons.broken_image, color: theme.colorScheme.outline),
                  ),
                ),
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
          )
        ],
      ),
    );
  }
}
