import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  AppState? _appState;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
  }

  void _onSearchChanged(String value) {
    final appState = _appState;
    if (appState == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      appState.setSearchQuery(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    _appState = appState;
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: localization.translate('search_hint'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                      ),
                    ),
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
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = appState.items[index];
                        return ItemCard(
                          item: item,
                          onTap: () => Navigator.of(context).pushNamed('${AppRoutes.itemDetails}/${item.id}'),
                          onFavorite: () => appState.toggleFavorite(item),
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
    );
  }
}
