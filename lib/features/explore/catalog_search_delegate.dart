import 'package:flutter/material.dart';

import '../../shared/controllers/catalog_controller.dart';
import '../../shared/utils/app_localizations.dart';
import '../../shared/utils/search_index.dart';

class CatalogSearchDelegate extends SearchDelegate<String?> {
  CatalogSearchDelegate({required this.controller, required this.strings});

  final CatalogController controller;
  final MazadLocalizations strings;
  SearchScope scope = SearchScope.all;

  @override
  String? get searchFieldLabel => strings.t('search_hint');

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          controller.searchController.clear();
          showSuggestions(context);
        },
      ),
      PopupMenuButton<SearchScope>(
        icon: const Icon(Icons.filter_list_rounded),
        onSelected: (value) {
          scope = value;
          showSuggestions(context);
        },
        itemBuilder: (context) {
          final strings = MazadLocalizations.of(context);
          return [
            PopupMenuItem(value: SearchScope.all, child: Text(strings.t('scope_all'))),
            PopupMenuItem(value: SearchScope.auctions, child: Text(strings.t('scope_auctions'))),
            PopupMenuItem(value: SearchScope.wanted, child: Text(strings.t('scope_wanted'))),
          ];
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.search(query, scope: scope);
    if (results.isEmpty) {
      return Center(child: Text(MazadLocalizations.of(context).t('end_of_list')));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final badge = result.type == SearchScope.auctions ? 'Auction' : 'Wanted';
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(result.title),
          subtitle: Text(result.subtitle),
          trailing: Text(badge),
          onTap: () => close(context, result.title),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchController.queryController.text = query;
    return buildResults(context);
  }
}
