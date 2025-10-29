import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/deck_controller.dart';
import '../utils/app_localizations.dart';
import 'glass_card.dart';
import 'glass_chip.dart';
import 'glass_badge.dart';

class SwipeDeck extends StatefulWidget {
  const SwipeDeck({
    super.key,
    required this.controller,
    required this.channel,
    this.onDetails,
  });

  final DeckController controller;
  final DeckChannel channel;
  final ValueChanged<DeckEntry>? onDetails;

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onDeckChanged);
  }

  @override
  void didUpdateWidget(covariant SwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onDeckChanged);
      widget.controller.addListener(_onDeckChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onDeckChanged);
    super.dispose();
  }

  void _onDeckChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.controller.current(widget.channel);
    final next = widget.controller.next(widget.channel);
    if (entry == null) {
      return const SizedBox(height: 320);
    }

    final angle = (_dragOffset.dx / 300) * 0.35;
    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (next != null)
            Positioned(
              top: 16,
              child: Opacity(
                opacity: 0.5,
                child: _DeckCard(entry: next).animate().scale(begin: const Offset(0.9, 0.9)),
              ),
            ),
          GestureDetector(
            onPanUpdate: (details) => setState(() => _dragOffset += details.delta),
            onPanEnd: (details) => _handlePanEnd(context, _dragOffset, details.velocity.pixelsPerSecond),
            child: Transform.translate(
              offset: _dragOffset,
              child: Transform.rotate(
                angle: angle,
                child: _DeckCard(entry: entry),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePanEnd(BuildContext context, Offset offset, Offset velocity) {
    final dx = offset.dx + velocity.dx * 0.05;
    final dy = offset.dy + velocity.dy * 0.05;
    DeckAction? action;
    if (dx > 120) {
      action = DeckAction.save;
    } else if (dx < -120) {
      action = DeckAction.skip;
    } else if (dy < -120) {
      action = DeckAction.details;
    } else if (dy > 120) {
      if (widget.controller.canRewind(widget.channel)) {
        action = DeckAction.rewind;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(MazadLocalizations.of(context).t('no_rewind'))),
        );
      }
    }

    setState(() => _dragOffset = Offset.zero);

    if (action == null) {
      return;
    }

    final entry = widget.controller.current(widget.channel);
    if (entry == null) return;
    if (action == DeckAction.details) {
      widget.onDetails?.call(entry);
    }
    widget.controller.act(widget.channel, action);
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({required this.entry});

  final DeckEntry entry;

  @override
  Widget build(BuildContext context) {
    if (entry.isAuction) {
      final view = entry.auction!;
      return SizedBox(
        width: math.min(MediaQuery.of(context).size.width - 48, 360),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(view.listing.images.first, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(view.listing.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(view.listing.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  GlassBadge(label: '${view.currentBid.toStringAsFixed(0)} SAR'),
                  GlassChip(label: view.listing.condition),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final wanted = entry.wanted!;
    return SizedBox(
      width: math.min(MediaQuery.of(context).size.width - 48, 340),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wanted.request.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(wanted.request.specs, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                GlassChip(label: '${wanted.request.budgetMin}-${wanted.request.budgetMax} SAR'),
                GlassChip(label: wanted.request.location, icon: Icons.place_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
