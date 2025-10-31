import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/tutorial_controller.dart';
import '../../../core/theme/app_theme.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.controller});

  final TutorialController controller;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: colors.background.withOpacity(0.9),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Coach-marks will highlight the key hotspots in the app. This is a placeholder overlay.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(color: colors.onBackground),
              ),
              const SizedBox(height: 24),
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.onSurface, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.touch_app, color: colors.accent, size: 56)
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 700.ms)
                    .fadeIn(duration: 300.ms),
              ),
              const SizedBox(height: 24),
              Text(
                'Step ${widget.controller.currentIndex + 1} of ${widget.controller.steps.length}\n${widget.controller.currentStep}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  widget.controller.next();
                  if (!widget.controller.isVisible) {
                    Navigator.pop(context);
                  } else {
                    setState(() {});
                  }
                },
                child: Text(widget.controller.currentIndex == widget.controller.steps.length - 1 ? 'Finish' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
