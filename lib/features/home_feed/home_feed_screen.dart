import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/auth_controller.dart';
import '../../shared/controllers/catalog_controller.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/glass_badge.dart';
import '../../shared/ui_kit/skeleton.dart';
import '../../shared/ui_kit/pill_button.dart';
import '../../shared/view_models/auction_view_model.dart';
import '../../shared/view_models/wanted_view_model.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key, required this.controller, required this.authController});

  final CatalogController controller;
  final AuthController authController;

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.paginationController.attachListener(_loadNextPage);
  }

  void _loadNextPage() {
    if (!widget.controller.paginationController.hasMore) return;
    widget.controller.paginationController.markLoaded(widget.controller.auctions.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final auctions = controller.auctions;
    final wanted = controller.wanted;
    final sections = [
      ('ينتهي قريباً', auctions),
      ('مقترح لك', auctions.take(1).toList()),
      ('وصل حديثاً', auctions),
      ('الأكثر مشاهدة', auctions.reversed.toList()),
      ('طلبات مميزة', wanted),
    ];

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        controller: controller.paginationController.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: sections.length + (controller.paginationController.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= sections.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (i) => const Skeleton(width: 90, height: 90)),
              ),
            );
          }
          final section = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.$1,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: section.$2.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, itemIndex) {
                    final data = section.$2[itemIndex];
                    if (data is AuctionViewModel) {
                      return _AuctionCard(
                        view: data,
                        isGuest: widget.authController.isGuest,
                      );
                    } else if (data is WantedViewModel) {
                      return _WantedCard(view: data);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({required this.view, required this.isGuest});

  final AuctionViewModel view;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(view.listing.images.first, height: 140, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(view.listing.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(view.listing.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            const Spacer(),
            Row(
              children: [
                GlassBadge(label: 'السعر الحالي ${view.currentBid.toStringAsFixed(0)} ر.س'),
                const Spacer(),
                PillButton(
                  label: isGuest ? 'سجّل لتزايد' : 'زايد الآن',
                  onPressed: () {},
                  style: PillButtonStyle.gradient,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WantedCard extends StatelessWidget {
  const _WantedCard({required this.view});

  final WantedViewModel view;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(view.request.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GlassChip(label: view.request.location, icon: Icons.place_outlined),
            const SizedBox(height: 8),
            Text('الميزانية: ${view.request.budgetMin.toStringAsFixed(0)} - ${view.request.budgetMax.toStringAsFixed(0)} ر.س', style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            PillButton(label: 'قدّم عرضاً', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
