import 'package:flutter/material.dart';

import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('reviews'),
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.star_rounded)),
                title: Text('${strings.t('reviews_feedback')} ${index + 1}'),
                subtitle: Text(strings.t('support_tickets')),
              ),
            ),
          );
        },
      ),
    );
  }
}
