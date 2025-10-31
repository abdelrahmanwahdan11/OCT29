import 'dart:async';

import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../core/localization/app_localizations.dart';
import '../components/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  Timer? _timer;

  final _pages = const <String>['onboarding_title_1', 'onboarding_title_2', 'onboarding_title_3'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final next = (_pageController.page?.round() ?? 0) + 1;
      if (next >= _pages.length) {
        _complete();
      } else {
        _pageController.animateToPage(next, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      }
    });
  }

  void _complete() {
    widget.controllers.onboardingController.markSeen();
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return GestureDetector(
      onTapDown: (_) => _timer?.cancel(),
      onTapUp: (_) => _startAutoAdvance(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (value) => widget.controllers.onboardingController.pageIndex.value = value,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(localization.translate(_pages[index]), style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          Text(localization.translate('onboarding_body_${index + 1}'), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: widget.controllers.onboardingController.pageIndex,
                builder: (context, value, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => GestureDetector(
                        onTap: () => _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.all(4),
                          height: 10,
                          width: value == index ? 20 : 10,
                          decoration: BoxDecoration(
                            color: value == index ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: <Widget>[
                    PrimaryButton(label: localization.translate('onboarding_title_2'), onPressed: () => _complete()),
                    const SizedBox(height: 8),
                    TextButton(onPressed: _complete, child: Text(localization.translate('run_tutorial'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
