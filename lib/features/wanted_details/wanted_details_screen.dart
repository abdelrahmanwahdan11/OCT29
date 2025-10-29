import 'package:flutter/material.dart';

import '../../shared/controllers/app_scope.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';
import '../../shared/view_models/wanted_view_model.dart';

class WantedDetailsScreen extends StatelessWidget {
  const WantedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = InheritedAppScope.of(context);
    final strings = MazadLocalizations.of(context);
    final args = ModalRoute.of(context)?.settings.arguments;
    final view = args is WantedViewModel ? args : (scope.catalogController.wanted.isNotEmpty ? scope.catalogController.wanted.first : null);
    if (view == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GlassPageScaffold(
      title: view.request.title,
      imageUrl: 'https://images.unsplash.com/photo-1515165562835-c3b8b1eea6cf?q=80&w=1600',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(view.request.specs),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    GlassChip(label: '${strings.t('wallet_balance')} ${view.request.budgetMin}-${view.request.budgetMax}'),
                    GlassChip(label: '${strings.t('filters')} ${view.request.radiusKm}km'),
                    GlassChip(label: view.request.location, icon: Icons.place_outlined),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('favorites'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...List.generate(3, (index) {
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.storefront)),
                    title: Text('${strings.t('support')} ${index + 1}'),
                    subtitle: Text(strings.t('wanted_highlights')),
                    trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.reply)),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
