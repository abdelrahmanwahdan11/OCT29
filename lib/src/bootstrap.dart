import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/controllers/app_controllers.dart';
import 'core/theme/eink_theme.dart';
import 'data/datasources/local_car_data_source.dart';
import 'data/repositories/local_car_repository.dart';

typedef BootstrapBuilder = Widget Function(AppControllerRegistry controllers);

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<AppControllerRegistry> _future;

  @override
  void initState() {
    super.initState();
    _future = _initialize();
  }

  Future<AppControllerRegistry> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = const EInkTheme();
    final carDataSource = LocalCarDataSource();
    final tipDataSource = LocalTipDataSource();
    final repository = LocalCarRepository(carDataSource);

    final themeController = ThemeController(prefs, theme);
    final localeController = LocaleController(prefs);
    final onboardingController = OnboardingController();
    final authController = AuthController(prefs);
    final coachMarkController = CoachMarkController();
    final homeController = HomeController(repository);
    final catalogController = CatalogController(repository);
    final searchController = SearchController(repository);
    final carDetailsController = CarDetailsController(repository);
    final compareController = CompareController(prefs);
    final myCarController = MyCarController(prefs);
    final notificationController = NotificationController(prefs);
    final tipsController = TipsController(tipDataSource);

    await authController.load();
    await compareController.load();
    await myCarController.load();
    await notificationController.load();
    await tipsController.load();
    await homeController.load();
    await catalogController.load();

    return AppControllerRegistry(
      themeController: themeController,
      localeController: localeController,
      onboardingController: onboardingController,
      authController: authController,
      coachMarkController: coachMarkController,
      homeController: homeController,
      catalogController: catalogController,
      searchController: searchController,
      carDetailsController: carDetailsController,
      compareController: compareController,
      myCarController: myCarController,
      notificationController: notificationController,
      tipsController: tipsController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppControllerRegistry>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final controllers = snapshot.data!;
        return AutoInkApp(controllers: controllers);
      },
    );
  }

  @override
  void dispose() {
    _future.then((value) => value.dispose());
    super.dispose();
  }
}
