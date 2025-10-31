import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'application/controllers/app_controllers.dart';
import 'core/localization/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/eink_theme.dart';

class AppControllerScope extends InheritedWidget {
  const AppControllerScope({required this.controllers, required super.child, super.key});

  final AppControllerRegistry controllers;

  static AppControllerRegistry of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppControllerScope>();
    assert(scope != null, 'AppControllerScope not found');
    return scope!.controllers;
  }

  @override
  bool updateShouldNotify(covariant AppControllerScope oldWidget) => controllers != oldWidget.controllers;
}

class AutoInkApp extends StatefulWidget {
  const AutoInkApp({required this.controllers, super.key});

  final AppControllerRegistry controllers;

  @override
  State<AutoInkApp> createState() => _AutoInkAppState();
}

class _AutoInkAppState extends State<AutoInkApp> {
  late final AppRouter _router;
  late final EInkTheme _theme;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(widget.controllers);
    _theme = const EInkTheme();
    if (widget.controllers.localeController.locale.languageCode == 'ar') {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = widget.controllers.themeController;
    final localeController = widget.controllers.localeController;

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[themeController, localeController]),
      builder: (context, _) {
        final themeMode = themeController.themeMode;
        final accent = themeController.accentColor;
        final locale = localeController.locale;
        return AppControllerScope(
          controllers: widget.controllers,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AutoInk',
            theme: _theme.lightTheme(accent),
            darkTheme: _theme.darkTheme(accent),
            themeMode: themeMode,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            builder: (context, child) {
              final direction = locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
              return Directionality(textDirection: direction, child: child ?? const SizedBox.shrink());
            },
            onGenerateRoute: _router.onGenerateRoute,
            initialRoute: '/splash',
          ),
        );
      },
    );
  }
}
