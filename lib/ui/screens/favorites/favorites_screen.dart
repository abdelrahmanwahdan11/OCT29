import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../data/models/item.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Set<String> _selected = <String>{};

  bool get _selectionMode => _selected.isNotEmpty;

  void _toggleSelection(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _enterSelection(String id) {
    if (_selectionMode && _selected.contains(id)) return;
    setState(() {
      _selected.add(id);
    });
  }

  void _clearSelection() {
    setState(() => _selected.clear());
  }

  void _selectAll(List<Item> favorites) {
    setState(() {
      if (_selected.length == favorites.length) {
        _selected.clear();
      } else {
        _selected
          ..clear()
          ..addAll(favorites.map((item) => item.id));
      }
    });
  }

  Future<void> _confirmBulkRemove(AppState appState, AppLocalizations localization) async {
    if (_selected.isEmpty) return;
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.translate('bulk_remove')),
        content: Text(localization.translate('remove')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localization.translate('remove')),
          ),
        ],
      ),
    );
    if (shouldRemove == true) {
      await appState.removeFavorites(_selected);
      _clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final appState = AppScope.of(context);
    final favorites = appState.getFavoriteItems();
    final selectionMode = _selectionMode;
    return Scaffold(
      appBar: AppBar(
        leading: selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        title: selectionMode
            ? Text(
                '${localization.translate('select_items')} (${_selected.length})',
              )
            : Text(localization.translate('favorites')),
        actions: [
          if (selectionMode)
            IconButton(
              tooltip: _selected.length == favorites.length
                  ? localization.translate('deselect_all')
                  : localization.translate('select_all'),
              onPressed: () => _selectAll(favorites),
              icon: Icon(_selected.length == favorites.length ? Icons.check_box_outline_blank : Icons.select_all),
            ),
          if (selectionMode)
            IconButton(
              tooltip: localization.translate('bulk_remove'),
              onPressed: () => _confirmBulkRemove(appState, localization),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.favorite_border,
                title: localization.translate('empty_state'),
                subtitle: localization.translate('guest_message'),
                action: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.explore),
                  child: Text(localization.translate('explore')),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                final selected = _selected.contains(item.id);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Stack(
                    children: [
                      ItemCard(
                        item: item,
                        onTap: () {
                          if (selectionMode) {
                            _toggleSelection(item.id);
                          } else {
                            Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}');
                          }
                        },
                        onFavorite: () => appState.toggleFavorite(item),
                        onLongPress: () => _enterSelection(item.id),
                      ),
                      if (selectionMode)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              selected ? Icons.check : Icons.radio_button_unchecked,
                              size: 18,
                              color: selected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
