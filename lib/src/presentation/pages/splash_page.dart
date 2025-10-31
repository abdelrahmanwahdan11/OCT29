import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../application/controllers/app_controllers.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final seen = widget.controllers.onboardingController.hasSeen;
    Navigator.of(context).pushReplacementNamed(seen ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.onBackground, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
              ),
              child: Text('AutoInk', style: theme.textTheme.headlineLarge).animate().fade(duration: const Duration(milliseconds: 600)),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator().animate().scale(duration: const Duration(milliseconds: 600)),
          ],
        ),
      ),
    );
  }
}
