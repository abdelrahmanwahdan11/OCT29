import 'package:flutter/material.dart';

import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class CreateWantedScreen extends StatefulWidget {
  const CreateWantedScreen({super.key});

  @override
  State<CreateWantedScreen> createState() => _CreateWantedScreenState();
}

class _CreateWantedScreenState extends State<CreateWantedScreen> {
  int currentStep = 0;

  List<Step> buildSteps(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return [
      Step(title: Text(strings.t('create_wanted')), content: _TextPlaceholder(label: strings.t('filters'))),
      Step(title: Text(strings.t('wallet_balance')), content: _TextPlaceholder(label: 'Budget range')),
      Step(title: Text(strings.t('orders_timeline')), content: _TextPlaceholder(label: 'When do you need it?')),
      Step(title: Text(strings.t('support')), content: _TextPlaceholder(label: 'Preferred pickup or delivery radius')),
      Step(title: Text(strings.t('create_wanted')), content: _TextPlaceholder(label: 'Review summary before publishing')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    final steps = buildSteps(context);
    return GlassPageScaffold(
      title: strings.t('create_wanted'),
      imageUrl: 'https://images.unsplash.com/photo-1515165562835-c3b8b1eea6cf?q=80&w=1600',
      body: Stepper(
        currentStep: currentStep,
        steps: steps,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              FilledButton(
                onPressed: details.onStepContinue,
                child: Text(details.currentStep == steps.length - 1 ? strings.t('confirm') : strings.t('next')),
              ),
              const SizedBox(width: 12),
              TextButton(onPressed: details.onStepCancel, child: Text(strings.t('back'))),
            ],
          );
        },
        onStepContinue: () {
          if (currentStep < steps.length - 1) {
            setState(() => currentStep++);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.t('request_published'))));
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep--);
          }
        },
      ),
    );
  }
}

class _TextPlaceholder extends StatelessWidget {
  const _TextPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(hintText: label),
    );
  }
}
