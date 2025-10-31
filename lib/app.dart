import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/controllers/app_controller.dart';
import 'application/controllers/auth_controller.dart';
import 'application/controllers/cars_controller.dart';
import 'application/controllers/my_car_controller.dart';
import 'application/controllers/recent_views_controller.dart';
import 'application/controllers/saved_search_controller.dart';
import 'application/controllers/settings_controller.dart';
import 'application/controllers/tutorial_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/car_local_data_source.dart';
import 'data/repositories/car_repository_impl.dart';
import 'presentation/routes/app_router.dart';

class AutoDeckApp extends StatefulWidget {
  const AutoDeckApp({super.key});

  @override
  State<AutoDeckApp> createState() => _AutoDeckAppState();
}

class _AutoDeckAppState extends State<AutoDeckApp> {
  late final SharedPreferences _prefs;
  late final AppController _appController;
  late final AuthController _authController;
  late final CarsController _carsController;
  late final MyCarController _myCarController;
  late final TutorialController _tutorialController;
  late final SettingsController _settingsController;
  late final SavedSearchController _savedSearchController;
  late final RecentViewsController _recentViewsController;
  late final AppRouter _router;

  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    _appController = AppController(_prefs);
    final dataSource = CarLocalDataSource(_prefs);
    final repository = CarRepositoryImpl(dataSource);
    _carsController = CarsController(repository);
    _authController = AuthController();
    _myCarController = MyCarController();
    _tutorialController = TutorialController();
    _settingsController = SettingsController(_appController);
    _savedSearchController = SavedSearchController(_prefs, _carsController);
    _recentViewsController = RecentViewsController(_prefs, _carsController);
    _router = AppRouter(
      appController: _appController,
      carsController: _carsController,
      authController: _authController,
      myCarController: _myCarController,
      tutorialController: _tutorialController,
      settingsController: _settingsController,
      savedSearchController: _savedSearchController,
      recentViewsController: _recentViewsController,
    );
    await _appController.ensureGuestSession();
    await _carsController.initialize();
    setState(() {
      _ready = true;
    });
  }

  @override
  void dispose() {
    _carsController.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(home: SizedBox.shrink());
    }

    return AnimatedBuilder(
      animation: _appController,
      builder: (context, _) {
        final themeMode = _appController.themeMode;
        final accent = _appController.primaryColor;
        return MaterialApp(
          title: 'AutoDeck',
          debugShowCheckedModeBanner: false,
          locale: _appController.locale,
          supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: themeMode,
          theme: AppTheme.light(accent),
          darkTheme: AppTheme.dark(accent),
          onGenerateRoute: _router.onGenerateRoute,
        );
      },
    );
  }
}
