import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/fake_api_service.dart';
import '../../widgets/post_card.dart';
import '../../widgets/stories_bar.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  State<HomeFeedPage> createState() => HomeFeedPageState();
}

class HomeFeedPageState extends State<HomeFeedPage> {
  final ScrollController _controller = ScrollController();
  final List<FakePost> _posts = [];
  final List<String> _stories = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 0;
  static const _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _fetchStories();
    _loadMore();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
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

  Future<void> _fetchStories() async {
    final data = await FakeApiService.fetchStories();
    if (!mounted) return;
    setState(() {
      _stories
        ..clear()
        ..addAll(data);
    });
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
    final newPosts = await FakeApiService.fetchPosts(
      page: _page,
      pageSize: _pageSize,
    );
    if (!mounted) return;
    setState(() {
      if (refresh) {
        _posts
          ..clear()
          ..addAll(newPosts);
      } else {
        _posts.addAll(newPosts);
      }
      if (newPosts.length < _pageSize) {
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
    final threshold = _controller.position.maxScrollExtent * 0.8;
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
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _posts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return StoriesBar(stories: _stories);
          }
          if (index == _posts.length + 1) {
            if (_loading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (!_hasMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text(l10n.string('no_more'))),
              );
            }
            return const SizedBox.shrink();
          }
          final post = _posts[index - 1];
          return PostCard(post: post);
        },
      ),
    );
  }
}
