import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/app_scope.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/ui_kit/pill_button.dart';
import '../../shared/utils/app_localizations.dart';
import '../../shared/view_models/auction_view_model.dart';
import '../settings/settings_screen.dart';
import 'place_bid_sheet.dart';

class AuctionDetailsScreen extends StatelessWidget {
  const AuctionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = InheritedAppScope.of(context);
    final strings = MazadLocalizations.of(context);
    final args = ModalRoute.of(context)?.settings.arguments;
    final view = args is AuctionViewModel && args.listing.images.isNotEmpty
        ? args
        : (scope.catalogController.auctions.isNotEmpty ? scope.catalogController.auctions.first : null);

    if (view == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GlassPageScaffold(
      title: view.listing.title,
      imageUrl: view.listing.images.first,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    itemCount: view.listing.images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(view.listing.images[index], fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    GlassChip(label: view.listing.category),
                    GlassChip(label: view.listing.condition),
                    GlassChip(label: view.listing.location, icon: Icons.place_outlined),
                  ],
                ),
                const SizedBox(height: 12),
                Text(view.listing.description),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.t('place_bid'), style: Theme.of(context).textTheme.labelMedium),
                          Text('${view.currentBid.toStringAsFixed(0)} SAR', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    ),
                    PillButton(
                      label: strings.t('place_bid'),
                      onPressed: () => _showBidSheet(context, view.currentBid),
                      style: PillButtonStyle.gradient,
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('orders_timeline'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...view.bids.take(5).map(
                  (bid) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                    title: Text('***${bid.userId.substring(bid.userId.length - 3)}'),
                    subtitle: Text('${bid.amount.toStringAsFixed(0)} SAR'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('support'), style: Theme.of(context).textTheme.titleMedium),
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(view.sellerAvatar)),
                  title: Text(view.sellerName),
                  subtitle: Text('${strings.t('reviews_feedback')} ${view.sellerReputation.toStringAsFixed(1)}'),
                  trailing: PillButton(label: strings.t('chat'), onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBidSheet(BuildContext context, double currentBid) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => PlaceBidSheet(currentBid: currentBid),
    );
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bid submitted: $result')),
      );
    }
  }
}
