import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/clock_sync_mock.dart';

class OrdersController extends ChangeNotifier {
  OrdersController({required ClockSyncMock clock}) : _clock = clock;

  final ClockSyncMock _clock;
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> bootstrap() async {
    _orders
      ..clear()
      ..addAll([
        Order(
          id: 'ord_001',
          buyerId: 'demo_user',
          sellerId: 'usr_005',
          amount: 1400,
          status: 'shipping',
          escrowHeld: true,
          tracking: 'Out for delivery',
        ),
        Order(
          id: 'ord_002',
          buyerId: 'demo_user',
          sellerId: 'usr_006',
          amount: 820,
          status: 'awaiting_payment',
          escrowHeld: false,
          tracking: 'Pending payment',
        ),
      ]);
    notifyListeners();
  }
}
