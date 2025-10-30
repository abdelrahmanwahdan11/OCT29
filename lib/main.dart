import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'pages/auth/login_page.dart';
import 'pages/home/home_shell.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await AppState.initialize();
  runApp(AppStateScope(
    notifier: appState,
    child: const InstaDesignApp(),
  ));
}

class InstaDesignApp extends StatelessWidget {
  const InstaDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Insta Design Clone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: appState.themeMode,
          locale: appState.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const _RootDecider(),
        );
      },
    );
  }
}

class _RootDecider extends StatelessWidget {
  const _RootDecider();

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        Widget child;
        if (!appState.onboardingDone) {
          child = const OnboardingPage();
        } else if (!appState.loggedIn && !appState.isGuest) {
          child = const LoginPage();
        } else {
          child = const HomeShell();
        }
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, primary, secondary) {
            return SharedAxisTransition(
              transitionType: SharedAxisTransitionType.horizontal,
              animation: primary,
              secondaryAnimation: secondary,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}
