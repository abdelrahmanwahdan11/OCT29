import 'dart:collection';

import 'package:flutter/material.dart';

import '../view_models/auction_view_model.dart';
import '../view_models/wanted_view_model.dart';

enum DeckChannel { home, wanted }

enum DeckAction { skip, save, details, rewind }

class DeckEntry {
  DeckEntry.auction(this.auction)
      : wanted = null,
        id = 'auction_${auction.listing.id}';

  DeckEntry.wanted(this.wanted)
      : auction = null,
        id = 'wanted_${wanted.request.id}';

  final String id;
  final AuctionViewModel? auction;
  final WantedViewModel? wanted;

  bool get isAuction => auction != null;
  bool get isWanted => wanted != null;
}

class DeckController extends ChangeNotifier {
  final Map<DeckChannel, _DeckState> _states = {
    DeckChannel.home: _DeckState(),
    DeckChannel.wanted: _DeckState(),
  };

  void sync({required List<AuctionViewModel> auctions, required List<WantedViewModel> wanted}) {
    final homeEntries = <DeckEntry>[];
    final maxLength = auctions.length > wanted.length ? auctions.length : wanted.length;
    for (var i = 0; i < maxLength; i++) {
      if (i < auctions.length) {
        homeEntries.add(DeckEntry.auction(auctions[i]));
      }
      if (i < wanted.length) {
        homeEntries.add(DeckEntry.wanted(wanted[i]));
      }
    }
    _states[DeckChannel.home]!.replace(homeEntries);
    _states[DeckChannel.wanted]!.replace(wanted.map(DeckEntry.wanted).toList());
    notifyListeners();
  }

  DeckEntry? current(DeckChannel channel) => _states[channel]!.current;
  DeckEntry? next(DeckChannel channel) => _states[channel]!.next;
  bool get hasContent => _states.values.any((state) => state.current != null);
  bool canRewind(DeckChannel channel) => _states[channel]!.canRewind;

  void act(DeckChannel channel, DeckAction action) {
    if (action == DeckAction.rewind) {
      if (_states[channel]!.rewind()) {
        notifyListeners();
      }
      return;
    }
    if (_states[channel]!.consume(action)) {
      notifyListeners();
    }
  }
}

class _DeckState {
  final Queue<DeckEntry> _queue = Queue();
  final List<DeckEntry> _history = [];

  DeckEntry? get current => _queue.isEmpty ? null : _queue.first;
  DeckEntry? get next => _queue.length > 1 ? _queue.elementAt(1) : null;
  bool get canRewind => _history.isNotEmpty;

  void replace(List<DeckEntry> entries) {
    _queue
      ..clear()
      ..addAll(entries);
    _history.clear();
  }

  bool consume(DeckAction action) {
    if (_queue.isEmpty) return false;
    final removed = _queue.removeFirst();
    _history.add(removed);
    _queue.addLast(removed); // recycle locally to keep deck cycling
    return true;
  }

  bool rewind() {
    if (_history.isEmpty) return false;
    final entry = _history.removeLast();
    _queue.addFirst(entry);
    return true;
  }
}
