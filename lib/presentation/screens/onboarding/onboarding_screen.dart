import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../core/localization/app_localizations.dart';

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
      subtitleAr: 'ثيم داكن ولون رئيسي مخصص',
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
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _index = (_index + 1) % _pages.length;
      _pageController.animateToPage(
        _index,
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
    final isArabic = localization.locale.languageCode == 'ar';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
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
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Image.network(
                                page.image,
                                fit: BoxFit.cover,
                              ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          isArabic ? page.titleAr : page.titleEn,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isArabic ? page.subtitleAr : page.subtitleEn,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  height: 6,
                  width: _index == index ? 32 : 12,
                  decoration: BoxDecoration(
                    color: _index == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                    child: Text(localization.t('skip')),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_index < _pages.length - 1) {
                        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
                      } else {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    },
                    child: Text(_index < _pages.length - 1 ? localization.t('next') : localization.t('get_started')),
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
