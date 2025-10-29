import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'glass_card.dart';
import 'glass_chip.dart';
import 'skeleton.dart';

class FeatureSection {
  FeatureSection({required this.title, required this.items});

  final String title;
  final List<String> items;
}

class FeatureSectionsList extends StatefulWidget {
  const FeatureSectionsList({super.key, required this.sections});

  final List<FeatureSection> sections;

  @override
  State<FeatureSectionsList> createState() => _FeatureSectionsListState();
}

class _FeatureSectionsListState extends State<FeatureSectionsList> {
  bool isRefreshing = false;

  Future<void> _refresh() async {
    setState(() => isRefreshing = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    setState(() => isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        itemCount: widget.sections.length + (isRefreshing ? 1 : 0),
        itemBuilder: (context, index) {
          if (isRefreshing && index == widget.sections.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Skeleton(width: 96, height: 96),
                  Skeleton(width: 96, height: 96),
                  Skeleton(width: 96, height: 96),
                ],
              ),
            );
          }
          final section = widget.sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: section.items
                        .map((item) => GlassChip(label: item))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
