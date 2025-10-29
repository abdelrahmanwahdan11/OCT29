import 'package:flutter/material.dart';

import '../../shared/ui_kit/feature_sections.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('checkout'),
      imageUrl: 'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
      body: FeatureSectionsList(
        sections: [
          FeatureSection(title: strings.t('checkout_summary'), items: const ['Product total 2,400 SAR', 'Fees 120 SAR', 'Delivery 45 SAR']),
          FeatureSection(title: strings.t('support_tickets'), items: const ['Hold funds until delivered', 'Dispute window 48h']),
        ],
      ),
    );
  }
}
