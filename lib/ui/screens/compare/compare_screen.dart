import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../data/models/item.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_quick_actions.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final items = appState.getCompareItems();
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('compare')),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: localization.translate('share_summary'),
              icon: const Icon(Icons.copy_all_outlined),
              onPressed: () {
                final summary = appState.buildCompareSummary();
                Clipboard.setData(ClipboardData(text: summary));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.translate('copied'))),
                );
              },
            ),
          if (items.isNotEmpty)
            IconButton(
              tooltip: localization.translate('clear_all'),
              onPressed: () => appState.clearCompare(),
              icon: const Icon(Icons.clear_all),
            )
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.compare_arrows_outlined,
                title: localization.translate('compare'),
                subtitle: localization.translate('add_to_compare'),
                action: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.home),
                  child: Text(localization.translate('home')),
                ),
              ),
            )
          : _CompareTable(items: items),
    );
  }
}

class _CompareTable extends StatelessWidget {
  const _CompareTable({required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final specKeys = <String>{};
    for (final item in items) {
      specKeys.addAll(item.specs.keys);
    }
    final sortedSpecs = specKeys.toList()..sort();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _CompareHeaderDelegate(items: items),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSpecTable(context, sortedSpecs),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildSpecTable(BuildContext context, List<String> specs) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rows = <TableRow>[
      _buildRow(
        context,
        localization.translate('price'),
        items.map((item) => '\$${item.price.toStringAsFixed(2)}').toList(),
      ),
      _buildRow(
        context,
        localization.translate('rating'),
        items.map((item) => item.rating.toString()).toList(),
      ),
      _buildRow(
        context,
        localization.translate('brand'),
        items.map((item) => item.brand).toList(),
      ),
      _buildRow(
        context,
        localization.translate('categories'),
        items.map((item) => item.category).toList(),
      ),
    ];
    for (final spec in specs) {
      rows.add(_buildRow(context, spec, items.map((item) => item.specs[spec] ?? '—').toList()));
    }
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth()},
      border: TableBorder.symmetric(
        inside: BorderSide(color: theme.dividerColor.withOpacity(.3)),
        outside: BorderSide(color: theme.dividerColor.withOpacity(.2)),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  TableRow _buildRow(BuildContext context, String label, List<String> values) {
    final theme = Theme.of(context);
    return TableRow(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withOpacity(.4)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        ...values.map(
          (value) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }
}

class _CompareHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CompareHeaderDelegate({required this.items});

  final List<Item> items;

  @override
  double get minExtent => 240;

  @override
  double get maxExtent => 260;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Expanded(
                child: _CompareHeaderCard(item: item),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CompareHeaderDelegate oldDelegate) {
    if (oldDelegate.items.length != items.length) return true;
    for (var i = 0; i < items.length; i++) {
      if (oldDelegate.items[i].id != items[i].id) return true;
    }
    return false;
  }
}

class _CompareHeaderCard extends StatelessWidget {
  const _CompareHeaderCard({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: theme.colorScheme.surfaceVariant.withOpacity(.6),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
          onLongPress: () => showItemQuickActions(context, item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: theme.colorScheme.surface,
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image, color: theme.colorScheme.outline),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          onPressed: () async {
                            await appState.removeFromCompare(item.id);
                            messenger.showSnackBar(
                              SnackBar(content: Text(localization.translate('remove_from_compare'))),
                            );
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            minimumSize: const Size(36, 36),
                          ),
                          icon: const Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(item.rating.toString(), style: theme.textTheme.bodySmall),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
