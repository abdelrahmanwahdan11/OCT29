import 'package:flutter/widgets.dart';

import 'app_controller.dart';
import 'auth_controller.dart';
import 'catalog_controller.dart';
import 'chat_controller.dart';
import 'orders_controller.dart';
import 'wallet_controller.dart';

class InheritedAppScope extends InheritedWidget {
  const InheritedAppScope({
    super.key,
    required super.child,
    required this.appController,
    required this.authController,
    required this.catalogController,
    required this.walletController,
    required this.chatController,
    required this.ordersController,
  });

  final AppController appController;
  final AuthController authController;
  final CatalogController catalogController;
  final WalletController walletController;
  final ChatController chatController;
  final OrdersController ordersController;

  static InheritedAppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<InheritedAppScope>();
    assert(scope != null, 'InheritedAppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant InheritedAppScope oldWidget) {
    return appController != oldWidget.appController ||
        authController != oldWidget.authController ||
        catalogController != oldWidget.catalogController ||
        walletController != oldWidget.walletController ||
        chatController != oldWidget.chatController ||
        ordersController != oldWidget.ordersController;
  }
}
