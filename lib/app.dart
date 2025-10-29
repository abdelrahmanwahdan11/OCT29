import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/env/app_env.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/shared_prefs_storage.dart';
import 'shared/controllers/app_controller.dart';
import 'shared/controllers/app_scope.dart';
import 'shared/controllers/auth_controller.dart';
import 'shared/controllers/catalog_controller.dart';
import 'shared/controllers/chat_controller.dart';
import 'shared/controllers/orders_controller.dart';
import 'shared/controllers/wallet_controller.dart';
import 'shared/services/clock_sync_mock.dart';
import 'shared/services/notifications_mock.dart';

class MazadWantedApp extends StatefulWidget {
  const MazadWantedApp({
    super.key,
    required this.environment,
    required this.storage,
  });

  final AppEnvironment environment;
  final SharedPrefsStorage storage;

  @override
  State<MazadWantedApp> createState() => _MazadWantedAppState();
}

class _MazadWantedAppState extends State<MazadWantedApp> {
  late final AppController appController;
  late final AuthController authController;
  late final CatalogController catalogController;
  late final WalletController walletController;
  late final ChatController chatController;
  late final OrdersController ordersController;
  late final AppRouter router;

  @override
  void initState() {
    super.initState();
    final clock = ClockSyncMock();
    final notifications = NotificationsMock();

    appController = AppController(storage: widget.storage)..bootstrap();
    authController = AuthController(storage: widget.storage)..bootstrap();
    catalogController = CatalogController();
    walletController = WalletController(clock: clock);
    chatController = ChatController(clock: clock, notifications: notifications);
    ordersController = OrdersController(clock: clock);

    router = AppRouter(
      environment: widget.environment,
      appController: appController,
      authController: authController,
      catalogController: catalogController,
      notifications: notifications,
    );

    // ignore: discarded_futures
    catalogController.bootstrap();
    // ignore: discarded_futures
    walletController.bootstrap();
    // ignore: discarded_futures
    chatController.bootstrap();
    // ignore: discarded_futures
    ordersController.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, _) {
        final theme = buildAppTheme(appController);
        return AnimatedBuilder(
          animation: authController,
          builder: (context, __) {
            return InheritedAppScope(
              appController: appController,
              authController: authController,
              catalogController: catalogController,
              walletController: walletController,
              chatController: chatController,
              ordersController: ordersController,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: router.onGenerateRoute,
                initialRoute: router.initialRoute,
                theme: theme.light,
                darkTheme: theme.dark,
                themeMode: appController.themeMode,
                locale: appController.locale,
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    appController.dispose();
    authController.dispose();
    catalogController.dispose();
    walletController.dispose();
    chatController.dispose();
    ordersController.dispose();
    super.dispose();
  }
}
