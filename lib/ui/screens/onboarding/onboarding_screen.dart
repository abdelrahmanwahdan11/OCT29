import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;

  List<_OnboardingPage> _buildPages(AppLocalizations localization) {
    return [
      _OnboardingPage(
        icon: Icons.storefront,
        title: localization.translate('welcome_headline'),
        body: localization.translate('welcome_body'),
      ),
      _OnboardingPage(
        icon: Icons.lock_open_rounded,
        title: localization.translate('secure_headline'),
        body: localization.translate('secure_body'),
      ),
      _OnboardingPage(
        icon: Icons.explore,
        title: localization.translate('explore_headline'),
        body: localization.translate('explore_body'),
      ),
    ];
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _complete(BuildContext context) async {
    final appState = AppScope.of(context);
    await appState.completeOnboarding();
    final target = appState.isAuthenticated ? AppRoutes.home : AppRoutes.login;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(target);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pages = _buildPages(localization);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => _complete(context),
                  child: Text(localization.translate('skip')),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.icon, size: 160, color: theme.colorScheme.primary)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(.8, .8), end: const Offset(1, 1)),
                        const SizedBox(height: 32),
                        Text(page.title, style: theme.textTheme.displayLarge, textAlign: TextAlign.center)
                            .animate()
                            .fadeIn(duration: 450.ms)
                            .slideY(begin: .2, curve: Curves.easeOut),
                        const SizedBox(height: 16),
                        Text(page.body, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center)
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: .3, curve: Curves.easeOut),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == i ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _index == i ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (_index > 0)
                    OutlinedButton(
                      onPressed: () => _goTo(_index - 1),
                      child: Text(localization.translate('previous')),
                    )
                  else
                    const SizedBox(width: 120),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_index == pages.length - 1) {
                        _complete(context);
                      } else {
                        _goTo(_index + 1);
                      }
                    },
                    child: Text(_index == pages.length - 1
                        ? localization.translate('finish')
                        : localization.translate('next')),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}
