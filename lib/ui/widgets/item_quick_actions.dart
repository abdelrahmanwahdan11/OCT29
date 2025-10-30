import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../app.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/routes.dart';
import '../../data/models/item.dart';
import '../../state/app_state.dart';

Future<void> showItemQuickActions(BuildContext context, Item item) async {
  final localization = AppLocalizations.of(context);
  final appState = AppScope.of(context);
  final isFavorite = appState.favorites.contains(item.id);
  final inCompare = appState.isInCompare(item.id);
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(isFavorite ? IconlyBold.heart : IconlyLight.heart),
              title: Text(isFavorite ? localization.translate('remove') : localization.translate('save')),
              onTap: () {
                Navigator.of(sheetContext).pop();
                appState.toggleFavorite(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections_bookmark_outlined),
              title: Text(localization.translate('add_to_collection')),
              onTap: () {
                Navigator.of(sheetContext).pop();
                showCollectionPicker(context, item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.compare_arrows_outlined),
              title: Text(
                inCompare
                    ? localization.translate('remove_from_compare')
                    : localization.translate('add_to_compare'),
              ),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                if (appState.isInCompare(item.id)) {
                  await appState.removeFromCompare(item.id);
                  messenger.showSnackBar(
                    SnackBar(content: Text(localization.translate('remove_from_compare'))),
                  );
                } else {
                  final added = await appState.addToCompare(item.id);
                  if (added) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(localization.translate('add_to_compare')),
                        action: SnackBarAction(
                          label: localization.translate('view_more'),
                          onPressed: () => navigator.pushNamed(AppRoutes.compare),
                        ),
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text(localization.translate('compare_limit'))),
                    );
                  }
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showCollectionPicker(BuildContext context, Item item) async {
  final localization = AppLocalizations.of(context);
  final appState = AppScope.of(context);
  final navigator = Navigator.of(context);
  final controller = TextEditingController();
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final collections = appState.collections;
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localization.translate('add_to_collection'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (collections.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          localization.translate('create_collection'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ...collections.map(
                      (collection) {
                        final contains = collection.contains(item.id);
                        return CheckboxListTile(
                          value: contains,
                          title: Text(collection.name),
                          onChanged: (value) async {
                            if (value == true) {
                              await appState.addItemToCollection(collection.id, item.id);
                            } else {
                              await appState.removeItemFromCollection(collection.id, item.id);
                            }
                            setModalState(() {});
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: localization.translate('new_collection'),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            final name = controller.text.trim();
                            if (name.isEmpty) return;
                            await appState.createCollection(name);
                            controller.clear();
                            setModalState(() {});
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) async {
                        final name = value.trim();
                        if (name.isEmpty) return;
                        await appState.createCollection(name);
                        controller.clear();
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          navigator.pushNamed(AppRoutes.collections);
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: Text(localization.translate('collections')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  controller.dispose();
}
