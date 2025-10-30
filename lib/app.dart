import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/routes.dart';
import 'state/app_state.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/register_screen.dart';
import 'ui/screens/details/item_details_screen.dart';
import 'ui/screens/collections/collections_screen.dart';
import 'ui/screens/compare/compare_screen.dart';
import 'ui/screens/home/home_shell.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';
import 'ui/screens/splash/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      appState: appState,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context).translate('app_name'),
            locale: appState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: AppTheme.lightTheme(ThemeData.light().textTheme),
            darkTheme: AppTheme.darkTheme(ThemeData.dark().textTheme),
            themeMode: appState.themeMode,
            builder: Animate.restartOnHotReload,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case AppRoutes.splash:
                  return MaterialPageRoute(builder: (_) => const SplashScreen());
                case AppRoutes.onboarding:
                  return MaterialPageRoute(builder: (_) => const OnboardingScreen());
                case AppRoutes.login:
                  return MaterialPageRoute(builder: (_) => const LoginScreen());
                case AppRoutes.register:
                  return MaterialPageRoute(builder: (_) => const RegisterScreen());
                case AppRoutes.home:
                  return MaterialPageRoute(builder: (_) => const HomeShell());
                case AppRoutes.favorites:
                case AppRoutes.explore:
                case AppRoutes.profile:
                  return MaterialPageRoute(
                    builder: (_) => HomeShell(initialTab: HomeTabRoute.fromName(settings.name!)),
                  );
                case AppRoutes.collections:
                  return MaterialPageRoute(builder: (_) => const CollectionsScreen());
                case AppRoutes.compare:
                  return MaterialPageRoute(builder: (_) => const CompareScreen());
                default:
                  if (settings.name != null && settings.name!.startsWith('${AppRoutes.itemDetails}/')) {
                    final id = settings.name!.split('/').last;
                    return MaterialPageRoute(
                      builder: (_) => ItemDetailsScreen(itemId: id),
                    );
                  }
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState appState, required super.child}) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.notifier!;
  }
}
