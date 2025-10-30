import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final appState = AppScope.of(context);
    final favorites = appState.getFavoriteItems();
    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('favorites'))),
      body: favorites.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.favorite_border,
                title: localization.translate('empty_state'),
                subtitle: localization.translate('guest_message'),
                action: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.explore),
                  child: Text(localization.translate('explore')),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ItemCard(
                    item: item,
                    onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                    onFavorite: () => appState.toggleFavorite(item),
                  ),
                );
              },
            ),
    );
  }
}
