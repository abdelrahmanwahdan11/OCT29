import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';
import '../../widgets/item_quick_actions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  late final FocusNode _rootFocusNode;
  late final FocusNode _searchFocusNode;
  Timer? _debounce;
  AppState? _appState;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _rootFocusNode = FocusNode(debugLabel: 'home-shortcuts');
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppScope.of(context);
    final query = _appState?.searchQuery ?? '';
    if (_searchController.text != query) {
      _searchController.text = query;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _rootFocusNode.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final appState = _appState;
    if (appState == null) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * .8) {
      appState.loadMoreItems();
    }
    final shouldShow = _scrollController.position.pixels > 1200;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }
  }

  void _onSearchChanged(String value) {
    final appState = _appState;
    if (appState == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      appState.setSearchQuery(value.trim());
    });
  }

  void _onSearchHistoryTap(String term) {
    _searchController.value = TextEditingValue(text: term, selection: TextSelection.collapsed(offset: term.length));
    _onSearchChanged(term);
  }

  void _toggleLayout(AppState appState) {
    final newLayout = appState.feedLayout == FeedLayout.grid ? FeedLayout.list : FeedLayout.grid;
    appState.setFeedLayout(newLayout);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _focusSearchField() {
    if (!_searchFocusNode.hasFocus) {
      _searchFocusNode.requestFocus();
    }
  }

  void _openFilters(AppState appState) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    var tempCategory = appState.selectedCategory;
    var tempFilter = appState.selectedFilter;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .7,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localization.translate('categories'), style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        RadioListTile<String>(
                          value: 'all',
                          groupValue: tempCategory,
                          onChanged: (value) => setModalState(() => tempCategory = value ?? 'all'),
                          title: const Text('All'),
                        ),
                        ...appState.categories.map(
                          (category) => RadioListTile<String>(
                            value: category.id,
                            groupValue: tempCategory,
                            onChanged: (value) => setModalState(() => tempCategory = value ?? tempCategory),
                            title: Text(category.name),
                          ),
                        ),
                        const Divider(),
                        Text(localization.translate('filter'), style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        ...appState.filters.map(
                          (filter) => RadioListTile<String>(
                            value: filter.id,
                            groupValue: tempFilter,
                            onChanged: (value) => setModalState(() => tempFilter = value ?? tempFilter),
                            title: Text(filter.label),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(sheetContext).pop();
                                appState.clearFilters();
                              },
                              child: Text(localization.translate('clear_filters')),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.of(sheetContext).pop();
                                if (tempCategory != appState.selectedCategory) {
                                  appState.selectCategory(tempCategory);
                                }
                                if (tempFilter != appState.selectedFilter) {
                                  appState.selectFilter(tempFilter);
                                }
                              },
                              child: Text(localization.translate('apply')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    _appState = appState;
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final recentItems = appState.getRecentlyViewedItems();
    final shortcuts = <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.slash): _focusSearchField,
      const SingleActivator(LogicalKeyboardKey.keyG): () => _toggleLayout(appState),
      const SingleActivator(LogicalKeyboardKey.keyF): () => _openFilters(appState),
      const SingleActivator(LogicalKeyboardKey.keyT): _scrollToTop,
      const SingleActivator(LogicalKeyboardKey.escape): () => FocusScope.of(context).unfocus(),
    };
    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        focusNode: _rootFocusNode,
        autofocus: true,
        child: Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => appState.refreshItems(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                title: Text(localization.translate('app_name')),
                actions: [
                  PopupMenuButton<String>(
                    tooltip: localization.translate('sort'),
                    onSelected: (value) => appState.setSortOrder(value),
                    initialValue: appState.sortOrder,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'newest_first',
                        child: Text(localization.translate('newest_first')),
                      ),
                      PopupMenuItem(
                        value: 'price_low_high',
                        child: Text(localization.translate('price_low_high')),
                      ),
                      PopupMenuItem(
                        value: 'price_high_low',
                        child: Text(localization.translate('price_high_low')),
                      ),
                      PopupMenuItem(
                        value: 'rating_high_low',
                        child: Text(localization.translate('rating_high_low')),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.sort_rounded, color: theme.colorScheme.onSurface),
                    ),
                  ),
                  IconButton(
                    tooltip: localization.translate('filter'),
                    onPressed: () => _openFilters(appState),
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                  IconButton(
                    tooltip: appState.feedLayout == FeedLayout.grid
                        ? localization.translate('list')
                        : localization.translate('grid'),
                    onPressed: () => _toggleLayout(appState),
                    icon: Icon(appState.feedLayout == FeedLayout.grid ? Icons.view_agenda_rounded : Icons.grid_view_rounded),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TextField(
                      focusNode: _searchFocusNode,
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: localization.translate('search_hint'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                tooltip: localization.translate('saved_searches'),
                                onPressed: () => appState.saveSearchQuery(_searchController.text),
                                icon: const Icon(Icons.bookmark_add_outlined),
                              ),
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                tooltip: localization.translate('clear_history'),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                                icon: const Icon(Icons.clear),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (appState.searchHistory.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localization.translate('search_history'), style: theme.textTheme.titleMedium),
                            TextButton(
                              onPressed: () => appState.clearSearchHistory(),
                              child: Text(localization.translate('clear_history')),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: appState.searchHistory
                              .map(
                                (term) => ActionChip(
                                  label: Text(term),
                                  onPressed: () => _onSearchHistoryTap(term),
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
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
                          selected: appState.selectedCategory == 'all',
                          onSelected: (_) => appState.selectCategory('all'),
                        );
                      }
                      final category = appState.categories[index - 1];
                      final selected = appState.selectedCategory == category.id;
                      return ChoiceChip(
                        label: Text(category.name),
                        selected: selected,
                        onSelected: (_) => appState.selectCategory(category.id),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: appState.filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = appState.filters[index];
                      return FilterChip(
                        label: Text(filter.label),
                        selected: appState.selectedFilter == filter.id,
                        onSelected: (_) => appState.selectFilter(filter.id),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: appState.selectedCategory == 'all' && appState.selectedFilter == 'All'
                          ? null
                          : () => appState.clearFilters(),
                      icon: const Icon(Icons.filter_alt_off_outlined),
                      label: Text(localization.translate('clear_filters')),
                    ),
                  ),
                ),
              ),
              if (appState.savedSearches.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localization.translate('saved_searches'), style: theme.textTheme.titleMedium),
                            TextButton(
                              onPressed: () => appState.clearSavedSearches(),
                              child: Text(localization.translate('clear_all')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: appState.savedSearches
                              .map(
                                (term) => InputChip(
                                  label: Text(term),
                                  onPressed: () => _onSearchHistoryTap(term),
                                  onDeleted: () => appState.removeSavedSearch(term),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localization.translate('quick_actions'), style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: appState.trendingSearches
                            .map(
                              (term) => ActionChip(
                                avatar: const Icon(Icons.trending_up, size: 16),
                                label: Text(term),
                                onPressed: () => _onSearchHistoryTap(term),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              if (recentItems.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localization.translate('recently_viewed'), style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final item = recentItems[index];
                              return SizedBox(
                                width: 220,
                                child: ItemCard(
                                  item: item,
                                  onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                                  onFavorite: () => appState.toggleFavorite(item),
                                  onLongPress: () => showItemQuickActions(context, item),
                                  onSecondaryTap: () => showItemQuickActions(context, item),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemCount: recentItems.length,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (appState.isLoading)
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (appState.items.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.inventory,
                      title: localization.translate('empty_state'),
                      subtitle: localization.translate('try_again'),
                      action: OutlinedButton(
                        onPressed: () => appState.refreshItems(),
                        child: Text(localization.translate('try_again')),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: appState.feedLayout == FeedLayout.grid
                      ? SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = appState.items[index];
                              return ItemCard(
                                item: item,
                                onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                                onFavorite: () => appState.toggleFavorite(item),
                                onLongPress: () => showItemQuickActions(context, item),
                                onSecondaryTap: () => showItemQuickActions(context, item),
                              ).animate().fadeIn(duration: 250.ms).slideY(begin: .1, curve: Curves.easeOut);
                            },
                            childCount: appState.items.length,
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: .72,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = appState.items[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ItemCard(
                                  item: item,
                                  onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                                  onFavorite: () => appState.toggleFavorite(item),
                                  onLongPress: () => showItemQuickActions(context, item),
                                  onSecondaryTap: () => showItemQuickActions(context, item),
                                ).animate().fadeIn(duration: 250.ms).slideY(begin: .1, curve: Curves.easeOut),
                              );
                            },
                            childCount: appState.items.length,
                          ),
                        ),
                ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: appState.isLoadingMore
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(color: theme.colorScheme.primary),
                          ),
                        )
                      : appState.hasMore
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: Text(localization.translate('loading'))),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedSlide(
        offset: _showBackToTop ? Offset.zero : const Offset(1.5, 0),
        duration: const Duration(milliseconds: 250),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _showBackToTop ? 1 : 0,
          child: FloatingActionButton.extended(
            onPressed: _scrollToTop,
            icon: const Icon(Icons.arrow_upward_rounded),
            label: Text(localization.translate('back_to_top')),
          ),
        ),
      ),
      ),
    );
  }
}
