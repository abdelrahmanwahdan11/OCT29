import 'package:flutter/widgets.dart';

class PaginationController {
  PaginationController({required this.pageSize});

  final int pageSize;
  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  bool hasMore = true;

  void attachListener(VoidCallback onReachEnd) {
    scrollController.addListener(() {
      if (!scrollController.hasClients || !hasMore) return;
      final maxScroll = scrollController.position.maxScrollExtent;
      final current = scrollController.offset;
      if (current >= maxScroll * 0.8) {
        onReachEnd();
      }
    });
  }

  void reset() {
    currentPage = 0;
    hasMore = true;
  }

  void markLoaded(int itemsCount) {
    currentPage += 1;
    if (itemsCount < pageSize) {
      hasMore = false;
    }
  }

  void dispose() {
    scrollController.dispose();
  }
}
