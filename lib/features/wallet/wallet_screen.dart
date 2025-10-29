import 'package:flutter/material.dart';

import '../../shared/ui_kit/feature_sections.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('wallet'),
      imageUrl: 'https://images.unsplash.com/photo-1611162616275-4dcba54c8d2a?q=80&w=1600',
      body: FeatureSectionsList(
        sections: [
          FeatureSection(title: strings.t('wallet_balance'), items: const ['Available 4,500 SAR', 'Escrow 1,200 SAR']),
          FeatureSection(title: strings.t('orders_timeline'), items: const ['Bid on Drone', 'Release escrow #1024', 'Refund request pending']),
        ],
      ),
    );
  }
}
