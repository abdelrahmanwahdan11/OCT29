import 'package:flutter/material.dart';

import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('favorites'),
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GlassCard(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('${strings.t('favorites_watchlist')} ${index + 1}'),
                  subtitle: Text(strings.t('wanted_highlights')),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
