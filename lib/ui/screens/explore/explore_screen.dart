import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../data/models/item.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 0;
  final int _pageSize = 20;
  String _selectedCategory = 'all';
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitial());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    final appState = AppScope.of(context);
    setState(() {
      _isLoading = true;
      _page = 0;
      _hasMore = true;
    });
    final data = await appState.repository.fetchItems(
      page: _page,
      pageSize: _pageSize,
      category: _selectedCategory,
      query: '',
    );
    setState(() {
      _items = data
          .map((item) => item.copyWith(isFavorite: appState.favorites.contains(item.id)))
          .toList();
      _isLoading = false;
      _hasMore = data.length == _pageSize;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final appState = AppScope.of(context);
    setState(() => _isLoadingMore = true);
    _page += 1;
    final data = await appState.repository.fetchItems(
      page: _page,
      pageSize: _pageSize,
      category: _selectedCategory,
      query: '',
    );
    setState(() {
      _items.addAll(
        data.map((item) => item.copyWith(isFavorite: appState.favorites.contains(item.id))),
      );
      if (data.isEmpty) {
        _hasMore = false;
      }
      _isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent * .8) {
      _loadMore();
    }
  }

  Future<void> _onRefresh() => _loadInitial();

  void _selectCategory(String id) {
    setState(() => _selectedCategory = id);
    _loadInitial();
  }

  void _toggleFavorite(Item item) {
    final appState = AppScope.of(context);
    appState.toggleFavorite(item);
    setState(() {
      _items = _items
          .map((e) => e.id == item.id ? e.copyWith(isFavorite: !e.isFavorite) : e)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final appState = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('explore')),
        actions: [
          IconButton(
            tooltip: appState.feedLayout == FeedLayout.grid
                ? localization.translate('list')
                : localization.translate('grid'),
            onPressed: () => appState
                .setFeedLayout(appState.feedLayout == FeedLayout.grid ? FeedLayout.list : FeedLayout.grid),
            icon: Icon(appState.feedLayout == FeedLayout.grid ? Icons.view_agenda_rounded : Icons.grid_view_rounded),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          controller: _controller,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: appState.categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ChoiceChip(
                      label: const Text('All'),
                      selected: _selectedCategory == 'all',
                      onSelected: (_) => _selectCategory('all'),
                    );
                  }
                  final category = appState.categories[index - 1];
                  return ChoiceChip(
                    label: Text(category.name),
                    selected: _selectedCategory == category.id,
                    onSelected: (_) => _selectCategory(category.id),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                localization.translate('categories'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                child: EmptyState(
                  icon: Icons.search_off,
                  title: localization.translate('empty_state'),
                  subtitle: localization.translate('try_again'),
                  action: OutlinedButton(
                    onPressed: _loadInitial,
                    child: Text(localization.translate('try_again')),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: appState.feedLayout == FeedLayout.grid
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .72,
                        ),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final isFavorite = appState.favorites.contains(item.id);
                          final displayItem = item.copyWith(isFavorite: isFavorite);
                          return ItemCard(
                            item: displayItem,
                            onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                            onFavorite: () => _toggleFavorite(item),
                          );
                        },
                      )
                    : Column(
                        children: _items
                            .map((item) {
                              final isFavorite = appState.favorites.contains(item.id);
                              final displayItem = item.copyWith(isFavorite: isFavorite);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: ItemCard(
                                  item: displayItem,
                                  onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                                  onFavorite: () => _toggleFavorite(item),
                                ),
                              );
                            })
                            .toList(),
                      ),
              ),
            if (_isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
