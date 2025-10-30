import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  static const _duration = Duration(milliseconds: 300);

  List<Map<String, String>> _slides(AppLocalizations l10n) => [
        {
          'title': l10n.string('onb1_t'),
          'desc': l10n.string('onb1_d'),
          'image': 'https://picsum.photos/id/237/800/1000',
        },
        {
          'title': l10n.string('onb2_t'),
          'desc': l10n.string('onb2_d'),
          'image': 'https://picsum.photos/id/1025/800/1000',
        },
        {
          'title': l10n.string('onb3_t'),
          'desc': l10n.string('onb3_d'),
          'image': 'https://picsum.photos/id/1062/800/1000',
        },
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _complete(BuildContext context) async {
    final appState = AppStateScope.of(context);
    await appState.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _slides(l10n);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: _updateIndex,
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              slide['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: PageTransitionSwitcher(
                          duration: _duration,
                          transitionBuilder: (child, primary, secondary) {
                            return SharedAxisTransition(
                              animation: primary,
                              secondaryAnimation: secondary,
                              transitionType: SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                          child: Column(
                            key: ValueKey(slide['title']),
                            children: [
                              Text(
                                slide['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                slide['desc']!,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => _complete(context),
                    child: Text(l10n.string('skip')),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      slides.length,
                      (index) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentIndex
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (_currentIndex == slides.length - 1) {
                        _complete(context);
                      } else {
                        _controller.nextPage(
                          duration: _duration,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(_currentIndex == slides.length - 1
                        ? l10n.string('start')
                        : l10n.string('next')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
