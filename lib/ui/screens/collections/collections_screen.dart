import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../data/models/collection.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';
import '../../widgets/item_quick_actions.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  Future<void> _createCollection(BuildContext context) async {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final name = await _promptForName(
      context,
      title: localization.translate('new_collection'),
    );
    if (name != null && name.trim().isNotEmpty) {
      await appState.createCollection(name.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate('save'))),
      );
    }
  }

  Future<void> _renameCollection(BuildContext context, Collection collection) async {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final name = await _promptForName(
      context,
      title: localization.translate('rename'),
      initialValue: collection.name,
    );
    if (name != null && name.trim().isNotEmpty) {
      await appState.renameCollection(collection.id, name.trim());
    }
  }

  Future<void> _deleteCollection(BuildContext context, Collection collection) async {
    final localization = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.translate('delete_collection')),
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
    if (confirmed == true) {
      await AppScope.of(context).deleteCollection(collection.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final collections = appState.collections;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('collections')),
        actions: [
          IconButton(
            tooltip: localization.translate('new_collection'),
            onPressed: () => _createCollection(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createCollection(context),
        child: const Icon(Icons.add),
      ),
      body: collections.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.collections_bookmark_outlined,
                title: localization.translate('collections'),
                subtitle: localization.translate('add_to_collection'),
                action: OutlinedButton(
                  onPressed: () => _createCollection(context),
                  child: Text(localization.translate('create_collection')),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final collection = collections[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.1),
                    child: const Icon(IconlyBold.folder),
                  ),
                  title: Text(collection.name),
                  subtitle: Text('${collection.itemIds.length}'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CollectionDetailScreen(collectionId: collection.id),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'rename':
                          _renameCollection(context, collection);
                          break;
                        case 'delete':
                          _deleteCollection(context, collection);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Text(localization.translate('rename')),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(localization.translate('delete_collection')),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: collections.length,
            ),
    );
  }
}

Future<String?> _promptForName(
  BuildContext context, {
  required String title,
  String? initialValue,
}) {
  final controller = TextEditingController(text: initialValue ?? '');
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text.trim());
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ),
  );
}

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({super.key, required this.collectionId});

  final String collectionId;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final collection = appState.findCollection(collectionId);
    if (collection == null) {
      return Scaffold(
        appBar: AppBar(title: Text(localization.translate('collections'))),
        body: Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: localization.translate('empty_state'),
            subtitle: localization.translate('try_again'),
            action: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localization.translate('back_to_top')),
            ),
          ),
        ),
      );
    }

    final items = appState.getCollectionItems(collectionId);
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
        actions: [
          IconButton(
            tooltip: localization.translate('rename'),
            onPressed: () async {
              final updatedName = await _promptForName(
                context,
                title: localization.translate('rename'),
                initialValue: collection.name,
              );
              if (updatedName != null && updatedName.trim().isNotEmpty) {
                await appState.renameCollection(collection.id, updatedName.trim());
              }
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: localization.translate('delete_collection'),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localization.translate('delete_collection')),
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
              if (confirmed == true) {
                Navigator.of(context).pop();
                await appState.deleteCollection(collection.id);
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.inventory_2_outlined,
                title: localization.translate('empty_state'),
                subtitle: localization.translate('add_to_collection'),
                action: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.home),
                  child: Text(localization.translate('home')),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withOpacity(.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                  ),
                  onDismissed: (_) async {
                    await appState.removeItemFromCollection(collection.id, item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localization.translate('remove')),
                        action: SnackBarAction(
                          label: localization.translate('undo'),
                          onPressed: () => appState.addItemToCollection(collection.id, item.id),
                        ),
                      ),
                    );
                  },
                  child: ItemCard(
                    item: item,
                    onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                    onFavorite: () => appState.toggleFavorite(item),
                    onLongPress: () => showItemQuickActions(context, item),
                    onSecondaryTap: () => showItemQuickActions(context, item),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
    );
  }
}
