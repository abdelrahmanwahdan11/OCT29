import 'package:flutter/material.dart';

import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('merchant_dashboard'),
      imageUrl: 'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return GridView.count(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            crossAxisCount: isWide ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: const [
              _DashboardCard(title: 'Sales', metric: '32,400 SAR'),
              _DashboardCard(title: 'Inventory', metric: '68 active'),
              _DashboardCard(title: 'Coupons', metric: '3 live promos'),
              _DashboardCard(title: 'Bulk upload', metric: 'Mock import available'),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.metric});

  final String title;
  final String metric;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(metric, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
