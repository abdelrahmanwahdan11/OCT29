import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/app_scope.dart';
import '../../shared/controllers/catalog_controller.dart';
import '../../shared/controllers/deck_controller.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/pill_button.dart';
import '../../shared/ui_kit/swipe_deck.dart';
import '../../shared/utils/app_localizations.dart';
import '../../shared/view_models/wanted_view_model.dart';

class WantedFeedScreen extends StatelessWidget {
  const WantedFeedScreen({super.key, required this.controller});

  final CatalogController controller;

  @override
  Widget build(BuildContext context) {
    final scope = InheritedAppScope.of(context);
    final wanted = controller.wanted;
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: wanted.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return SwipeDeck(
              controller: scope.deckController,
              channel: DeckChannel.wanted,
              onDetails: (entry) {
                if (entry.wanted != null) {
                  Navigator.of(context).pushNamed('/wanted_details', arguments: entry.wanted);
                }
              },
            );
          }
          final view = wanted[index - 1];
          return _WantedCard(view: view).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2);
        },
      ),
    );
  }
}

class _WantedCard extends StatelessWidget {
  const _WantedCard({required this.view});

  final WantedViewModel view;

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(view.request.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(view.request.specs, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              GlassChip(label: '${view.request.budgetMin.toStringAsFixed(0)} - ${view.request.budgetMax.toStringAsFixed(0)} ر.س'),
              GlassChip(label: view.request.location, icon: Icons.place_outlined),
              GlassChip(label: '${view.request.radiusKm} كم'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PillButton(label: strings.t('offer_now'), onPressed: () {}),
              const SizedBox(width: 12),
              PillButton(label: strings.t('support'), onPressed: () {}, style: PillButtonStyle.pillIcon),
            ],
          ),
        ],
      ),
    );
  }
}
