import 'package:flutter/material.dart';

import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  State<CreateAuctionScreen> createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  int currentStep = 0;

  List<Step> buildSteps(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return [
      Step(title: Text(strings.t('create_auction')), content: _TextPlaceholder(label: strings.t('filters'))),
      Step(title: Text(strings.t('wallet_balance')), content: _TextPlaceholder(label: 'Start price / reserve / buy now')),
      Step(title: Text(strings.t('orders')), content: _TextPlaceholder(label: 'Pickup, shipping, delivery')),
      Step(title: Text(strings.t('support_tickets')), content: _TextPlaceholder(label: 'Photos & video quality checks')),
      Step(title: Text(strings.t('create_auction')), content: _TextPlaceholder(label: 'Confirm draft and publish')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    final steps = buildSteps(context);
    return GlassPageScaffold(
      title: strings.t('create_auction'),
      imageUrl: 'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
      body: Stepper(
        currentStep: currentStep,
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
        steps: steps,
        onStepContinue: () {
          if (currentStep < steps.length - 1) {
            setState(() => currentStep++);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.t('draft_saved'))));
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
      maxLines: 4,
      decoration: InputDecoration(
        hintText: label,
      ),
    );
  }
}
