import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/eink_theme.dart';
import '../../core/utils/color_utils.dart';
import '../../data/datasources/local_car_data_source.dart';
import '../../data/repositories/local_car_repository.dart';
import '../../domain/entities/car.dart';
import '../../domain/entities/tips.dart';

abstract class BaseController extends ChangeNotifier {}

class ThemeController extends BaseController {
  ThemeController(this._prefs, this._theme) {
    _themeMode = _prefs.getString(AppPreferences.themeMode)?.toThemeMode() ?? ThemeMode.system;
    _accentColor = _prefs.getString(AppPreferences.primaryColor)?.let(ColorUtils.fromHex) ?? _theme.defaultAccent;
  }

  final SharedPreferences _prefs;
  final EInkTheme _theme;

  late ThemeMode _themeMode;
  late Color _accentColor;

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setString(AppPreferences.themeMode, _themeMode.name);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString(AppPreferences.themeMode, mode.name);
    notifyListeners();
  }

  Future<void> setAccent(Color color) async {
    _accentColor = color;
    await _prefs.setString(AppPreferences.primaryColor, ColorUtils.toHex(color));
    notifyListeners();
  }
}

class LocaleController extends BaseController {
  LocaleController(this._prefs) {
    final saved = _prefs.getString(AppPreferences.locale);
    if (saved != null) {
      _locale = Locale(saved);
    }
  }

  final SharedPreferences _prefs;
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setString(AppPreferences.locale, locale.languageCode);
    notifyListeners();
  }
}

class OnboardingController extends BaseController {
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
  bool _hasSeen = false;

  bool get hasSeen => _hasSeen;

  void markSeen() {
    if (_hasSeen) return;
    _hasSeen = true;
    notifyListeners();
  }
}

class AuthController extends BaseController {
  AuthController(this._prefs);

  final SharedPreferences _prefs;
  UserProfile? _user;

  UserProfile? get user => _user;
  bool get isAuthenticated => _user != null && !(_user?.isGuest ?? true);

  Future<void> load() async {
    final raw = _prefs.getString(AppPreferences.authUser);
    if (raw == null) return;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _user = UserProfile.fromJson(map);
    notifyListeners();
  }

  Future<void> login(String email) async {
    _user = UserProfile(id: email, name: email.split('@').first, email: email, isGuest: false);
    await _prefs.setString(AppPreferences.authUser, jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    _user = UserProfile(id: 'guest', name: 'ضيف', email: '', isGuest: true);
    await _prefs.setString(AppPreferences.authUser, jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _prefs.remove(AppPreferences.authUser);
    notifyListeners();
  }
}

class CoachMarkController extends BaseController {
  bool _enabled = true;

  bool get enabled => _enabled;

  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }
}

class HomeController extends BaseController {
  HomeController(this._carRepository) {
    _heroIndex = ValueNotifier<int>(0);
  }

  final LocalCarRepository _carRepository;
  late final ValueNotifier<int> _heroIndex;
  final StreamController<List<Car>> _recommendedStream = StreamController.broadcast();
  final StreamController<List<Car>> _latestStream = StreamController.broadcast();

  ValueNotifier<int> get heroFrame => _heroIndex;
  Stream<List<Car>> get recommended => _recommendedStream.stream;
  Stream<List<Car>> get latest => _latestStream.stream;

  Future<void> load() async {
    final cars = await _carRepository.fetchCars();
    _recommendedStream.add(cars.take(5).toList());
    _latestStream.add(cars);
    notifyListeners();
  }

  void updateHeroFrame(int frame) {
    _heroIndex.value = frame;
  }

  @override
  void dispose() {
    _heroIndex.dispose();
    _recommendedStream.close();
    _latestStream.close();
    super.dispose();
  }
}

class CatalogController extends BaseController {
  CatalogController(this._repository);

  final LocalCarRepository _repository;
  final ValueNotifier<List<Car>> _filtered = ValueNotifier<List<Car>>(<Car>[]);

  ValueNotifier<List<Car>> get filteredCars => _filtered;

  Future<void> load() async {
    final cars = await _repository.fetchCars();
    _filtered.value = cars;
    notifyListeners();
  }

  void applyFilter(String query) {
    final lower = query.toLowerCase();
    _filtered.value = _filtered.value.where((car) => car.fullName.toLowerCase().contains(lower)).toList();
    notifyListeners();
  }
}

class SearchController extends BaseController {
  SearchController(this._repository);

  final LocalCarRepository _repository;
  final ValueNotifier<List<Car>> _results = ValueNotifier<List<Car>>(<Car>[]);

  ValueNotifier<List<Car>> get results => _results;

  Future<void> search(String query) async {
    final all = await _repository.fetchCars();
    final lower = query.trim().toLowerCase();
    _results.value = all.where((car) => car.matchesQuery(lower)).toList();
    notifyListeners();
  }
}

class CarDetailsController extends BaseController {
  CarDetailsController(this._repository);

  final LocalCarRepository _repository;

  Future<Car?> findById(String id) async {
    final cars = await _repository.fetchCars();
    return cars.firstWhere((element) => element.id == id, orElse: () => Car.empty());
  }
}

class CompareController extends BaseController {
  CompareController(this._prefs);

  final SharedPreferences _prefs;
  final ValueNotifier<List<String>> _selected = ValueNotifier<List<String>>(<String>[]);

  ValueNotifier<List<String>> get selected => _selected;

  Future<void> load() async {
    final saved = _prefs.getStringList(AppPreferences.compareList) ?? <String>[];
    _selected.value = saved;
  }

  Future<void> toggle(String carId) async {
    final list = List<String>.from(_selected.value);
    if (list.contains(carId)) {
      list.remove(carId);
    } else if (list.length < 4) {
      list.add(carId);
    }
    _selected.value = list;
    await _prefs.setStringList(AppPreferences.compareList, list);
    notifyListeners();
  }

  Future<void> clear() async {
    _selected.value = <String>[];
    await _prefs.remove(AppPreferences.compareList);
    notifyListeners();
  }
}

class MyCarController extends BaseController {
  MyCarController(this._prefs);

  final SharedPreferences _prefs;
  final ValueNotifier<List<Car>> _myCars = ValueNotifier<List<Car>>(<Car>[]);

  ValueNotifier<List<Car>> get cars => _myCars;

  Future<void> load() async {
    final raw = _prefs.getString(AppPreferences.myCars);
    if (raw == null) return;
    final list = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    _myCars.value = list.map(Car.fromJson).toList();
    notifyListeners();
  }

  Future<void> addCar(Car car) async {
    final updated = List<Car>.from(_myCars.value)..add(car);
    _myCars.value = updated;
    await _prefs.setString(AppPreferences.myCars, jsonEncode(updated.map((e) => e.toJson()).toList()));
    notifyListeners();
  }
}

class NotificationController extends BaseController {
  NotificationController(this._prefs);

  final SharedPreferences _prefs;
  final ValueNotifier<List<AppNotification>> _notifications = ValueNotifier<List<AppNotification>>(<AppNotification>[]);

  ValueNotifier<List<AppNotification>> get notifications => _notifications;

  Future<void> load() async {
    final raw = _prefs.getString(AppPreferences.notifications);
    if (raw == null) return;
    final list = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    _notifications.value = list.map(AppNotification.fromJson).toList();
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    final updated = List<AppNotification>.from(_notifications.value)..add(notification);
    _notifications.value = updated;
    await _prefs.setString(AppPreferences.notifications, jsonEncode(updated.map((e) => e.toJson()).toList()));
    notifyListeners();
  }
}

class TipsController extends BaseController {
  TipsController(this._dataSource);

  final LocalTipDataSource _dataSource;
  final ValueNotifier<List<Tip>> _tips = ValueNotifier<List<Tip>>(<Tip>[]);

  ValueNotifier<List<Tip>> get tips => _tips;

  Future<void> load() async {
    _tips.value = await _dataSource.fetchTips();
    notifyListeners();
  }
}

class AppControllerRegistry {
  AppControllerRegistry({
    required this.themeController,
    required this.localeController,
    required this.onboardingController,
    required this.authController,
    required this.coachMarkController,
    required this.homeController,
    required this.catalogController,
    required this.searchController,
    required this.carDetailsController,
    required this.compareController,
    required this.myCarController,
    required this.notificationController,
    required this.tipsController,
  });

  final ThemeController themeController;
  final LocaleController localeController;
  final OnboardingController onboardingController;
  final AuthController authController;
  final CoachMarkController coachMarkController;
  final HomeController homeController;
  final CatalogController catalogController;
  final SearchController searchController;
  final CarDetailsController carDetailsController;
  final CompareController compareController;
  final MyCarController myCarController;
  final NotificationController notificationController;
  final TipsController tipsController;

  void dispose() {
    themeController.dispose();
    localeController.dispose();
    onboardingController.dispose();
    authController.dispose();
    coachMarkController.dispose();
    homeController.dispose();
    catalogController.dispose();
    searchController.dispose();
    carDetailsController.dispose();
    compareController.dispose();
    myCarController.dispose();
    notificationController.dispose();
    tipsController.dispose();
  }
}

extension _ThemeModeFromString on String {
  ThemeMode toThemeMode() {
    switch (this) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}

extension _ColorParsing on Color {
  String get hexString => ColorUtils.toHex(this);
}

extension _NullableMapper<T> on T {
  R? let<R>(R Function(T value) mapper) {
    return mapper(this);
  }
}

class AppPreferences {
  static const locale = 'autoink.locale';
  static const themeMode = 'autoink.themeMode';
  static const primaryColor = 'autoink.primaryColor';
  static const authUser = 'autoink.auth.user.json';
  static const favorites = 'autoink.favorites.list';
  static const compareList = 'autoink.compare.list';
  static const myCars = 'autoink.mycars.json';
  static const listings = 'autoink.listings.json';
  static const hasSeenOnboarding = 'autoink.onboarding.seen';
  static const notifications = 'autoink.notifications.json';
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    required this.isGuest,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isGuest;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'is_guest': isGuest,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      isGuest: json['is_guest'] as bool? ?? false,
    );
  }
}

class AppNotification {
  const AppNotification({required this.title, required this.message, required this.createdAt});

  final String title;
  final String message;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'message': message,
        'created_at': createdAt.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
