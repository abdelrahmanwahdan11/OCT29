import 'package:flutter/material.dart';

import '../../application/controllers/app_controller.dart';
import '../../application/controllers/auth_controller.dart';
import '../../application/controllers/cars_controller.dart';
import '../../application/controllers/my_car_controller.dart';
import '../../application/controllers/recent_views_controller.dart';
import '../../application/controllers/saved_search_controller.dart';
import '../../application/controllers/settings_controller.dart';
import '../../application/controllers/tutorial_controller.dart';
import '../screens/auth/forgot_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/catalog/catalog_screen.dart';
import '../screens/compare/compare_screen.dart';
import '../screens/details/details_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/home/home_shell.dart';
import '../screens/mycar/my_car_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/tutorial/tutorial_screen.dart';

class AppRouter {
  AppRouter({
    required this.appController,
    required this.carsController,
    required this.authController,
    required this.myCarController,
    required this.tutorialController,
    required this.settingsController,
    required this.savedSearchController,
    required this.recentViewsController,
  });

  final AppController appController;
  final CarsController carsController;
  final AuthController authController;
  final MyCarController myCarController;
  final TutorialController tutorialController;
  final SettingsController settingsController;
  final SavedSearchController savedSearchController;
  final RecentViewsController recentViewsController;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeShell(
            appController: appController,
            carsController: carsController,
            myCarController: myCarController,
            tutorialController: tutorialController,
            settingsController: settingsController,
            savedSearchController: savedSearchController,
            recentViewsController: recentViewsController,
          ),
          settings: settings,
        );
      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(appController: appController),
          settings: settings,
        );
      case '/auth/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(appController: appController, authController: authController),
          settings: settings,
        );
      case '/auth/signup':
        return MaterialPageRoute(
          builder: (_) => SignupScreen(authController: authController),
          settings: settings,
        );
      case '/auth/forgot':
        return MaterialPageRoute(
          builder: (_) => ForgotScreen(authController: authController),
          settings: settings,
        );
      case '/catalog':
        return MaterialPageRoute(
          builder: (_) => CatalogScreen(
            carsController: carsController,
            savedSearchController: savedSearchController,
            settingsController: settingsController,
          ),
          settings: settings,
        );
      case '/compare':
        return MaterialPageRoute(
          builder: (_) => CompareScreen(carsController: carsController),
          settings: settings,
        );
      case '/favorites':
        return MaterialPageRoute(
          builder: (_) => FavoritesScreen(carsController: carsController),
          settings: settings,
        );
      case '/mycar':
        return MaterialPageRoute(
          builder: (_) => MyCarScreen(controller: myCarController, carsController: carsController),
          settings: settings,
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(
            appController: appController,
            settingsController: settingsController,
            savedSearchController: savedSearchController,
          ),
          settings: settings,
        );
      case '/tutorial':
        return MaterialPageRoute(
          builder: (_) => TutorialScreen(controller: tutorialController),
          settings: settings,
        );
      default:
        if (settings.name != null && settings.name!.startsWith('/details/')) {
          final carId = settings.name!.split('/').last;
          final car = carsController.findById(carId) ??
              (carsController.visibleCars.isNotEmpty ? carsController.visibleCars.first : carsController.listController.value.first);
          return MaterialPageRoute(
            builder: (_) => DetailsScreen(
              carsController: carsController,
              car: car,
              recentViewsController: recentViewsController,
            ),
            settings: settings,
          );
        }
        return null;
    }
  }
}
