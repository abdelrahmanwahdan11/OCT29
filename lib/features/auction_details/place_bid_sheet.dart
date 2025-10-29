import 'package:flutter/material.dart';

import '../../shared/ui_kit/pill_button.dart';
import '../../shared/utils/app_localizations.dart';

class PlaceBidSheet extends StatefulWidget {
  const PlaceBidSheet({super.key, required this.currentBid});

  final double currentBid;

  @override
  State<PlaceBidSheet> createState() => _PlaceBidSheetState();
}

class _PlaceBidSheetState extends State<PlaceBidSheet> {
  late final TextEditingController amountController;
  bool proxyEnabled = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: (widget.currentBid + 50).toStringAsFixed(0));
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(strings.t('place_bid'), style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.payments_outlined), labelText: strings.t('place_bid')),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(strings.t('filters')),
            value: proxyEnabled,
            onChanged: (value) => setState(() => proxyEnabled = value),
          ),
          const SizedBox(height: 16),
          PillButton(
            label: strings.t('place_bid'),
            onPressed: () => Navigator.of(context).pop(amountController.text),
          ),
        ],
      ),
    );
  }
}
