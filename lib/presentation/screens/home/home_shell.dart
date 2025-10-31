import 'package:flutter/material.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/my_car_controller.dart';
import '../../../application/controllers/recent_views_controller.dart';
import '../../../application/controllers/saved_search_controller.dart';
import '../../../application/controllers/settings_controller.dart';
import '../../../application/controllers/tutorial_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../catalog/catalog_screen.dart';
import '../compare/compare_screen.dart';
import '../home/home_screen.dart';
import '../mycar/my_car_screen.dart';
import '../settings/settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.appController,
    required this.carsController,
    required this.myCarController,
    required this.tutorialController,
    required this.settingsController,
    required this.savedSearchController,
    required this.recentViewsController,
  });

  final AppController appController;
  final CarsController carsController;
  final MyCarController myCarController;
  final TutorialController tutorialController;
  final SettingsController settingsController;
  final SavedSearchController savedSearchController;
  final RecentViewsController recentViewsController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.carsController,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final favoritesCount = widget.carsController.favoriteIds.length;
        final compareCount = widget.carsController.compareSet.ids.length;
        return Scaffold(
          body: IndexedStack(
            index: _index,
            children: [
              HomeScreen(
                appController: widget.appController,
                carsController: widget.carsController,
                tutorialController: widget.tutorialController,
                recentViewsController: widget.recentViewsController,
              ),
              CatalogScreen(
                carsController: widget.carsController,
                savedSearchController: widget.savedSearchController,
                settingsController: widget.settingsController,
              ),
              CompareScreen(carsController: widget.carsController),
              MyCarScreen(controller: widget.myCarController, carsController: widget.carsController),
              SettingsScreen(
                appController: widget.appController,
                settingsController: widget.settingsController,
                savedSearchController: widget.savedSearchController,
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: (value) => setState(() => _index = value),
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: l10n.t('home')),
              BottomNavigationBarItem(
                icon: _BadgeIcon(
                  icon: Icons.directions_car_filled,
                  count: favoritesCount,
                  semanticsLabel: l10n.t('favorites'),
                ),
                label: l10n.t('catalog'),
              ),
              BottomNavigationBarItem(
                icon: _BadgeIcon(
                  icon: Icons.compare_arrows,
                  count: compareCount,
                  semanticsLabel: l10n.t('compare'),
                ),
                label: l10n.t('compare'),
              ),
              BottomNavigationBarItem(icon: const Icon(Icons.garage), label: l10n.t('my_car')),
              BottomNavigationBarItem(icon: const Icon(Icons.settings), label: l10n.t('settings')),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({required this.icon, required this.count, required this.semanticsLabel});

  final IconData icon;
  final int count;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Semantics(
              label: '$count $semanticsLabel',
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
                child: Center(
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
