import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/clock_sync_mock.dart';

class WalletController extends ChangeNotifier {
  WalletController({required ClockSyncMock clock}) : _clock = clock;

  final ClockSyncMock _clock;

  double availableBalance = 6200;
  double escrowHold = 1800;
  final List<Order> transactions = [];

  Future<void> bootstrap() async {
    transactions.clear();
    transactions.addAll([
      Order(
        id: 'ord_001',
        buyerId: 'demo_user',
        sellerId: 'usr_001',
        amount: 2100,
        status: 'completed',
        escrowHeld: false,
        tracking: 'Delivered',
      ),
      Order(
        id: 'ord_002',
        buyerId: 'demo_user',
        sellerId: 'usr_003',
        amount: 1800,
        status: 'escrow',
        escrowHeld: true,
        tracking: 'Awaiting confirmation',
      ),
    ]);
    notifyListeners();
  }

  void addFunds(double amount) {
    availableBalance += amount;
    notifyListeners();
  }
}
