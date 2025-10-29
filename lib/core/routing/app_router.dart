import 'package:flutter/material.dart';

import '../../core/env/app_env.dart';
import '../../features/auction_details/auction_details_screen.dart';
import '../../features/auth/auth_flow.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/create_auction/create_auction_screen.dart';
import '../../features/create_wanted/create_wanted_screen.dart';
import '../../features/explore/catalog_search_delegate.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home_feed/home_feed_screen.dart';
import '../../features/merchant_dashboard/merchant_dashboard_screen.dart';
import '../../features/onboarding/onboarding_story.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reviews/reviews_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/support/support_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/wanted_details/wanted_details_screen.dart';
import '../../features/wanted_feed/wanted_feed_screen.dart';
import '../../features/content/static_content_screens.dart';
import '../../shared/controllers/app_controller.dart';
import '../../shared/controllers/auth_controller.dart';
import '../../shared/controllers/catalog_controller.dart';
import '../../shared/controllers/content_controller.dart';
import '../../shared/services/notifications_mock.dart';
import '../../shared/ui_kit/empty_state.dart';
import '../../shared/ui_kit/frosted_app_bar.dart';
import '../../shared/ui_kit/glass_bottom_nav.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/gradient_background.dart';
import '../../shared/utils/app_localizations.dart';
import 'package:iconly/iconly.dart';

class AppRouter {
  AppRouter({
    required this.environment,
    required this.appController,
    required this.authController,
    required this.catalogController,
    required this.contentController,
    required this.notifications,
  });

  final AppEnvironment environment;
  final AppController appController;
  final AuthController authController;
  final CatalogController catalogController;
  final ContentController contentController;
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
      case '/settings':
        return _material(const SettingsScreen());
      case '/wallet':
        return _material(const WalletScreen());
      case '/chat':
        return _material(const ChatScreen());
      case '/checkout':
        return _material(const CheckoutScreen());
      case '/orders':
        return _material(const OrdersScreen());
      case '/favorites':
        return _material(const FavoritesScreen());
      case '/reviews':
        return _material(const ReviewsScreen());
      case '/support':
        return _material(const SupportScreen());
      case '/content':
        return _material(StaticContentListScreen(controller: contentController));
      case '/content_detail':
        final key = settings.arguments as String? ?? '';
        return _material(StaticContentDetailScreen(controller: contentController, pageKey: key));
      case '/create_auction':
        return _material(const CreateAuctionScreen());
      case '/create_wanted':
        return _material(const CreateWantedScreen());
      case '/auction_details':
        return _material(const AuctionDetailsScreen());
      case '/wanted_details':
        return _material(const WantedDetailsScreen());
      case '/merchant':
        return _material(const MerchantDashboardScreen());
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
    final strings = MazadLocalizations.of(context);
    final backgrounds = [
      'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1600',
      'https://images.unsplash.com/photo-1515165562835-c3b8b1eea6cf?q=80&w=1600',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
      'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
    ];
    final navItems = [
      GlassNavItemData(icon: IconlyBold.home, label: strings.t('home')),
      GlassNavItemData(icon: IconlyBold.search, label: strings.t('explore')),
      GlassNavItemData(icon: IconlyBold.category, label: strings.t('wanted')),
      GlassNavItemData(icon: IconlyBold.profile, label: strings.t('profile')),
      GlassNavItemData(icon: IconlyBold.setting, label: strings.t('settings')),
    ];

    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        imageUrl: backgrounds[index.clamp(0, backgrounds.length - 1)],
        child: SafeArea(
          child: Column(
            children: [
              FrostedAppBar(
                title: Text(_titleForIndex(context, index)),
                leading: IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Navigator.of(context).pushNamed('/settings'),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () => showSearch(
                      context: context,
                      delegate: CatalogSearchDelegate(controller: widget.catalogController, strings: strings),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.brightness_6_outlined),
                    onPressed: () {
                      widget.appController.toggleTheme();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.translate_rounded),
                    onPressed: () {
                      widget.appController.cycleLocale();
                    },
                  ),
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
                    _MoreHub(links: _buildQuickLinks(strings)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: index,
        items: navItems,
        onChanged: (value) {
          setState(() => index = value);
          pageController.animateToPage(value, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
        },
      ),
    );
  }

  String _titleForIndex(BuildContext context, int index) {
    final strings = MazadLocalizations.of(context);
    switch (index) {
      case 0:
        return strings.t('home');
      case 1:
        return strings.t('explore');
      case 2:
        return strings.t('wanted');
      case 3:
        return strings.t('profile');
      case 4:
        return strings.t('settings');
      default:
        return widget.environment.appName;
    }
  }

  List<_QuickLink> _buildQuickLinks(MazadLocalizations strings) {
    return [
      _QuickLink(label: strings.t('create_auction'), route: '/create_auction', icon: Icons.gavel_outlined),
      _QuickLink(label: strings.t('create_wanted'), route: '/create_wanted', icon: Icons.post_add_outlined),
      _QuickLink(label: strings.t('wallet'), route: '/wallet', icon: Icons.account_balance_wallet_outlined),
      _QuickLink(label: strings.t('chat'), route: '/chat', icon: Icons.chat_bubble_outline),
      _QuickLink(label: strings.t('checkout'), route: '/checkout', icon: Icons.receipt_long_outlined),
      _QuickLink(label: strings.t('orders'), route: '/orders', icon: Icons.timeline_outlined),
      _QuickLink(label: strings.t('favorites'), route: '/favorites', icon: Icons.favorite_outline),
      _QuickLink(label: strings.t('reviews'), route: '/reviews', icon: Icons.star_border),
      _QuickLink(label: strings.t('support'), route: '/support', icon: Icons.support_agent_outlined),
      _QuickLink(label: strings.t('static_pages'), route: '/content', icon: Icons.menu_book_outlined),
      _QuickLink(label: strings.t('merchant_dashboard'), route: '/merchant', icon: Icons.dashboard_outlined),
    ];
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final strings = MazadLocalizations.of(context);
        return AlertDialog(
          title: Text(strings.t('notifications')),
          content: ValueListenableBuilder(
            valueListenable: widget.notifications.log,
            builder: (context, entries, child) {
              final list = entries as List<String>;
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.notifications_off_outlined,
                  title: strings.t('empty_notifications'),
                  subtitle: strings.t('empty_notifications_sub'),
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

class _MoreHub extends StatelessWidget {
  const _MoreHub({required this.links});

  final List<_QuickLink> links;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              child: ListTile(
                leading: Icon(link.icon, color: Theme.of(context).colorScheme.primary),
                title: Text(link.label),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).pushNamed(link.route),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickLink {
  const _QuickLink({required this.label, required this.route, required this.icon});

  final String label;
  final String route;
  final IconData icon;
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
