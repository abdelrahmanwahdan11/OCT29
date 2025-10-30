import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/fake_api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _images = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 0;
  static const _pageSize = 18;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _loadMore();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    if (_controller.hasClients) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _loadMore({bool refresh = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    if (refresh) {
      _page = 0;
      _hasMore = true;
    }
    final results = await FakeApiService.fetchGridImages(
      page: _page,
      pageSize: _pageSize,
    );
    if (!mounted) return;
    setState(() {
      if (refresh) {
        _images
          ..clear()
          ..addAll(results);
      } else {
        _images.addAll(results);
      }
      if (results.length < _pageSize) {
        _hasMore = false;
      } else {
        _page++;
      }
      _loading = false;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || !_hasMore || _loading) {
      return;
    }
    final threshold = _controller.position.maxScrollExtent * 0.7;
    if (_controller.position.pixels >= threshold) {
      _loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await _loadMore(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.string('search'),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == _images.length) {
                    if (_loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!_hasMore) {
                      return Center(
                        child: Text(l10n.string('no_more')),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
                childCount: _images.length + 1,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ),
        ],
      ),
    );
  }
}
