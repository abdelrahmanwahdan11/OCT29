import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/controllers/app_scope.dart';
import '../../shared/controllers/auth_controller.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/glass_badge.dart';
import '../../shared/ui_kit/pill_button.dart';
import '../../shared/utils/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.authController, required this.appController});

  final AuthController authController;
  final AppController appController;

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;
    final scope = InheritedAppScope.of(context);
    final strings = MazadLocalizations.of(context);
    final savedSearches = scope.catalogController.savedSearches;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (user != null)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(radius: 48, backgroundImage: NetworkImage(user.avatarUrl)),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                GlassChip(label: user.email, icon: Icons.alternate_email_rounded),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    GlassBadge(label: '${strings.t('reviews_feedback')} ${user.reputation.toStringAsFixed(1)}'),
                    GlassBadge(label: 'KYC ${user.kycLevel}'),
                    GlassBadge(label: user.isGuest ? 'Guest' : 'Member'),
                  ],
                ),
                const SizedBox(height: 16),
                PillButton(
                  label: strings.t('logout'),
                  onPressed: () => authController.logout(),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 320.ms).slide(begin: const Offset(0, 0.08)),
        const SizedBox(height: 24),
        Text(strings.t('badges_reputation'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.military_tech_outlined),
                title: Text(strings.t('badges_reputation')),
                subtitle: Text(strings.t('reviews_feedback')),
                trailing: TextButton(
                  onPressed: () {},
                  child: Text(strings.t('view_all')),
                ),
              ),
              const Divider(),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  Chip(label: Text('Top Seller')),
                  Chip(label: Text('Quick Responder')),
                  Chip(label: Text('Trusted Shipper')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: Text(strings.t('storefront')),
                subtitle: Text('SKU • 28  |  ${strings.t('favorites_watchlist')} 12'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.card_giftcard_outlined),
                title: Text(strings.t('coupons')),
                subtitle: const Text('2 active promos'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.t('saved_searches'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              if (savedSearches.isEmpty)
                Text(strings.t('tap_to_read'))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final search in savedSearches)
                      GlassChip(
                        label: search.query,
                        icon: Icons.search,
                        onTap: () {
                          scope.catalogController.searchController
                            ..setQuery(search.query)
                            ..setScope(search.scope);
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
