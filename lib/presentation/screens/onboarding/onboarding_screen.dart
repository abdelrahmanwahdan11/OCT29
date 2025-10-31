import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.appController});

  final AppController appController;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;
  Timer? _timer;

  final List<_StoryPage> _pages = const <_StoryPage>[
    _StoryPage(
      titleEn: 'Discover Your Dream Car',
      titleAr: 'اكتشف سيارات أحلامك',
      subtitleEn: '3D viewer & smart comparisons',
      subtitleAr: 'واجهة ثلاثية الأبعاد ومقارنات ذكية',
      image: 'https://images.unsplash.com/photo-1511391400387-6c59ef2f89aa',
    ),
    _StoryPage(
      titleEn: 'Sell Your Car Easily',
      titleAr: 'بع سيارتك بسهولة',
      subtitleEn: 'List with one tap & receive offers',
      subtitleAr: 'أدرجها بضغطة وحدد عروض الشراء',
      image: 'https://images.unsplash.com/photo-1519580930521-3dba8f04a47d',
    ),
    _StoryPage(
      titleEn: 'Control Your Experience',
      titleAr: 'تحكم بالتجربة',
      subtitleEn: 'Dark theme & custom primary color',
      subtitleAr: 'ثيم داكن ولون أساسي مخصص',
      image: 'https://images.unsplash.com/photo-1494972688394-4cc796f9e4c1',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_index + 1) % _pages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
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
    final colors = AppColors.of(context);
    final isArabic = localization.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final cardHeight = math.min(constraints.maxHeight * 0.55, 440.0);
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 420),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.accent.withOpacity(0.2),
                              colors.card,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            _index = value;
                            _startTimer();
                          });
                        },
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final page = _pages[index];
                          final title = isArabic ? page.titleAr : page.titleEn;
                          final subtitle = isArabic ? page.subtitleAr : page.subtitleEn;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.accent.withOpacity(0.18),
                                          blurRadius: 42,
                                          offset: const Offset(0, 28),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            page.image,
                                            fit: BoxFit.cover,
                                          ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.96, 0.96)),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: cardHeight * 0.45,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    colors.card.withOpacity(0),
                                                    colors.card.withOpacity(0.86),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 32,
                                            left: 24,
                                            right: 24,
                                            child: Semantics(
                                              header: true,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: maxWidth > 480 ? 30 : 26,
                                                          color: colors.onSurface,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    subtitle,
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.accent.withOpacity(0.1),
                                        blurRadius: 24,
                                        offset: const Offset(0, 18),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localization.t('onboarding_story_${index + 1}'),
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        localization.t('onboarding_caption_${index + 1}'),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: 8,
                            width: _index == index ? 32 : 12,
                            decoration: BoxDecoration(
                              color: _index == index ? colors.accent : colors.accent.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                            child: Text(localization.t('skip')),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (_index < _pages.length - 1) {
                                _pageController.nextPage(duration: const Duration(milliseconds: 420), curve: Curves.ease);
                              } else {
                                Navigator.of(context).pushReplacementNamed('/home');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: Text(_index < _pages.length - 1 ? localization.t('next') : localization.t('get_started')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StoryPage {
  const _StoryPage({
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.image,
  });

  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final String image;
}
