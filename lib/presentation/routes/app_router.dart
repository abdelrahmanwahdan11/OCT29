import 'package:flutter/material.dart';

import '../../application/controllers/app_controller.dart';
import '../../application/controllers/auth_controller.dart';
import '../../application/controllers/cars_controller.dart';
import '../../application/controllers/my_car_controller.dart';
import '../../application/controllers/recent_views_controller.dart';
import '../../application/controllers/review_controller.dart';
import '../../application/controllers/saved_search_controller.dart';
import '../../application/controllers/settings_controller.dart';
import '../../application/controllers/tutorial_controller.dart';
import '../../core/localization/app_localizations.dart';
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
import '../screens/review/launch_review_screen.dart';
import '../screens/roadmap/next_phase_screen.dart';
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
    required this.reviewController,
  });

  final AppController appController;
  final CarsController carsController;
  final AuthController authController;
  final MyCarController myCarController;
  final TutorialController tutorialController;
  final SettingsController settingsController;
  final SavedSearchController savedSearchController;
  final RecentViewsController recentViewsController;
  final ReviewController reviewController;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final RouteSettings effectiveSettings = _applyGuards(settings);
    final String routeName = effectiveSettings.name ?? '/';

    switch (routeName) {
      case '/':
      case '/home':
        return _buildRoute(
          effectiveSettings,
          HomeShell(
            appController: appController,
            carsController: carsController,
            myCarController: myCarController,
            tutorialController: tutorialController,
            settingsController: settingsController,
            savedSearchController: savedSearchController,
            recentViewsController: recentViewsController,
          ),
        );
      case '/onboarding':
        return _buildRoute(
          effectiveSettings,
          OnboardingScreen(appController: appController),
        );
      case '/auth/login':
        return _buildRoute(
          effectiveSettings,
          LoginScreen(appController: appController, authController: authController),
        );
      case '/auth/signup':
        return _buildRoute(
          effectiveSettings,
          SignupScreen(authController: authController),
        );
      case '/auth/forgot':
        return _buildRoute(
          effectiveSettings,
          ForgotScreen(authController: authController),
        );
      case '/catalog':
        return _buildRoute(
          effectiveSettings,
          CatalogScreen(
            carsController: carsController,
            savedSearchController: savedSearchController,
            settingsController: settingsController,
          ),
        );
      case '/compare':
        return _buildRoute(
          effectiveSettings,
          CompareScreen(carsController: carsController),
        );
      case '/favorites':
        return _buildRoute(
          effectiveSettings,
          FavoritesScreen(carsController: carsController),
        );
      case '/mycar':
        return _buildRoute(
          effectiveSettings,
          MyCarScreen(controller: myCarController, carsController: carsController),
        );
      case '/settings':
        return _buildRoute(
          effectiveSettings,
          SettingsScreen(
            appController: appController,
            settingsController: settingsController,
            savedSearchController: savedSearchController,
            reviewController: reviewController,
          ),
        );
      case '/next_phase':
        return _buildRoute(
          effectiveSettings,
          const NextPhaseScreen(),
        );
      case '/tutorial':
        return _buildRoute(
          effectiveSettings,
          TutorialScreen(controller: tutorialController),
        );
      case '/launch_review':
        return _buildRoute(
          effectiveSettings,
          LaunchReviewScreen(reviewController: reviewController),
        );
      default:
        if (routeName.startsWith('/details/')) {
          final String carId = routeName.substring('/details/'.length);
          final car = carsController.findById(carId);
          if (car == null) {
            return _buildRoute(
              effectiveSettings,
              _MissingCarScreen(
                routeName: routeName,
              ),
            );
          }
          return _buildRoute(
            effectiveSettings,
            DetailsScreen(
              carsController: carsController,
              car: car,
              recentViewsController: recentViewsController,
            ),
          );
        }
        return null;
    }
  }

  RouteSettings _applyGuards(RouteSettings settings) {
    final String requested = settings.name ?? '/';
    const Set<String> publicRoutes = <String>{
      '/onboarding',
      '/auth/login',
      '/auth/signup',
      '/auth/forgot',
    };
    final bool isAuthRoute = publicRoutes.contains(requested);

    if (!appController.hasSeenOnboarding && requested != '/onboarding') {
      return const RouteSettings(name: '/onboarding');
    }

    final bool isSignedIn = appController.user != null;
    if (!isSignedIn && !isAuthRoute) {
      return const RouteSettings(name: '/auth/login');
    }

    if (isSignedIn && isAuthRoute) {
      return const RouteSettings(name: '/home');
    }

    if (requested == '/') {
      return const RouteSettings(name: '/home');
    }

    return settings;
  }

  PageRouteBuilder<dynamic> _buildRoute(RouteSettings settings, Widget child) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, routeChild) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
            child: routeChild,
          ),
        );
      },
    );
  }
}

class _MissingCarScreen extends StatelessWidget {
  const _MissingCarScreen({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('catalog'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_car_filled_outlined, size: 56, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                l10n.t('car_not_found'),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                routeName,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/catalog'),
                child: Text(l10n.t('browse_catalog')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
