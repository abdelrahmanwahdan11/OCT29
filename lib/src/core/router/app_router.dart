import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../presentation/pages/about_page.dart';
import '../../presentation/pages/add_car_page.dart';
import '../../presentation/pages/auth_page.dart';
import '../../presentation/pages/catalog_page.dart';
import '../../presentation/pages/compare_page.dart';
import '../../presentation/pages/details_page.dart';
import '../../presentation/pages/favorites_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/my_car_page.dart';
import '../../presentation/pages/notifications_page.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/search_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter(this.controllers);

  final AppControllerRegistry controllers;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return _build(settings, SplashPage(controllers: controllers));
      case '/onboarding':
        return _build(settings, OnboardingPage(controllers: controllers));
      case '/auth':
        return _build(settings, AuthPage(controllers: controllers));
      case '/home':
        return _build(settings, HomePage(controllers: controllers));
      case '/catalog':
        return _build(settings, CatalogPage(controllers: controllers));
      case '/search':
        return _build(settings, SearchPage(controllers: controllers));
      case '/compare':
        return _build(settings, ComparePage(controllers: controllers));
      case '/add-car':
        return _build(settings, AddCarPage(controllers: controllers));
      case '/my-car':
        return _build(settings, MyCarPage(controllers: controllers));
      case '/favorites':
        return _build(settings, FavoritesPage(controllers: controllers));
      case '/notifications':
        return _build(settings, NotificationsPage(controllers: controllers));
      case '/settings':
        return _build(settings, SettingsPage(controllers: controllers));
      case '/about':
        return _build(settings, const AboutPage());
      default:
        if (settings.name?.startsWith('/details/') ?? false) {
          final segments = settings.name!.split('/');
          final id = segments.last;
          return _build(settings, DetailsPage(controllers: controllers, carId: id));
        }
        return _build(settings, SplashPage(controllers: controllers));
    }
  }

  Route<dynamic> _build(RouteSettings settings, Widget child) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: animation.drive(tween), child: child),
        );
      },
      pageBuilder: (_, __, ___) => child,
    );
  }
}
