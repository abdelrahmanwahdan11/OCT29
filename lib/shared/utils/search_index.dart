import '../view_models/auction_view_model.dart';
import '../view_models/wanted_view_model.dart';

enum SearchScope { all, auctions, wanted }

class SearchResult {
  const SearchResult({required this.title, required this.subtitle, required this.score, this.type});

  final String title;
  final String subtitle;
  final double score;
  final SearchScope? type;
}

class SearchIndex {
  final List<_IndexedDocument> _documents = [];

  void indexAuctions(List<AuctionViewModel> auctions) {
    for (final auction in auctions) {
      _documents.add(
        _IndexedDocument(
          scope: SearchScope.auctions,
          title: auction.listing.title,
          subtitle: auction.listing.description,
          tokens: _tokenize([
            auction.listing.title,
            auction.listing.description,
            auction.listing.category,
            auction.listing.brand,
            auction.listing.condition,
            auction.listing.location,
          ]),
          timestamp: auction.auction.endTimeUtc.millisecondsSinceEpoch,
        ),
      );
    }
  }

  void indexWanted(List<WantedViewModel> wanted) {
    for (final item in wanted) {
      _documents.add(
        _IndexedDocument(
          scope: SearchScope.wanted,
          title: item.request.title,
          subtitle: item.request.specs,
          tokens: _tokenize([
            item.request.title,
            item.request.specs,
            item.request.location,
          ]),
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  List<SearchResult> search(String query, {SearchScope scope = SearchScope.all}) {
    if (query.trim().isEmpty) return [];
    final qTokens = _tokenize([query]);
    final results = <SearchResult>[];
    for (final doc in _documents) {
      if (scope != SearchScope.all && doc.scope != scope) continue;
      var score = 0.0;
      for (final token in qTokens) {
        if (doc.tokens.contains(token)) {
          score += 2;
        } else {
          for (final candidate in doc.tokens) {
            if (candidate.contains(token)) {
              score += 1.0;
            }
          }
        }
      }
      if (score > 0) {
        final recencyBoost = 1 + (doc.timestamp / DateTime.now().millisecondsSinceEpoch);
        results.add(SearchResult(
          title: doc.title,
          subtitle: doc.subtitle,
          score: score * recencyBoost,
          type: doc.scope,
        ));
      }
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(20).toList();
  }

  Set<String> _tokenize(List<String> fields) {
    return fields
        .expand((text) => text
            .toLowerCase()
            .replaceAll(RegExp(r'[^\p{L}\p{Nd}\s]', unicode: true), ' ')
            .split(RegExp(r'\s+')))
        .where((token) => token.isNotEmpty)
        .toSet();
  }
}

class _IndexedDocument {
  _IndexedDocument({
    required this.scope,
    required this.title,
    required this.subtitle,
    required this.tokens,
    required this.timestamp,
  });

  final SearchScope scope;
  final String title;
  final String subtitle;
  final Set<String> tokens;
  final int timestamp;
}
