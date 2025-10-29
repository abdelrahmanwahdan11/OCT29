import 'package:flutter/material.dart';

import '../../core/env/app_env.dart';
import '../../features/auth/auth_flow.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/home_feed/home_feed_screen.dart';
import '../../features/onboarding/onboarding_story.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/wanted_feed/wanted_feed_screen.dart';
import '../../shared/controllers/app_controller.dart';
import '../../shared/controllers/auth_controller.dart';
import '../../shared/controllers/catalog_controller.dart';
import '../../shared/services/notifications_mock.dart';
import '../../shared/ui_kit/frosted_app_bar.dart';
import '../../shared/ui_kit/glass_bottom_nav.dart';
import '../../shared/ui_kit/gradient_background.dart';
import '../../shared/ui_kit/pill_button.dart';
import '../../shared/ui_kit/empty_state.dart';

class AppRouter {
  AppRouter({
    required this.environment,
    required this.appController,
    required this.authController,
    required this.catalogController,
    required this.notifications,
  });

  final AppEnvironment environment;
  final AppController appController;
  final AuthController authController;
  final CatalogController catalogController;
  final NotificationsMock notifications;

  String get initialRoute => '/onboarding_or_home';

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? initialRoute;
    switch (name) {
      case '/onboarding_or_home':
        if (authController.currentUser != null) {
          return _material(_MainShell(
            environment: environment,
            appController: appController,
            authController: authController,
            catalogController: catalogController,
            notifications: notifications,
          ));
        }
        return _material(OnboardingStory(onFinish: _handleOnboardingFinish));
      case '/auth':
        return _material(AuthFlow(onAuthenticated: _handleAuthenticated));
      case '/home':
        return _material(_MainShell(
          environment: environment,
          appController: appController,
          authController: authController,
          catalogController: catalogController,
          notifications: notifications,
        ));
      default:
        return _material(_NotFoundScreen(routeName: name));
    }
  }

  MaterialPageRoute<dynamic> _material(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  void _handleOnboardingFinish(BuildContext context, bool browseAsGuest) {
    if (browseAsGuest) {
      authController.continueAsGuest();
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  void _handleAuthenticated(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell({
    required this.environment,
    required this.appController,
    required this.authController,
    required this.catalogController,
    required this.notifications,
  });

  final AppEnvironment environment;
  final AppController appController;
  final AuthController authController;
  final CatalogController catalogController;
  final NotificationsMock notifications;

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int index = 0;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final backgrounds = [
      'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1200',
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1200',
      'https://images.unsplash.com/photo-1515165562835-c3b8b1eea6cf?q=80&w=1200',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1200',
    ];

    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        imageUrl: backgrounds[index],
        child: SafeArea(
          child: Column(
            children: [
              FrostedAppBar(
                title: Text(_titleForIndex(index)),
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => _openSettings(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_active_outlined),
                    onPressed: () => _showNotifications(context),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) => setState(() => index = value),
                  children: [
                    HomeFeedScreen(controller: widget.catalogController, authController: widget.authController),
                    ExploreScreen(controller: widget.catalogController),
                    WantedFeedScreen(controller: widget.catalogController),
                    ProfileScreen(authController: widget.authController, appController: widget.appController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: index,
        onChanged: (value) {
          setState(() => index = value);
          pageController.animateToPage(value, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
        },
      ),
    );
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'الصفحة الرئيسية';
      case 1:
        return 'استكشف';
      case 2:
        return 'الطلبات';
      case 3:
        return 'الملف الشخصي';
      default:
        return widget.environment.appName;
    }
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PillButton(
                label: 'الوضع الليلي',
                onPressed: () {
                  final isDark = widget.appController.themeMode == ThemeMode.dark;
                  widget.appController.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
                },
              ),
              const SizedBox(height: 12),
              PillButton(
                label: 'تغيير اللغة',
                onPressed: () {
                  final isArabic = widget.appController.locale.languageCode == 'ar';
                  widget.appController.setLocale(isArabic ? const Locale('en') : const Locale('ar'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('التنبيهات'),
          content: ValueListenableBuilder(
            valueListenable: widget.notifications.log,
            builder: (context, entries, child) {
              final list = entries as List<String>;
              if (list.isEmpty) {
                return const EmptyState(
                  icon: Icons.notifications_off_outlined,
                  title: 'لا إشعارات بعد',
                  subtitle: 'سنعلمك فور وجود تحديثات جديدة',
                );
              }
              return SizedBox(
                width: 320,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.circle_notifications),
                      title: Text(list[index]),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route not found: $routeName'),
      ),
    );
  }
}
