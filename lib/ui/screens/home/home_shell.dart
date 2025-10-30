import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';
import '../explore/explore_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = HomeTab.home});

  final HomeTab initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _index = widget.initialTab.index;
    _pageController = PageController(initialPage: _index);
  }

  void _onTap(int index) {
    setState(() => _index = index);
    _pageController.jumpToPage(index);
  }

  @override
  void didUpdateWidget(covariant HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _onTap(widget.initialTab.index);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final tabs = [
      _HomeTabConfig(
        tab: HomeTab.home,
        icon: IconlyLight.home,
        iconSelected: IconlyBold.home,
        label: localization.translate('home'),
        builder: const HomeScreen(),
      ),
      _HomeTabConfig(
        tab: HomeTab.explore,
        icon: IconlyLight.category,
        iconSelected: IconlyBold.category,
        label: localization.translate('explore'),
        builder: const ExploreScreen(),
      ),
      _HomeTabConfig(
        tab: HomeTab.favorites,
        icon: IconlyLight.heart,
        iconSelected: IconlyBold.heart,
        label: localization.translate('favorites'),
        builder: const FavoritesScreen(),
      ),
      _HomeTabConfig(
        tab: HomeTab.profile,
        icon: IconlyLight.profile,
        iconSelected: IconlyBold.profile,
        label: localization.translate('profile'),
        builder: const ProfileScreen(),
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: tabs.map((tab) => tab.builder).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTap,
        destinations: tabs
            .map(
              (config) => NavigationDestination(
                icon: Icon(config.icon),
                selectedIcon: Icon(config.iconSelected),
                label: config.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

enum HomeTab { home, explore, favorites, profile }

class _HomeTabConfig {
  const _HomeTabConfig({
    required this.tab,
    required this.icon,
    required this.iconSelected,
    required this.label,
    required this.builder,
  });

  final HomeTab tab;
  final IconData icon;
  final IconData iconSelected;
  final String label;
  final Widget builder;
}

class HomeTabRoute {
  static HomeTab fromName(String name) {
    switch (name) {
      case AppRoutes.explore:
        return HomeTab.explore;
      case AppRoutes.favorites:
        return HomeTab.favorites;
      case AppRoutes.profile:
        return HomeTab.profile;
      default:
        return HomeTab.home;
    }
  }
}
