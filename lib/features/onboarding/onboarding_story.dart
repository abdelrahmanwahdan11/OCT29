import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../shared/ui_kit/pill_button.dart';

class OnboardingStory extends StatefulWidget {
  const OnboardingStory({super.key, required this.onFinish});

  final void Function(BuildContext context, bool browseAsGuest) onFinish;

  @override
  State<OnboardingStory> createState() => _OnboardingStoryState();
}

class _OnboardingStoryState extends State<OnboardingStory> with SingleTickerProviderStateMixin {
  late final PageController pageController;
  late final AnimationController progressController;
  int currentPage = 0;
  bool isHolding = false;

  final slides = const [
    _OnboardingSlide(title: 'اكتشف أفضل الصفقات', subtitle: 'مزادات شفافة وسريعة', icon: IconlyBold.flash),
    _OnboardingSlide(title: 'اطلب ما تريده', subtitle: 'طلبات شراء بمواصفاتك', icon: IconlyBold.bag),
    _OnboardingSlide(title: 'ادفع بأمان', subtitle: 'حجز المبلغ حتى الاستلام', icon: IconlyBold.shield_done),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    progressController = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !isHolding) {
          _nextPage();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    pageController.dispose();
    progressController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < slides.length - 1) {
      setState(() => currentPage += 1);
      pageController.animateToPage(currentPage, duration: 400.ms, curve: Curves.easeOutCubic);
      progressController.forward(from: 0);
    } else {
      widget.onFinish(context, false);
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      setState(() => currentPage -= 1);
      pageController.animateToPage(currentPage, duration: 400.ms, curve: Curves.easeOutCubic);
      progressController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _nextPage,
      onLongPressStart: (_) {
        isHolding = true;
        progressController.stop();
      },
      onLongPressEnd: (_) {
        isHolding = false;
        progressController.forward();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: List.generate(
                    slides.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedBuilder(
                          animation: progressController,
                          builder: (context, child) {
                            double value;
                            if (index < currentPage) {
                              value = 1;
                            } else if (index == currentPage) {
                              value = progressController.value;
                            } else {
                              value = 0;
                            }
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation(Color(0xFFFF8E3C)),
                              minHeight: 4,
                              borderRadius: BorderRadius.circular(12),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(slide.icon, color: const Color(0xFF10B6E8), size: 120)
                            .animate()
                            .scale(duration: 600.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 32),
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white70,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    PillButton(
                      label: 'ابدأ الآن',
                      style: PillButtonStyle.gradient,
                      onPressed: () => widget.onFinish(context, false),
                    ),
                    const SizedBox(height: 12),
                    PillButton(
                      label: 'تصفح كضيف',
                      onPressed: () => widget.onFinish(context, true),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slides.length,
                        (index) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index ? Colors.white : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _prevPage,
                      child: const Text('رجوع'),
                    ),
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

class _OnboardingSlide {
  const _OnboardingSlide({required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;
}
