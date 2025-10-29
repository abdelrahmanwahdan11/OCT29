import 'package:flutter/material.dart';

import '../../shared/ui_kit/feature_sections.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('support'),
      imageUrl: 'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
      body: FeatureSectionsList(
        sections: [
          FeatureSection(title: strings.t('support_tickets'), items: const ['#2204 Awaiting response', '#2205 Dispute review']),
          FeatureSection(title: strings.t('settings_privacy'), items: const ['Returns & disputes', 'Escrow policy', 'Privacy commitments']),
        ],
      ),
    );
  }
}
