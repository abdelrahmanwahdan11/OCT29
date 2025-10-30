import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../l10n/app_localizations.dart';
import 'home_feed_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _homeKey = GlobalKey<HomeFeedPageState>();
  final _searchKey = GlobalKey<SearchPageState>();
  final _profileKey = GlobalKey<ProfilePageState>();

  late final List<Widget> _pages = [
    HomeFeedPage(key: _homeKey),
    SearchPage(key: _searchKey),
    ProfilePage(key: _profileKey),
  ];

  void _onDestinationSelected(int value) {
    if (value == _index) {
      if (value == 0) {
        _homeKey.currentState?.scrollToTop();
      } else if (value == 1) {
        _searchKey.currentState?.scrollToTop();
      }
      return;
    }
    setState(() {
      _index = value;
    });
  }

  Future<void> _openSettings(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SharedAxisTransition(
            transitionType: SharedAxisTransitionType.horizontal,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: const SettingsPage(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titles = [
      l10n.string('home'),
      l10n.string('search'),
      l10n.string('profile'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          if (_index == 2)
            IconButton(
              onPressed: () => _openSettings(context),
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.string('settings'),
            ),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primary, secondary) {
          return SharedAxisTransition(
            animation: primary,
            secondaryAnimation: secondary,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _pages[_index],
        ),
        duration: const Duration(milliseconds: 300),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(IconlyLight.home),
            selectedIcon: Icon(IconlyBold.home),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(IconlyLight.search),
            selectedIcon: Icon(IconlyBold.search),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(IconlyLight.profile),
            selectedIcon: Icon(IconlyBold.profile),
            label: '',
          ),
        ],
      ),
    );
  }
}
