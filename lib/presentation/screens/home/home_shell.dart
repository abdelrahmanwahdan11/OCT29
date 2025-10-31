import 'package:flutter/material.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/cars_controller.dart';
import '../../../application/controllers/my_car_controller.dart';
import '../../../application/controllers/settings_controller.dart';
import '../../../application/controllers/tutorial_controller.dart';
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
  });

  final AppController appController;
  final CarsController carsController;
  final MyCarController myCarController;
  final TutorialController tutorialController;
  final SettingsController settingsController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            appController: widget.appController,
            carsController: widget.carsController,
            tutorialController: widget.tutorialController,
          ),
          CatalogScreen(carsController: widget.carsController),
          CompareScreen(carsController: widget.carsController),
          MyCarScreen(controller: widget.myCarController, carsController: widget.carsController),
          SettingsScreen(appController: widget.appController, settingsController: widget.settingsController),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car_filled), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'Compare'),
          BottomNavigationBarItem(icon: Icon(Icons.garage), label: 'My Car'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
